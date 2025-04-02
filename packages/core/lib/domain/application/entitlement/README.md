# EDNet Core Entitlement System

The EDNet Core Entitlement System provides a comprehensive, flexible, and domain-agnostic authorization framework for your applications. It enables fine-grained access control at multiple levels, from service-level permissions to field-level security.

## Key Features

- **Role-Based Access Control (RBAC)**: Define roles and their associated permissions
- **Permission-Based Authorization**: Control access to resources based on operations
- **Field-Level Security**: Protect sensitive data fields based on user permissions
- **Entity-Level Policies**: Implement custom authorization logic on specific entities
- **Declarative Configuration**: Configure security rules in a clear, declarative way
- **Integration with Domain Model**: Seamless integration with the existing EDNet Core domain model
- **Command/Query Authorization**: Built-in support for CQRS authorization
- **Attribute-Based Authorization**: Annotate classes and methods with required permissions

## Core Concepts

### Permissions

Permissions are the building blocks of the entitlement system, represented as `resource:operation` pairs:

```dart
// Create a permission to read tasks
final readTaskPermission = Permission('Task', 'read');

// Create a permission to create users
final createUserPermission = Permission('User', 'create');

// Create a wildcard permission (allows everything)
final adminPermission = Permission('*', '*');
```

### Roles

Roles group permissions together, making it easy to assign multiple permissions at once:

```dart
// Create an admin role with full access
final adminRole = Role('admin', [Permission('*', '*')]);

// Create a user role with limited permissions
final userRole = Role('user', [
  Permission('Task', 'read'),
  Permission('Task', 'create'),
  Permission('User', 'read'),
]);
```

### Security Context

The `SecurityContext` class manages the current security subject (e.g., user) and provides methods for checking permissions:

```dart
// Set the current user
SecurityContext.setCurrentSubject(currentUser);

// Check a permission
if (SecurityContext.hasPermission(Permission('Task', 'create'))) {
  // Create a task
}

// Run with elevated privileges temporarily
SecurityContext.runWithSystemPrivileges(() {
  // Perform administrative operations
});
```

### Secure Application Services

Extend your application services with security checks:

```dart
class SecureTaskService extends SecureApplicationService<Task> {
  SecureTaskService(Repository<Task> repository)
      : super(repository, name: 'TaskService');
  
  @override
  List<Permission> getPermissionsForCommand(ICommand command) {
    if (command is CreateTaskCommand) {
      return [Permission('Task', 'create')];
    }
    return super.getPermissionsForCommand(command);
  }
}
```

### Entity-Level Authorization

Control access to individual entities using the `AuthorizationFor` mixin:

```dart
class Task extends Entity<Task> with AuthorizationFor<User, Task> {
  @override
  IEntities<IPolicy> get accessPolicies {
    final policies = Entities<IPolicy>();
    
    // Allow owners to do anything with their tasks
    if (assigneeId != null) {
      policies.add(OwnerPolicy<User>(ownerId: assigneeId!));
    }
    
    // Allow anyone to view completed tasks
    if (isCompleted == true) {
      policies.add(CommandPolicy<User>(
        allowedCommands: ['ViewTask'],
        requiredPermissions: ['Task:read'],
      ));
    }
    
    return policies;
  }
}
```

## Getting Started

### 1. Define Your Security Subject

Create a class that implements the `SecuritySubject` interface:

```dart
class User implements SecuritySubject {
  final String id;
  final String username;
  final List<Role> roles;
  
  User(this.id, this.username, this.roles);
}
```

### 2. Configure Roles and Permissions

Set up your entitlement configuration:

```dart
final config = EntitlementConfiguration()
  ..addRole('admin', [Permission('*', '*')])
  ..addRole('user', [
    Permission('Task', 'read'),
    Permission('Task', 'create'),
  ])
  ..setFieldAccess('Task', FieldAccessConfiguration()
    ..setPublicFields(['title', 'description'])
    ..setProtectedFields(['assigneeId'], 'Task:admin')
    ..setPrivateFields(['sensitiveData']));

SecurityManager.applyConfiguration(config);
```

### 3. Create Secure Application Services

Extend `SecureApplicationService` for your domain entities:

```dart
class TaskService extends SecureApplicationService<Task> {
  TaskService(Repository<Task> repository)
      : super(repository, name: 'TaskService');
      
  // Custom authorization logic here
}
```

### 4. Add Entity-Level Authorization

Use the `AuthorizationFor` mixin on your entities:

```dart
class Task extends Entity<Task> with AuthorizationFor<User, Task> {
  // Entity fields and methods
  
  @override
  IEntities<IPolicy> get accessPolicies {
    // Define authorization policies
  }
}
```

### 5. Set the Security Context

At the beginning of each request, set the current security subject:

```dart
void handleRequest(Request request) {
  final user = getUserFromRequest(request);
  SecurityContext.setCurrentSubject(user);
  
  try {
    // Process the request
  } finally {
    // Clear the security context at the end of the request
    SecurityContext.clear();
  }
}
```

## Field-Level Security

Control access to sensitive fields:

```dart
// Configure field access
config.setFieldAccess('User', FieldAccessConfiguration()
  .setPublicFields(['name', 'email'])
  .setProtectedFields(['phone'], 'User:admin')
  .setPrivateFields(['passwordHash']));

// Check field access
if (SecurityManager.isFieldAccessible('User', 'phone')) {
  // Show the phone field
}
```

## Attribute-Based Authorization

Register authorization attributes for your classes and methods:

```dart
// Register a type-level attribute
AuthorizationAttributeHandler.registerType('OrderService', [
  RequirePermission('Order', 'read'),
]);

// Register a method-level attribute
AuthorizationAttributeHandler.registerMethod('OrderService.createOrder', [
  RequirePermission('Order', 'create'),
]);

// Check authorization
if (AuthorizationAttributeHandler.isAuthorized(
  'OrderService.createOrder',
  'Order',
  'create'
)) {
  // Execute the method
}
```

## Security Policies

The system provides several built-in policy types:

### OwnerPolicy

Allows operations if the user is the owner of the entity:

```dart
policies.add(OwnerPolicy<User>(ownerId: task.assigneeId!));
```

### CommandPolicy

Allows specific commands if the user has the required permissions:

```dart
policies.add(CommandPolicy<User>(
  allowedCommands: ['ViewTask', 'UpdateTask'],
  requiredPermissions: ['Task:read', 'Task:update'],
));
```

### AttributePolicy

Allows operations based on entity attributes:

```dart
policies.add(AttributePolicy<User>(
  attributeName: 'isCompleted',
  attributeValue: true,
  allowedCommands: ['ArchiveTask'],
  requiredPermissions: ['Task:archive'],
));
```

## Example

See the `entitlement_example.dart` file for a complete working example that demonstrates the key features of the entitlement system.

## Integration with EDNet Core

The entitlement system integrates with:

- **Application Services**: For command/query authorization
- **Queries**: For filtering results based on permissions
- **Domain Model**: For entity-level policies
- **Repositories**: For secure data access

This ensures consistent security throughout your application. 