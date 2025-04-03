// part of ednet_core;
//
// /// A mixin to add authorization capabilities to an entity.
// ///
// /// The [AuthorizationFor] mixin adds methods to authorize operations
// /// on entities based on the entity's policies and the user's permissions.
// ///
// /// Example usage:
// /// ```dart
// /// class Order extends Entity<Order> with AuthorizationFor<User, Order> {
// ///   @override
// ///   IEntities<IPolicy> get accessPolicies {
// ///     final policies = Entities<IPolicy>();
// ///
// ///     // Owner can do anything with their order
// ///     if (customerId != null) {
// ///       policies.add(OwnerPolicy<User>(ownerId: customerId!));
// ///     }
// ///
// ///     // Allow specific commands
// ///     policies.add(CommandPolicy<User>(allowedCommands: ['ViewOrder']));
// ///
// ///     return policies;
// ///   }
// /// }
// /// ```
// mixin AuthorizationFor<U extends SecuritySubject, E extends Entity<E>> on Entity<E> {
//   /// Gets the policies that control access to this entity.
//   ///
//   /// Override this method to define the policies that control
//   /// access to this entity. These policies are evaluated when
//   /// determining if a user can perform an operation on the entity.
//   ///
//   /// Returns:
//   /// A collection of policies that control access to this entity
//   IEntities<IPolicy> get accessPolicies;
//
//   /// Checks if a user is authorized to perform an operation.
//   ///
//   /// This method evaluates the entity's policies to determine if
//   /// the user is authorized to perform the operation represented
//   /// by the command.
//   ///
//   /// Parameters:
//   /// - [command]: The command representing the operation
//   /// - [user]: The user trying to perform the operation
//   ///
//   /// Returns:
//   /// True if the user is authorized, false otherwise
//   bool isAuthorized(ICommand command, U user) {
//     // System users can do anything
//     if (SecurityContext.isSystem()) {
//       return true;
//     }
//
//     // Evaluate each policy
//     for (var policy in accessPolicies) {
//       if (policy is OwnerPolicy<U> && policy.isAuthorized(user, command)) {
//         return true;
//       }
//
//       if (policy is CommandPolicy<U> && policy.isAuthorized(user, command)) {
//         return true;
//       }
//
//       if (policy is AttributePolicy<U> && policy.isAuthorized(user, command)) {
//         return true;
//       }
//     }
//
//     // Default to not authorized
//     return false;
//   }
//
//   /// Ensures that a user is authorized to perform an operation.
//   ///
//   /// This method checks if the user is authorized and throws a
//   /// [SecurityException] if they are not.
//   ///
//   /// Parameters:
//   /// - [command]: The command representing the operation
//   /// - [user]: The user trying to perform the operation
//   ///
//   /// Throws:
//   /// [SecurityException] if the user is not authorized
//   void ensureAuthorized(ICommand command, U user) {
//     if (!isAuthorized(command, user)) {
//       throw SecurityException(
//         'User ${user.toString()} is not authorized to execute ${command.name} on ${concept.code}',
//       );
//     }
//   }
// }
//
// /// A policy that authorizes operations based on ownership.
// ///
// /// The [OwnerPolicy] allows operations if the user is the owner
// /// of the entity. This is useful for allowing users to manage
// /// their own data.
// ///
// /// Example usage:
// /// ```dart
// /// policies.add(OwnerPolicy<User>(ownerId: order.customerId));
// /// ```
// class OwnerPolicy<U extends SecuritySubject> implements IPolicy {
//   /// The ID of the owner.
//   final String ownerId;
//
//   /// The commands that are allowed for the owner.
//   final List<String>? allowedCommands;
//
//   /// Creates a new owner policy.
//   ///
//   /// Parameters:
//   /// - [ownerId]: The ID of the owner
//   /// - [allowedCommands]: Optional list of allowed command names for the owner
//   OwnerPolicy({
//     required this.ownerId,
//     this.allowedCommands,
//   });
//
//   /// Checks if the user is authorized by this policy.
//   ///
//   /// This method returns true if the user is the owner of the entity
//   /// and either all commands are allowed or the specific command is allowed.
//   ///
//   /// Parameters:
//   /// - [user]: The user to check
//   /// - [command]: The command representing the operation
//   ///
//   /// Returns:
//   /// True if the user is authorized, false otherwise
//   bool isAuthorized(U user, ICommand command) {
//     if (user is! U) return false;
//
//     if (isOwner(user)) {
//       if (allowedCommands == null) {
//         // Owner can do anything
//         return true;
//       }
//
//       // Owner can only do specific commands
//       return allowedCommands!.contains(command.name);
//     }
//
//     return false;
//   }
//
//   /// Checks if the user is the owner.
//   ///
//   /// This method checks if the user has the same ID as the owner.
//   /// Override this method for custom ownership logic.
//   ///
//   /// Parameters:
//   /// - [user]: The user to check
//   ///
//   /// Returns:
//   /// True if the user is the owner, false otherwise
//   bool isOwner(U user) {
//     // Default implementation - override for custom logic
//     return user is U && hasId(user) && getUserId(user) == ownerId;
//   }
//
//   /// Gets the ID of a user.
//   ///
//   /// Override this method if your user class stores the ID differently.
//   ///
//   /// Parameters:
//   /// - [user]: The user to get the ID for
//   ///
//   /// Returns:
//   /// The user ID as a string
//   String getUserId(U user) {
//     // Default implementation - override for custom user types
//     if (hasProperty(user, 'id')) {
//       final id = getProperty(user, 'id');
//       return id.toString();
//     }
//     return '';
//   }
//
//   /// Checks if a user has an ID.
//   ///
//   /// Override this method if your user class stores the ID differently.
//   ///
//   /// Parameters:
//   /// - [user]: The user to check
//   ///
//   /// Returns:
//   /// True if the user has an ID, false otherwise
//   bool hasId(U user) {
//     // Default implementation - override for custom user types
//     return hasProperty(user, 'id');
//   }
//
//   /// Checks if an object has a property.
//   ///
//   /// Parameters:
//   /// - [object]: The object to check
//   /// - [property]: The property name
//   ///
//   /// Returns:
//   /// True if the object has the property, false otherwise
//   bool hasProperty(dynamic object, String property) {
//     try {
//       final mirror = reflect(object);
//       return mirror.getField(Symbol(property)) != null;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   /// Gets a property from an object.
//   ///
//   /// Parameters:
//   /// - [object]: The object to get the property from
//   /// - [property]: The property name
//   ///
//   /// Returns:
//   /// The property value
//   dynamic getProperty(dynamic object, String property) {
//     try {
//       final mirror = reflect(object);
//       return mirror.getField(Symbol(property));
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Reflects an object to access its fields.
//   ///
//   /// Parameters:
//   /// - [object]: The object to reflect
//   ///
//   /// Returns:
//   /// An object that allows accessing fields
//   dynamic reflect(dynamic object) {
//     // This is a simple implementation that works for the test
//     // In a real implementation, you might use a reflection library
//     return _ObjectReflector(object);
//   }
// }
//
// /// A simple object reflector.
// ///
// /// This class provides a way to access fields of an object
// /// without using actual reflection (which is limited in Dart).
// class _ObjectReflector {
//   final dynamic _object;
//
//   _ObjectReflector(this._object);
//
//   /// Gets a field from the object.
//   ///
//   /// Parameters:
//   /// - [name]: The field name as a Symbol
//   ///
//   /// Returns:
//   /// The field value
//   dynamic getField(Symbol name) {
//     // Convert symbol to string
//     final fieldName = name.toString().substring(8, name.toString().length - 2);
//
//     // Use dynamic access for test purposes
//     // In a real implementation, you would need to handle this differently
//     try {
//       return _object[fieldName] ?? _object.'$fieldName';
//     } catch (e) {
//       return null;
//     }
//   }
// }
//
// /// A policy that authorizes operations based on the command.
// ///
// /// The [CommandPolicy] allows specific commands to be executed
// /// if the user has the required permissions. This is useful for
// /// allowing users to perform specific operations.
// ///
// /// Example usage:
// /// ```dart
// /// policies.add(CommandPolicy<User>(
// ///   allowedCommands: ['ViewOrder'],
// ///   requiredPermissions: ['Order:read'],
// /// ));
// /// ```
// class CommandPolicy<U extends SecuritySubject> implements IPolicy {
//   /// The allowed command names.
//   final List<String> allowedCommands;
//
//   /// The permissions required to execute the commands.
//   final List<String>? requiredPermissions;
//
//   /// Creates a new command policy.
//   ///
//   /// Parameters:
//   /// - [allowedCommands]: The list of allowed command names
//   /// - [requiredPermissions]: Optional list of required permissions
//   CommandPolicy({
//     required this.allowedCommands,
//     this.requiredPermissions,
//   });
//
//   /// Checks if the user is authorized by this policy.
//   ///
//   /// This method returns true if the command is in the allowed list
//   /// and the user has the required permissions (if specified).
//   ///
//   /// Parameters:
//   /// - [user]: The user to check
//   /// - [command]: The command representing the operation
//   ///
//   /// Returns:
//   /// True if the user is authorized, false otherwise
//   bool isAuthorized(U user, ICommand command) {
//     if (!allowedCommands.contains(command.name)) {
//       return false;
//     }
//
//     if (requiredPermissions == null || requiredPermissions!.isEmpty) {
//       // Command is allowed for anyone
//       return true;
//     }
//
//     // Check if user has any of the required permissions
//     for (var permissionString in requiredPermissions!) {
//       if (user.hasPermissionString(permissionString)) {
//         return true;
//       }
//     }
//
//     return false;
//   }
// }
//
// /// A policy that authorizes operations based on entity attributes.
// ///
// /// The [AttributePolicy] allows operations if the entity's attributes
// /// match certain conditions. This is useful for allowing operations
// /// based on the state of the entity.
// ///
// /// Example usage:
// /// ```dart
// /// policies.add(AttributePolicy<User>(
// ///   attributeName: 'status',
// ///   attributeValue: 'open',
// ///   allowedCommands: ['CloseOrder'],
// ///   requiredPermissions: ['Order:close'],
// /// ));
// /// ```
// class AttributePolicy<U extends SecuritySubject> implements IPolicy {
//   /// The name of the attribute to check.
//   final String attributeName;
//
//   /// The value the attribute should have.
//   final dynamic attributeValue;
//
//   /// The allowed command names.
//   final List<String> allowedCommands;
//
//   /// The permissions required to execute the commands.
//   final List<String>? requiredPermissions;
//
//   /// Creates a new attribute policy.
//   ///
//   /// Parameters:
//   /// - [attributeName]: The name of the attribute to check
//   /// - [attributeValue]: The value the attribute should have
//   /// - [allowedCommands]: The list of allowed command names
//   /// - [requiredPermissions]: Optional list of required permissions
//   AttributePolicy({
//     required this.attributeName,
//     required this.attributeValue,
//     required this.allowedCommands,
//     this.requiredPermissions,
//   });
//
//   /// Checks if the user is authorized by this policy.
//   ///
//   /// This method returns true if the command is in the allowed list,
//   /// the entity's attribute matches the expected value, and the user
//   /// has the required permissions (if specified).
//   ///
//   /// Parameters:
//   /// - [user]: The user to check
//   /// - [command]: The command representing the operation
//   /// - [entity]: The entity to check
//   ///
//   /// Returns:
//   /// True if the user is authorized, false otherwise
//   bool isAuthorized(U user, ICommand command, [Entity? entity]) {
//     if (!allowedCommands.contains(command.name)) {
//       return false;
//     }
//
//     if (entity == null) {
//       return false;
//     }
//
//     // Check if the entity's attribute has the expected value
//     final attributeValue = entity.getAttribute(attributeName);
//     if (attributeValue != this.attributeValue) {
//       return false;
//     }
//
//     if (requiredPermissions == null || requiredPermissions!.isEmpty) {
//       // Command is allowed for anyone if the attribute matches
//       return true;
//     }
//
//     // Check if user has any of the required permissions
//     for (var permissionString in requiredPermissions!) {
//       if (user.hasPermissionString(permissionString)) {
//         return true;
//       }
//     }
//
//     return false;
//   }
// }