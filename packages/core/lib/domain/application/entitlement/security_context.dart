part of ednet_core;

/// A security context manages the current security subject and provides authorization functions.
///
/// The [SecurityContext] class is responsible for:
/// - Holding the current security subject (e.g., logged-in user)
/// - Checking permissions for operations
/// - Enforcing field-level access control
/// - Providing security predicates for query filtering
///
/// This class uses thread-local storage to maintain the current security context,
/// making it accessible throughout the application without explicit passing.
///
/// Example usage:
/// ```dart
/// // Set the current user
/// SecurityContext.setCurrentSubject(currentUser);
/// 
/// // Check permissions
/// if (SecurityContext.hasPermission(Permission('Task', 'create'))) {
///   // Create a task
/// }
/// 
/// // Run with elevated permissions temporarily
/// SecurityContext.runWithSystemPrivileges(() {
///   // Perform privileged operations
/// });
/// ```
class SecurityContext {
  /// The default system subject with all permissions
  static final SecuritySubject _systemSubject = _SystemSubject();
  
  /// Thread-local storage for the current security context
  static final _current = new ThreadLocal<SecurityContext>();
  
  /// The security subject for this context
  final SecuritySubject _subject;
  
  /// Whether this context has system privileges
  final bool _isSystem;
  
  /// Creates a new security context.
  ///
  /// Parameters:
  /// - [subject]: The security subject for this context
  /// - [isSystem]: Whether this context has system privileges
  SecurityContext(this._subject, {bool isSystem = false}) : _isSystem = isSystem;
  
  /// Gets the current security context.
  ///
  /// If no context has been set, returns a default context with the system subject.
  /// This ensures that authorization checks always have a context to work with.
  ///
  /// Returns:
  /// The current security context
  static SecurityContext getCurrent() {
    return _current.get() ?? SecurityContext(_systemSubject, isSystem: true);
  }
  
  /// Sets the current security context.
  ///
  /// This method should be called at the beginning of each request or
  /// when changing the security context (e.g., after login).
  ///
  /// Parameters:
  /// - [context]: The security context to set
  static void setCurrent(SecurityContext context) {
    _current.set(context);
  }
  
  /// Sets the current security subject.
  ///
  /// This is a convenience method that creates a new context with the
  /// specified subject and sets it as the current context.
  ///
  /// Parameters:
  /// - [subject]: The security subject to set
  static void setCurrentSubject(SecuritySubject subject) {
    setCurrent(SecurityContext(subject));
  }
  
  /// Runs a function with system privileges.
  ///
  /// This method temporarily elevates the security context to
  /// system privileges, runs the specified function, and then
  /// restores the original context.
  ///
  /// Parameters:
  /// - [fn]: The function to run with system privileges
  ///
  /// Returns:
  /// The result of the function
  static T runWithSystemPrivileges<T>(T Function() fn) {
    final originalContext = getCurrent();
    try {
      setCurrent(SecurityContext(_systemSubject, isSystem: true));
      return fn();
    } finally {
      setCurrent(originalContext);
    }
  }
  
  /// Clears the current security context.
  ///
  /// This method should be called at the end of each request.
  static void clear() {
    _current.set(null);
  }
  
  /// Gets the current security subject.
  ///
  /// Returns:
  /// The current security subject
  static SecuritySubject getCurrentSubject() {
    return getCurrent()._subject;
  }
  
  /// Checks if the current subject has a specific permission.
  ///
  /// Parameters:
  /// - [permission]: The permission to check for
  ///
  /// Returns:
  /// True if the current subject has the permission
  static bool hasPermission(Permission permission) {
    final context = getCurrent();
    if (context._isSystem) return true;
    return context._subject.hasPermission(permission);
  }
  
  /// Checks if the current subject has a specific permission string.
  ///
  /// Parameters:
  /// - [permissionString]: The permission string to check for
  ///
  /// Returns:
  /// True if the current subject has the permission
  static bool hasPermissionString(String permissionString) {
    return hasPermission(Permission.fromString(permissionString));
  }
  
  /// Checks if the current subject has any of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: The list of permissions to check for
  ///
  /// Returns:
  /// True if the current subject has any of the permissions
  static bool hasAnyPermission(List<Permission> permissions) {
    final context = getCurrent();
    if (context._isSystem) return true;
    return context._subject.hasAnyPermission(permissions);
  }
  
  /// Checks if the current subject has all of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: The list of permissions to check for
  ///
  /// Returns:
  /// True if the current subject has all of the permissions
  static bool hasAllPermissions(List<Permission> permissions) {
    final context = getCurrent();
    if (context._isSystem) return true;
    return context._subject.hasAllPermissions(permissions);
  }
  
  /// Checks if the current subject has a specific role.
  ///
  /// Parameters:
  /// - [roleName]: The name of the role to check for
  ///
  /// Returns:
  /// True if the current subject has the role
  static bool hasRole(String roleName) {
    final context = getCurrent();
    if (context._isSystem) return true;
    return context._subject.hasRole(roleName);
  }
  
  /// Checks if the current context has system privileges.
  ///
  /// Returns:
  /// True if the current context has system privileges
  static bool isSystem() {
    return getCurrent()._isSystem;
  }
  
  /// Checks if the current subject has permission to access a resource.
  ///
  /// This method constructs a permission with the specified resource and
  /// operation, then checks if the current subject has that permission.
  ///
  /// Parameters:
  /// - [resource]: The resource to check access for
  /// - [operation]: The operation to check access for
  ///
  /// Returns:
  /// True if the current subject has permission to access the resource
  static bool canAccess(String resource, String operation) {
    return hasPermission(Permission(resource, operation));
  }
  
  /// Requires that the current subject has a specific permission.
  ///
  /// This method checks if the current subject has the specified permission,
  /// and throws a [SecurityException] if they don't.
  ///
  /// Parameters:
  /// - [permission]: The permission to require
  ///
  /// Throws:
  /// [SecurityException] if the current subject doesn't have the permission
  static void requirePermission(Permission permission) {
    if (!hasPermission(permission)) {
      throw SecurityException('Permission required: $permission');
    }
  }
  
  /// Requires that the current subject has a specific permission string.
  ///
  /// Parameters:
  /// - [permissionString]: The permission string to require
  ///
  /// Throws:
  /// [SecurityException] if the current subject doesn't have the permission
  static void requirePermissionString(String permissionString) {
    requirePermission(Permission.fromString(permissionString));
  }
  
  /// Creates a function that checks if a field is accessible.
  ///
  /// This method returns a function that can be used to filter fields based on
  /// whether the current subject has permission to access them.
  ///
  /// Parameters:
  /// - [resourcePrefix]: The prefix to add to the field name to form the resource
  /// - [operation]: The operation to check for
  ///
  /// Returns:
  /// A function that returns true if the field is accessible
  static bool Function(String) createFieldAccessChecker(String resourcePrefix, String operation) {
    return (String fieldName) {
      return canAccess('$resourcePrefix.$fieldName', operation);
    };
  }
}

/// A thread-local storage implementation.
///
/// This class provides thread-local storage capabilities,
/// allowing values to be stored and retrieved in a thread-safe way.
class ThreadLocal<T> {
  final Map<int, T> _values = {};
  int _nextId = 0;
  
  /// Gets the current thread's value.
  ///
  /// Returns:
  /// The value for the current thread, or null if not set
  T? get() {
    // Note: In a real implementation, this would use actual thread-local storage
    // For now, we'll just use a simple ID-based approach for demonstration
    return _values[_getThreadId()];
  }
  
  /// Sets the value for the current thread.
  ///
  /// Parameters:
  /// - [value]: The value to set
  void set(T? value) {
    final threadId = _getThreadId();
    if (value == null) {
      _values.remove(threadId);
    } else {
      _values[threadId] = value;
    }
  }
  
  /// Gets an ID for the current thread.
  ///
  /// In a real implementation, this would return a thread-specific ID.
  /// For now, we'll just use a simple counter.
  int _getThreadId() {
    if (_nextId == 0) {
      _nextId = 1;
    }
    return _nextId;
  }
}

/// A system subject with all permissions.
///
/// This class implements the [SecuritySubject] interface to provide
/// a subject with all permissions that can be used for system operations.
class _SystemSubject implements SecuritySubject {
  @override
  List<Role> get roles => [];
  
  @override
  bool hasPermission(Permission permission) => true;
  
  @override
  bool hasPermissionString(String permissionString) => true;
  
  @override
  bool hasAnyPermission(List<Permission> permissions) => true;
  
  @override
  bool hasAllPermissions(List<Permission> permissions) => true;
  
  @override
  bool hasRole(String roleName) => true;
  
  @override
  Set<Permission> getEffectivePermissions() => {Permission('*', '*')};
}

/// Exception thrown when a security check fails.
///
/// This exception is thrown when an operation requires a permission
/// that the current subject doesn't have.
class SecurityException implements Exception {
  /// The error message.
  final String message;
  
  /// Creates a new security exception.
  ///
  /// Parameters:
  /// - [message]: The error message
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
} 