part of ednet_core;

mixin AuthorizationFor<U, E extends Entity<E>> on Entity<E> {
  IEntities<IPolicy> _accessPolicies = Entities<IPolicy>()
    ..add(
      AllowAllPolicy<U>(),
    );

  // This method should be overridden by subclasses to provide a list of
  // access policies that define the authorization rules for this entity.
  IEntities<IPolicy> get accessPolicies => _accessPolicies;

  // This method checks if the current user is authorized to perform the given
  // action on this entity.
  bool isAuthorized(ICommand action, U user) {
    for (var policy in accessPolicies) {
      if (!policy.allows(action, user)) {
        return false;
      }
    }
    return true;
  }
}

abstract class IPolicy<U> extends Entity<IPolicy> {
  bool allows(ICommand action, U user);
}

class AllowAllPolicy<U> extends IPolicy<U> {
  /// Default access policy for an entity.
  bool allows(ICommand action, U user) => true;
}

class DenyAllPolicy<U> extends IPolicy<U> {
  /// Default access policy for an entity.
  bool allows(ICommand action, U user) => false;
}

extension Mrkvica on IEntity {

}
