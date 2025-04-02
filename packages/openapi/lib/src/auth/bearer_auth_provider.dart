part of openapi;

/// Provider for bearer token authentication.
///
/// This provider authenticates requests using a bearer token
/// in the Authorization header.
class BearerAuthProvider implements AuthProvider {
  /// Map of valid tokens to user IDs.
  final Map<String, String> _tokens;
  
  /// Map of user IDs to tenant IDs.
  final Map<String, String> _userTenants;
  
  /// Map of user IDs to roles.
  final Map<String, List<String>> _userRoles;
  
  /// Creates a new bearer auth provider.
  ///
  /// Parameters:
  /// - [tokens]: Optional map of valid tokens to user IDs
  /// - [userTenants]: Optional map of user IDs to tenant IDs
  /// - [userRoles]: Optional map of user IDs to roles
  BearerAuthProvider({
    Map<String, String>? tokens,
    Map<String, String>? userTenants,
    Map<String, List<String>>? userRoles,
  }) : _tokens = tokens ?? {},
       _userTenants = userTenants ?? {},
       _userRoles = userRoles ?? {};
  
  /// Adds a token.
  ///
  /// Parameters:
  /// - [token]: The token to add
  /// - [userId]: The user ID the token belongs to
  /// - [tenantId]: Optional tenant ID for the user
  /// - [roles]: Optional roles for the user
  void addToken(
    String token,
    String userId, {
    String? tenantId,
    List<String>? roles,
  }) {
    _tokens[token] = userId;
    
    if (tenantId != null) {
      _userTenants[userId] = tenantId;
    }
    
    if (roles != null) {
      _userRoles[userId] = roles;
    }
  }
  
  /// Removes a token.
  ///
  /// Parameters:
  /// - [token]: The token to remove
  void removeToken(String token) {
    _tokens.remove(token);
  }
  
  @override
  Future<AuthResult> authenticate(shelf.Request request) async {
    // Get Authorization header
    final authHeader = request.headers['authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return AuthResult.failure();
    }
    
    // Extract token
    final token = authHeader.substring(7).trim();
    
    // Check if token is valid
    final userId = _tokens[token];
    if (userId == null) {
      return AuthResult.failure();
    }
    
    // Get tenant ID and roles
    final tenantId = _userTenants[userId];
    final roles = _userRoles[userId] ?? [];
    
    return AuthResult.success(
      userId: userId,
      tenantId: tenantId,
      roles: roles,
    );
  }
} 