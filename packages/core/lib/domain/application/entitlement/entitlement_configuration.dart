// part of ednet_core;
//
// /// Configuration for the entitlement system.
// ///
// /// The [EntitlementConfiguration] class provides a way to configure
// /// the entitlement system in a declarative way. It allows:
// /// - Defining roles and their permissions
// /// - Setting up resource hierarchies
// /// - Configuring field-level access control
// /// - Defining operation mappings
// ///
// /// Example usage:
// /// ```dart
// /// final config = EntitlementConfiguration()
// ///   ..addRole('admin', [
// ///     Permission('*', '*'),
// ///   ])
// ///   ..addRole('user', [
// ///     Permission('Task', 'read'),
// ///     Permission('Task', 'create'),
// ///   ]);
// ///
// /// // Apply the configuration
// /// SecurityManager.applyConfiguration(config);
// /// ```
// class EntitlementConfiguration {
//   /// Map of role names to roles.
//   final Map<String, Role> _roles = {};
//
//   /// Map of resource names to their parent resources.
//   final Map<String, String> _resourceHierarchy = {};
//
//   /// Map of resource names to field access configurations.
//   final Map<String, FieldAccessConfiguration> _fieldAccess = {};
//
//   /// Map of operation aliases to their actual operations.
//   final Map<String, String> _operationAliases = {
//     'read': 'read',
//     'write': 'write',
//     'create': 'create',
//     'update': 'update',
//     'delete': 'delete',
//     'view': 'read',
//     'edit': 'update',
//     'modify': 'update',
//     'remove': 'delete',
//   };
//
//   /// Creates a new entitlement configuration.
//   EntitlementConfiguration() {
//     // Add default operation aliases
//     _operationAliases['get'] = 'read';
//     _operationAliases['list'] = 'read';
//     _operationAliases['find'] = 'read';
//     _operationAliases['retrieve'] = 'read';
//     _operationAliases['search'] = 'read';
//     _operationAliases['query'] = 'read';
//
//     _operationAliases['add'] = 'create';
//     _operationAliases['insert'] = 'create';
//     _operationAliases['new'] = 'create';
//
//     _operationAliases['save'] = 'update';
//     _operationAliases['change'] = 'update';
//     _operationAliases['modify'] = 'update';
//
//     _operationAliases['erase'] = 'delete';
//     _operationAliases['destroy'] = 'delete';
//     _operationAliases['purge'] = 'delete';
//   }
//
//   /// Adds a role with the specified permissions.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the role
//   /// - [permissions]: The permissions for this role
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   EntitlementConfiguration addRole(String name, List<Permission> permissions) {
//     _roles[name] = Role(name, permissions);
//     return this;
//   }
//
//   /// Gets all defined roles.
//   ///
//   /// Returns:
//   /// A map of role names to roles
//   Map<String, Role> getRoles() {
//     return Map.unmodifiable(_roles);
//   }
//
//   /// Gets a specific role by name.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the role
//   ///
//   /// Returns:
//   /// The role with the specified name, or null if not found
//   Role? getRole(String name) {
//     return _roles[name];
//   }
//
//   /// Sets a parent-child relationship between resources.
//   ///
//   /// This is used for hierarchical permission inheritance. For example,
//   /// if 'Project.Task' has 'Project' as its parent, then a permission on
//   /// 'Project' may imply a permission on 'Project.Task'.
//   ///
//   /// Parameters:
//   /// - [childResource]: The child resource
//   /// - [parentResource]: The parent resource
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   EntitlementConfiguration setResourceParent(String childResource, String parentResource) {
//     _resourceHierarchy[childResource] = parentResource;
//     return this;
//   }
//
//   /// Gets the parent of a resource.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource to get the parent for
//   ///
//   /// Returns:
//   /// The parent resource, or null if no parent is defined
//   String? getResourceParent(String resource) {
//     return _resourceHierarchy[resource];
//   }
//
//   /// Sets the field access configuration for a resource.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource to set field access for
//   /// - [configuration]: The field access configuration
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   EntitlementConfiguration setFieldAccess(String resource, FieldAccessConfiguration configuration) {
//     _fieldAccess[resource] = configuration;
//     return this;
//   }
//
//   /// Gets the field access configuration for a resource.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource to get field access for
//   ///
//   /// Returns:
//   /// The field access configuration, or null if not defined
//   FieldAccessConfiguration? getFieldAccess(String resource) {
//     return _fieldAccess[resource];
//   }
//
//   /// Adds an operation alias.
//   ///
//   /// Operation aliases allow different operation names to map to
//   /// the same underlying operation. For example, 'view' could be
//   /// an alias for 'read'.
//   ///
//   /// Parameters:
//   /// - [alias]: The alias for the operation
//   /// - [operation]: The actual operation name
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   EntitlementConfiguration addOperationAlias(String alias, String operation) {
//     _operationAliases[alias] = operation;
//     return this;
//   }
//
//   /// Gets the canonical operation name for an operation or its alias.
//   ///
//   /// Parameters:
//   /// - [operation]: The operation name or alias
//   ///
//   /// Returns:
//   /// The canonical operation name, or the original name if no alias is defined
//   String resolveOperation(String operation) {
//     return _operationAliases[operation] ?? operation;
//   }
//
//   /// Validates the configuration for consistency.
//   ///
//   /// This method checks for:
//   /// - Circular resource hierarchies
//   /// - Invalid permission references
//   /// - Missing required configurations
//   ///
//   /// Returns:
//   /// True if the configuration is valid, false otherwise
//   bool validate() {
//     // Check for circular resource hierarchies
//     final visited = <String>{};
//     final recursionStack = <String>{};
//
//     for (var resource in _resourceHierarchy.keys) {
//       if (!_checkForResourceHierarchyCycle(resource, visited, recursionStack)) {
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   /// Checks for cycles in the resource hierarchy.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource to check
//   /// - [visited]: Set of already visited resources
//   /// - [recursionStack]: Set of resources in the current recursion stack
//   ///
//   /// Returns:
//   /// True if no cycle is found, false otherwise
//   bool _checkForResourceHierarchyCycle(
//     String resource,
//     Set<String> visited,
//     Set<String> recursionStack,
//   ) {
//     if (!visited.contains(resource)) {
//       visited.add(resource);
//       recursionStack.add(resource);
//
//       String? parent = _resourceHierarchy[resource];
//       if (parent != null) {
//         if (!visited.contains(parent) && !_checkForResourceHierarchyCycle(parent, visited, recursionStack)) {
//           return false;
//         } else if (recursionStack.contains(parent)) {
//           return false;
//         }
//       }
//     }
//
//     recursionStack.remove(resource);
//     return true;
//   }
// }
//
// /// Configuration for field-level access control.
// ///
// /// The [FieldAccessConfiguration] class defines which fields of a resource
// /// are accessible for different operations. It supports:
// /// - Public fields: readable by any user with read permission
// /// - Protected fields: readable only by users with specific permissions
// /// - Private fields: not readable by regular users
// ///
// /// Example usage:
// /// ```dart
// /// final fieldConfig = FieldAccessConfiguration()
// ///   ..setPublicFields(['name', 'description', 'status'])
// ///   ..setProtectedFields(['email', 'phone'], 'User:read_protected')
// ///   ..setPrivateFields(['passwordHash', 'securityQuestion']);
// /// ```
// class FieldAccessConfiguration {
//   /// Map of field names to the permission required to access them.
//   final Map<String, String?> _fieldPermissions = {};
//
//   /// Creates a new field access configuration.
//   FieldAccessConfiguration();
//
//   /// Sets the public fields for this resource.
//   ///
//   /// Public fields are accessible to any user with read permission
//   /// for the resource.
//   ///
//   /// Parameters:
//   /// - [fields]: The list of public field names
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   FieldAccessConfiguration setPublicFields(List<String> fields) {
//     for (var field in fields) {
//       _fieldPermissions[field] = null; // null means public
//     }
//     return this;
//   }
//
//   /// Sets the protected fields for this resource.
//   ///
//   /// Protected fields are only accessible to users with the specified permission.
//   ///
//   /// Parameters:
//   /// - [fields]: The list of protected field names
//   /// - [permission]: The permission required to access these fields
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   FieldAccessConfiguration setProtectedFields(List<String> fields, String permission) {
//     for (var field in fields) {
//       _fieldPermissions[field] = permission;
//     }
//     return this;
//   }
//
//   /// Sets the private fields for this resource.
//   ///
//   /// Private fields are not accessible to regular users, only to users
//   /// with administrative permissions.
//   ///
//   /// Parameters:
//   /// - [fields]: The list of private field names
//   ///
//   /// Returns:
//   /// This configuration for chaining
//   FieldAccessConfiguration setPrivateFields(List<String> fields) {
//     for (var field in fields) {
//       _fieldPermissions[field] = '*:admin'; // Special admin permission
//     }
//     return this;
//   }
//
//   /// Gets the permission required to access a field.
//   ///
//   /// Parameters:
//   /// - [field]: The field name
//   ///
//   /// Returns:
//   /// The permission required, or null if the field is public
//   String? getFieldPermission(String field) {
//     return _fieldPermissions[field];
//   }
//
//   /// Checks if a field is accessible with the current permissions.
//   ///
//   /// Parameters:
//   /// - [field]: The field name
//   ///
//   /// Returns:
//   /// True if the field is accessible, false otherwise
//   bool isFieldAccessible(String field) {
//     final permission = _fieldPermissions[field];
//     if (permission == null) {
//       // Public field, always accessible
//       return true;
//     }
//
//     // Check if the current subject has the required permission
//     return SecurityContext.hasPermissionString(permission);
//   }
// }
//
// /// Manager for security and entitlement functionality.
// ///
// /// The [SecurityManager] class serves as the central point for security
// /// operations. It provides:
// /// - Configuration loading and validation
// /// - Permission checking
// /// - Security policy enforcement
// /// - Audit logging
// ///
// /// Example usage:
// /// ```dart
// /// // Apply configuration
// /// SecurityManager.applyConfiguration(entitlementConfig);
// ///
// /// // Check permissions
// /// if (SecurityManager.hasResourcePermission('Task', 'update')) {
// ///   // Update task
// /// }
// /// ```
// class SecurityManager {
//   /// The current entitlement configuration.
//   static EntitlementConfiguration? _configuration;
//
//   /// Whether to enforce security checks.
//   static bool enforceSecurityChecks = true;
//
//   /// Applies an entitlement configuration.
//   ///
//   /// This method validates the configuration and applies it
//   /// if it's valid.
//   ///
//   /// Parameters:
//   /// - [configuration]: The configuration to apply
//   ///
//   /// Returns:
//   /// True if the configuration was applied successfully, false otherwise
//   static bool applyConfiguration(EntitlementConfiguration configuration) {
//     if (!configuration.validate()) {
//       return false;
//     }
//
//     _configuration = configuration;
//     return true;
//   }
//
//   /// Checks if a permission is granted for the given resource and operation.
//   ///
//   /// This method:
//   /// 1. Checks if security is enforced
//   /// 2. Resolves operation aliases
//   /// 3. Checks the current subject's permissions
//   ///
//   /// Parameters:
//   /// - [resource]: The resource to check permission for
//   /// - [operation]: The operation to check permission for
//   ///
//   /// Returns:
//   /// True if the permission is granted, false otherwise
//   static bool hasResourcePermission(String resource, String operation) {
//     if (!enforceSecurityChecks) {
//       return true;
//     }
//
//     // Resolve operation alias if we have a configuration
//     if (_configuration != null) {
//       operation = _configuration!.resolveOperation(operation);
//     }
//
//     // Check permission
//     return SecurityContext.hasPermission(Permission(resource, operation));
//   }
//
//   /// Requires a permission for the given resource and operation.
//   ///
//   /// This method checks the permission and throws a [SecurityException]
//   /// if the permission is not granted.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource to require permission for
//   /// - [operation]: The operation to require permission for
//   ///
//   /// Throws:
//   /// [SecurityException] if the permission is not granted
//   static void requireResourcePermission(String resource, String operation) {
//     if (!hasResourcePermission(resource, operation)) {
//       throw SecurityException('Permission required: $resource:$operation');
//     }
//   }
//
//   /// Checks if a field is accessible with the current permissions.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource containing the field
//   /// - [field]: The field name
//   ///
//   /// Returns:
//   /// True if the field is accessible, false otherwise
//   static bool isFieldAccessible(String resource, String field) {
//     if (!enforceSecurityChecks) {
//       return true;
//     }
//
//     // Get field access configuration if available
//     final fieldAccess = _configuration?.getFieldAccess(resource);
//     if (fieldAccess != null) {
//       return fieldAccess.isFieldAccessible(field);
//     }
//
//     // Default to checking field-specific permission
//     return SecurityContext.hasPermission(Permission('$resource.$field', 'read'));
//   }
//
//   /// Logs a security event for audit purposes.
//   ///
//   /// Parameters:
//   /// - [eventType]: The type of security event
//   /// - [resource]: The resource involved
//   /// - [operation]: The operation being performed
//   /// - [success]: Whether the operation was successful
//   /// - [details]: Additional details about the event
//   static void logSecurityEvent(
//     String eventType,
//     String resource,
//     String operation,
//     bool success,
//     Map<String, dynamic> details
//   ) {
//     // In a real implementation, this would log to a secure audit log
//     // For now, just print to console
//     print('SECURITY EVENT: $eventType');
//     print('  Resource: $resource');
//     print('  Operation: $operation');
//     print('  Success: $success');
//     print('  Subject: ${SecurityContext.getCurrentSubject()}');
//     print('  Details: $details');
//   }
// }