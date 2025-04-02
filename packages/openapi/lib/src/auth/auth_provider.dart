part of openapi;

/// Result of an authentication attempt.
class AuthResult {
  /// Whether the authentication succeeded.
  final bool authenticated;
  
  /// The ID of the authenticated user.
  final String? userId;
  
  /// The ID of the tenant the user belongs to.
  final String? tenantId;
  
  /// The roles of the user.
  final List<String> roles;
  
  /// Creates a new auth result.
  ///
  /// Parameters:
  /// - [authenticated]: Whether the authentication succeeded
  /// - [userId]: The ID of the authenticated user
  /// - [tenantId]: The ID of the tenant the user belongs to
  /// - [roles]: The roles of the user
  AuthResult({
    required this.authenticated,
    this.userId,
    this.tenantId,
    this.roles = const [],
  });
  
  /// Creates a successful auth result.
  ///
  /// Parameters:
  /// - [userId]: The ID of the authenticated user
  /// - [tenantId]: The ID of the tenant the user belongs to
  /// - [roles]: The roles of the user
  ///
  /// Returns:
  /// A successful auth result
  factory AuthResult.success({
    required String userId,
    String? tenantId,
    List<String> roles = const [],
  }) {
    return AuthResult(
      authenticated: true,
      userId: userId,
      tenantId: tenantId,
      roles: roles,
    );
  }
  
  /// Creates a failed auth result.
  ///
  /// Returns:
  /// A failed auth result
  factory AuthResult.failure() {
    return AuthResult(authenticated: false);
  }
}

/// Provider for authentication.
///
/// This abstract class defines methods for authenticating
/// requests based on different authentication schemes.
abstract class AuthProvider {
  /// Authenticates a request.
  ///
  /// Parameters:
  /// - [request]: The HTTP request to authenticate
  ///
  /// Returns:
  /// A Future with the auth result
  Future<AuthResult> authenticate(shelf.Request request);
}

/// Provider that doesn't require authentication.
///
/// This provider always returns a successful auth result.
class NoAuthProvider implements AuthProvider {
  @override
  Future<AuthResult> authenticate(shelf.Request request) async {
    return AuthResult.success(
      userId: 'anonymous',
      roles: ['anonymous'],
    );
  }
} 