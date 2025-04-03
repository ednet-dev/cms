// part of ednet_core;
//
// /// Base class for authorization attributes.
// ///
// /// The [AuthorizeAttribute] class is the base class for all authorization attributes.
// /// These attributes can be used to annotate classes and methods with permission
// /// requirements, making it easy to enforce consistent security rules.
// ///
// /// This attribute pattern is inspired by .NET's authorization attributes,
// /// but works differently in Dart since it doesn't have runtime reflection.
// ///
// /// Example usage:
// /// ```dart
// /// @RequirePermission('Order', 'read')
// /// class OrderService extends ApplicationService<Order> {
// ///   // ...
// /// }
// ///
// /// @RequirePermission('Order', 'create')
// /// Future<CommandResult> createOrder(CreateOrderCommand command) async {
// ///   // ...
// /// }
// /// ```
// abstract class AuthorizeAttribute {
//   /// The type of authorization attribute.
//   String get type;
//
//   /// Checks if the current subject is authorized.
//   ///
//   /// Parameters:
//   /// - [resourceName]: The name of the resource being accessed
//   /// - [operationName]: The name of the operation being performed
//   ///
//   /// Returns:
//   /// True if the current subject is authorized, false otherwise
//   bool isAuthorized(String resourceName, String operationName);
// }
//
// /// Attribute that requires a specific permission.
// ///
// /// The [RequirePermission] attribute requires that the current subject
// /// has a specific permission. It can be used to annotate classes and
// /// methods with permission requirements.
// ///
// /// Example usage:
// /// ```dart
// /// @RequirePermission('Order', 'read')
// /// Future<List<Order>> getOrders() async {
// ///   // ...
// /// }
// /// ```
// class RequirePermission extends AuthorizeAttribute {
//   /// The resource that requires permission.
//   final String resource;
//
//   /// The operation that requires permission.
//   final String operation;
//
//   /// Creates a new require permission attribute.
//   ///
//   /// Parameters:
//   /// - [resource]: The resource that requires permission
//   /// - [operation]: The operation that requires permission
//   const RequirePermission(this.resource, this.operation);
//
//   @override
//   String get type => 'RequirePermission';
//
//   @override
//   bool isAuthorized(String resourceName, String operationName) {
//     return SecurityContext.hasPermission(Permission(resource, operation));
//   }
// }
//
// /// Attribute that requires a specific role.
// ///
// /// The [RequireRole] attribute requires that the current subject
// /// has a specific role. It can be used to annotate classes and
// /// methods with role requirements.
// ///
// /// Example usage:
// /// ```dart
// /// @RequireRole('admin')
// /// Future<void> deleteAllOrders() async {
// ///   // ...
// /// }
// /// ```
// class RequireRole extends AuthorizeAttribute {
//   /// The role that is required.
//   final String role;
//
//   /// Creates a new require role attribute.
//   ///
//   /// Parameters:
//   /// - [role]: The role that is required
//   const RequireRole(this.role);
//
//   @override
//   String get type => 'RequireRole';
//
//   @override
//   bool isAuthorized(String resourceName, String operationName) {
//     return SecurityContext.hasRole(role);
//   }
// }
//
// /// Attribute that allows any user access.
// ///
// /// The [AllowAnonymous] attribute allows any user to access the
// /// annotated class or method, regardless of their permissions.
// ///
// /// Example usage:
// /// ```dart
// /// @AllowAnonymous
// /// Future<List<Product>> getPublicProducts() async {
// ///   // ...
// /// }
// /// ```
// class AllowAnonymous extends AuthorizeAttribute {
//   /// Creates a new allow anonymous attribute.
//   const AllowAnonymous();
//
//   @override
//   String get type => 'AllowAnonymous';
//
//   @override
//   bool isAuthorized(String resourceName, String operationName) {
//     return true;
//   }
// }
//
// /// Utility class for handling authorization attributes.
// ///
// /// The [AuthorizationAttributeHandler] class provides utility methods
// /// for working with authorization attributes in the absence of
// /// reflection in Dart.
// ///
// /// Example usage:
// /// ```dart
// /// // Register authorization behavior
// /// AuthorizationAttributeHandler.registerMethod(
// ///   'OrderService.createOrder',
// ///   const [RequirePermission('Order', 'create')]
// /// );
// ///
// /// // Check authorization
// /// if (AuthorizationAttributeHandler.isAuthorized(
// ///   'OrderService.createOrder',
// ///   'Order',
// ///   'create'
// /// )) {
// ///   // Execute method
// /// }
// /// ```
// class AuthorizationAttributeHandler {
//   /// Map of type names to authorization attributes.
//   static final Map<String, List<AuthorizeAttribute>> _typeAttributes = {};
//
//   /// Map of method names to authorization attributes.
//   static final Map<String, List<AuthorizeAttribute>> _methodAttributes = {};
//
//   /// Registers authorization attributes for a type.
//   ///
//   /// Parameters:
//   /// - [typeName]: The name of the type
//   /// - [attributes]: The list of authorization attributes
//   static void registerType(String typeName, List<AuthorizeAttribute> attributes) {
//     _typeAttributes[typeName] = attributes;
//   }
//
//   /// Registers authorization attributes for a method.
//   ///
//   /// Parameters:
//   /// - [methodName]: The name of the method (e.g., 'TypeName.methodName')
//   /// - [attributes]: The list of authorization attributes
//   static void registerMethod(String methodName, List<AuthorizeAttribute> attributes) {
//     _methodAttributes[methodName] = attributes;
//   }
//
//   /// Checks if a method is authorized.
//   ///
//   /// This method checks both the type-level and method-level attributes,
//   /// and returns true if all attributes allow the operation.
//   ///
//   /// Parameters:
//   /// - [methodName]: The name of the method (e.g., 'TypeName.methodName')
//   /// - [resourceName]: The name of the resource being accessed
//   /// - [operationName]: The name of the operation being performed
//   ///
//   /// Returns:
//   /// True if the method is authorized, false otherwise
//   static bool isAuthorized(String methodName, String resourceName, String operationName) {
//     // If we have AllowAnonymous at type or method level, always allow
//     if (_hasAllowAnonymous(methodName)) {
//       return true;
//     }
//
//     // Check all attributes at both type and method level
//     return _checkAuthorization(methodName, resourceName, operationName);
//   }
//
//   /// Checks if a method has an [AllowAnonymous] attribute.
//   ///
//   /// Parameters:
//   /// - [methodName]: The name of the method
//   ///
//   /// Returns:
//   /// True if the method has an [AllowAnonymous] attribute
//   static bool _hasAllowAnonymous(String methodName) {
//     // Extract type name from method name
//     final typeName = methodName.split('.').first;
//
//     // Check type attributes
//     final typeAttributes = _typeAttributes[typeName] ?? [];
//     if (typeAttributes.any((a) => a is AllowAnonymous)) {
//       return true;
//     }
//
//     // Check method attributes
//     final methodAttributes = _methodAttributes[methodName] ?? [];
//     if (methodAttributes.any((a) => a is AllowAnonymous)) {
//       return true;
//     }
//
//     return false;
//   }
//
//   /// Checks all authorization attributes for a method.
//   ///
//   /// Parameters:
//   /// - [methodName]: The name of the method
//   /// - [resourceName]: The name of the resource
//   /// - [operationName]: The name of the operation
//   ///
//   /// Returns:
//   /// True if all attributes allow the operation, false otherwise
//   static bool _checkAuthorization(String methodName, String resourceName, String operationName) {
//     // Extract type name from method name
//     final typeName = methodName.split('.').first;
//
//     // Check type attributes
//     final typeAttributes = _typeAttributes[typeName] ?? [];
//     for (var attribute in typeAttributes) {
//       if (!attribute.isAuthorized(resourceName, operationName)) {
//         return false;
//       }
//     }
//
//     // Check method attributes
//     final methodAttributes = _methodAttributes[methodName] ?? [];
//     for (var attribute in methodAttributes) {
//       if (!attribute.isAuthorized(resourceName, operationName)) {
//         return false;
//       }
//     }
//
//     // If there are no attributes, deny access by default
//     if (typeAttributes.isEmpty && methodAttributes.isEmpty) {
//       return false;
//     }
//
//     return true;
//   }
// }