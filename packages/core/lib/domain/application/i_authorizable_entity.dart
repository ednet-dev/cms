// part of ednet_core;
//
// /// A mixin that adds authorization capabilities to an entity.
// ///
// /// This mixin provides:
// /// - Access policy management
// /// - Authorization checking
// /// - Policy evaluation
// ///
// /// By mixing this into an entity class, you can:
// /// - Define access policies for the entity
// /// - Check if users are authorized to perform actions
// /// - Easily implement authorization rules
// ///
// /// Example usage:
// /// ```dart
// /// class Order extends Entity<Order> with AuthorizationFor<User, Order> {
// ///   // Order properties and methods
// ///
// ///   @override
// ///   IEntities<IPolicy> get accessPolicies {
// ///     final policies = Entities<IPolicy>()
// ///       ..add(OwnerPolicy<User>(ownerId: customerId))
// ///       ..add(AdminPolicy<User>());
// ///     return policies;
// ///   }
// /// }
// /// ```
// mixin AuthorizationFor<U, E extends Entity<E>> on Entity<E> {
//   /// The access policies for this entity.
//   ///
//   /// By default, all actions are allowed. Override this property
//   /// to provide specific authorization rules.
//   IEntities<IPolicy> get accessPolicies => _defaultAccessPolicies();
//
//   /// Creates the default access policies for this entity.
//   ///
//   /// By default, returns a single [AllowAllPolicy].
//   IEntities<IPolicy> _defaultAccessPolicies() {
//     final policies = Entities<IPolicy>();
//     policies.add(AllowAllPolicy<U>());
//     return policies;
//   }
//
//   /// Checks if a user is authorized to perform an action.
//   ///
//   /// This method evaluates all access policies and returns true
//   /// only if all policies allow the action.
//   ///
//   /// Parameters:
//   /// - [action]: The command to check authorization for
//   /// - [user]: The user attempting the action
//   ///
//   /// Returns:
//   /// True if the user is authorized, false otherwise
//   bool isAuthorized(ICommand action, U user) {
//     for (var policy in accessPolicies) {
//       if (!policy.allows(action, user)) {
//         return false;
//       }
//     }
//     return true;
//   }
// }
//
// /// Defines the interface for authorization policies.
// ///
// /// A policy decides whether a user is allowed to perform
// /// an action on an entity. By implementing different
// /// policies, you can create complex authorization rules.
// ///
// /// Example usage:
// /// ```dart
// /// class AdminPolicy<User> extends IPolicy<User> {
// ///   @override
// ///   bool allows(ICommand action, User user) {
// ///     return user.isAdmin;
// ///   }
// /// }
// /// ```
// abstract class IPolicy<U> extends Entity<IPolicy> {
//   /// Checks if a user is allowed to perform an action.
//   ///
//   /// Parameters:
//   /// - [action]: The command to check
//   /// - [user]: The user attempting the action
//   ///
//   /// Returns:
//   /// True if the action is allowed, false otherwise
//   bool allows(ICommand action, U user);
// }
//
// /// A policy that allows all actions.
// ///
// /// This is the default policy used when no other
// /// policies are specified. It allows all actions
// /// for all users.
// class AllowAllPolicy<U> extends IPolicy<U> {
//   /// Allows all actions for all users.
//   @override
//   bool allows(ICommand action, U user) => true;
// }
//
// /// A policy that denies all actions.
// ///
// /// This policy can be used to completely restrict
// /// access to an entity. It denies all actions
// /// for all users.
// class DenyAllPolicy<U> extends IPolicy<U> {
//   /// Denies all actions for all users.
//   @override
//   bool allows(ICommand action, U user) => false;
// }
//
// /// A policy that allows actions only for a specific role.
// ///
// /// This policy allows actions only if the user has
// /// the specified role. It's useful for role-based
// /// access control.
// ///
// /// Example usage:
// /// ```dart
// /// final policies = Entities<IPolicy>()
// ///   ..add(RolePolicy<User>(role: 'admin'));
// /// ```
// class RolePolicy<U> extends IPolicy<U> {
//   /// The role that is allowed to perform actions.
//   final String role;
//
//   /// Creates a new role policy.
//   ///
//   /// Parameters:
//   /// - [role]: The role that is allowed to perform actions
//   RolePolicy({required this.role});
//
//   /// Allows actions only if the user has the specified role.
//   ///
//   /// This assumes that the user object has a `hasRole` method
//   /// or similar. Adjust the implementation based on your user class.
//   @override
//   bool allows(ICommand action, U user) {
//     // Example implementation - adjust based on your user class
//     // return user.hasRole(role);
//     return false; // Placeholder
//   }
// }
//
// /// A policy that allows actions only for the owner of an entity.
// ///
// /// This policy allows actions only if the user is the owner
// /// of the entity. It's useful for owner-based access control.
// ///
// /// Example usage:
// /// ```dart
// /// final policies = Entities<IPolicy>()
// ///   ..add(OwnerPolicy<User>(ownerId: document.createdBy));
// /// ```
// class OwnerPolicy<U> extends IPolicy<U> {
//   /// The ID of the owner of the entity.
//   final String ownerId;
//
//   /// Creates a new owner policy.
//   ///
//   /// Parameters:
//   /// - [ownerId]: The ID of the owner of the entity
//   OwnerPolicy({required this.ownerId});
//
//   /// Allows actions only if the user is the owner.
//   ///
//   /// This assumes that the user object has an `id` property
//   /// or similar. Adjust the implementation based on your user class.
//   @override
//   bool allows(ICommand action, U user) {
//     // Example implementation - adjust based on your user class
//     // return user.id == ownerId;
//     return false; // Placeholder
//   }
// }
//
// /// A policy that allows only specific commands.
// ///
// /// This policy allows actions only if the command
// /// is in the list of allowed commands. It's useful
// /// for command-based access control.
// ///
// /// Example usage:
// /// ```dart
// /// final policies = Entities<IPolicy>()
// ///   ..add(CommandPolicy<User>(
// ///     allowedCommands: ['CreateOrder', 'ViewOrder'],
// ///   ));
// /// ```
// class CommandPolicy<U> extends IPolicy<U> {
//   /// The list of commands that are allowed.
//   final List<String> allowedCommands;
//
//   /// Creates a new command policy.
//   ///
//   /// Parameters:
//   /// - [allowedCommands]: The list of commands that are allowed
//   CommandPolicy({required this.allowedCommands});
//
//   /// Allows actions only if the command is in the list of allowed commands.
//   @override
//   bool allows(ICommand action, U user) {
//     return allowedCommands.contains(action.name);
//   }
// }
