part of ednet_core;

/// A permission represents an operation that can be performed on a resource.
///
/// The [Permission] class follows a resource:operation format where:
/// - resource: The target of the permission (e.g., concept name, '*' for all)
/// - operation: The action that can be performed (e.g., read, write, delete)
///
/// Examples:
/// - `Task:read` - Permission to read Task entities
/// - `User:write` - Permission to create/update User entities
/// - `*:read` - Permission to read all entities
/// - `Task:*` - Permission to perform all operations on Task entities
///
/// You can also use hierarchical resources with dots:
/// - `Project.Task:read` - Permission to read Task entities within Projects
class Permission {
  /// The resource this permission applies to
  final String resource;
  
  /// The operation this permission allows
  final String operation;
  
  /// Creates a new permission.
  ///
  /// Parameters:
  /// - [resource]: The resource this permission applies to
  /// - [operation]: The operation this permission allows
  const Permission(this.resource, this.operation);
  
  /// Creates a permission from a string in the format "resource:operation".
  ///
  /// Example: `Permission.fromString("Task:read")`
  factory Permission.fromString(String permissionString) {
    final parts = permissionString.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Permission must be in format "resource:operation"');
    }
    return Permission(parts[0], parts[1]);
  }
  
  /// Checks if this permission implies another permission.
  ///
  /// A permission implies another if:
  /// - It's a wildcard permission (`*:*`)
  /// - Resource is wildcard and operations match (`*:read` implies `Task:read`)
  /// - Operation is wildcard and resources match (`Task:*` implies `Task:read`)
  /// - They exactly match (`Task:read` implies `Task:read`)
  ///
  /// Parameters:
  /// - [other]: The permission to check against
  ///
  /// Returns:
  /// True if this permission implies the other permission
  bool implies(Permission other) {
    // Wildcard permission implies everything
    if (resource == '*' && operation == '*') {
      return true;
    }
    
    // Resource wildcard, operation must match
    if (resource == '*' && operation == other.operation) {
      return true;
    }
    
    // Operation wildcard, resource must match
    if (resource == other.resource && operation == '*') {
      return true;
    }
    
    // Hierarchical resource wildcard
    if (resource.endsWith('.*') && other.resource.startsWith(resource.substring(0, resource.length - 2))) {
      if (operation == '*' || operation == other.operation) {
        return true;
      }
    }
    
    // Exact match
    return resource == other.resource && operation == other.operation;
  }
  
  @override
  String toString() => '$resource:$operation';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Permission && 
           resource == other.resource && 
           operation == other.operation;
  }
  
  @override
  int get hashCode => resource.hashCode ^ operation.hashCode;
}

/// A role represents a collection of permissions.
///
/// The [Role] class groups permissions together, making it easy to assign
/// multiple permissions to users or groups at once.
///
/// Example:
/// ```dart
/// final adminRole = Role('admin', [
///   Permission('*', '*'),
/// ]);
///
/// final userRole = Role('user', [
///   Permission('Task', 'read'),
///   Permission('Task', 'write'),
/// ]);
/// ```
class Role extends Entity<Role> {
  /// The name of the role
  final String name;
  
  /// The list of permissions this role has
  final List<Permission> permissions;
  
  /// Creates a new role.
  ///
  /// Parameters:
  /// - [name]: The name of the role
  /// - [permissions]: The list of permissions this role has
  Role(this.name, this.permissions);
  
  /// Checks if this role has a specific permission.
  ///
  /// This method checks if any of the role's permissions imply
  /// the requested permission.
  ///
  /// Parameters:
  /// - [permission]: The permission to check for
  ///
  /// Returns:
  /// True if the role has the permission
  bool hasPermission(Permission permission) {
    return permissions.any((p) => p.implies(permission));
  }
  
  /// Checks if this role has a specific permission string.
  ///
  /// This is a convenience method that converts the permission string
  /// to a [Permission] object and checks if the role has it.
  ///
  /// Parameters:
  /// - [permissionString]: The permission string to check for
  ///
  /// Returns:
  /// True if the role has the permission
  bool hasPermissionString(String permissionString) {
    return hasPermission(Permission.fromString(permissionString));
  }
}

/// A security subject represents an authenticated entity in the system.
///
/// The [SecuritySubject] interface defines the contract for entities that can
/// have security permissions, like users and groups. It provides methods for
/// checking permissions and roles.
abstract class SecuritySubject {
  /// Gets all roles assigned to this subject.
  List<Role> get roles;
  
  /// Checks if this subject has a specific permission.
  ///
  /// Parameters:
  /// - [permission]: The permission to check for
  ///
  /// Returns:
  /// True if the subject has the permission
  bool hasPermission(Permission permission) {
    return roles.any((role) => role.hasPermission(permission));
  }
  
  /// Checks if this subject has a specific permission string.
  ///
  /// Parameters:
  /// - [permissionString]: The permission string to check for
  ///
  /// Returns:
  /// True if the subject has the permission
  bool hasPermissionString(String permissionString) {
    return hasPermission(Permission.fromString(permissionString));
  }
  
  /// Checks if this subject has any of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: The list of permissions to check for
  ///
  /// Returns:
  /// True if the subject has any of the permissions
  bool hasAnyPermission(List<Permission> permissions) {
    return permissions.any(hasPermission);
  }
  
  /// Checks if this subject has all of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: The list of permissions to check for
  ///
  /// Returns:
  /// True if the subject has all of the permissions
  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every(hasPermission);
  }
  
  /// Checks if this subject has a specific role.
  ///
  /// Parameters:
  /// - [roleName]: The name of the role to check for
  ///
  /// Returns:
  /// True if the subject has the role
  bool hasRole(String roleName) {
    return roles.any((role) => role.name == roleName);
  }
  
  /// Gets the effective permissions this subject has.
  ///
  /// This method computes all permissions granted by all roles.
  ///
  /// Returns:
  /// The set of all permissions this subject has
  Set<Permission> getEffectivePermissions() {
    final result = <Permission>{};
    for (var role in roles) {
      result.addAll(role.permissions);
    }
    return result;
  }
} 