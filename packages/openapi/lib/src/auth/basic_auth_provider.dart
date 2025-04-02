part of openapi;

/// Provider for basic authentication.
///
/// This provider authenticates requests using HTTP Basic Auth.
class BasicAuthProvider implements AuthProvider {
  /// Map of usernames to passwords.
  final Map<String, String> _credentials;
  
  /// Map of usernames to user IDs.
  final Map<String, String> _userIds;
  
  /// Map of usernames to tenant IDs.
  final Map<String, String> _userTenants;
  
  /// Map of usernames to roles.
  final Map<String, List<String>> _userRoles;
  
  /// Creates a new basic auth provider.
  ///
  /// Parameters:
  /// - [credentials]: Optional map of usernames to passwords
  /// - [userIds]: Optional map of usernames to user IDs
  /// - [userTenants]: Optional map of usernames to tenant IDs
  /// - [userRoles]: Optional map of usernames to roles
  BasicAuthProvider({
    Map<String, String>? credentials,
    Map<String, String>? userIds,
    Map<String, String>? userTenants,
    Map<String, List<String>>? userRoles,
  }) : _credentials = credentials ?? {},
       _userIds = userIds ?? {},
       _userTenants = userTenants ?? {},
       _userRoles = userRoles ?? {};
  
  /// Adds a user.
  ///
  /// Parameters:
  /// - [username]: The username to add
  /// - [password]: The password for the user
  /// - [userId]: Optional user ID (defaults to username)
  /// - [tenantId]: Optional tenant ID for the user
  /// - [roles]: Optional roles for the user
  void addUser(
    String username,
    String password, {
    String? userId,
    String? tenantId,
    List<String>? roles,
  }) {
    _credentials[username] = password;
    _userIds[username] = userId ?? username;
    
    if (tenantId != null) {
      _userTenants[username] = tenantId;
    }
    
    if (roles != null) {
      _userRoles[username] = roles;
    }
  }
  
  /// Removes a user.
  ///
  /// Parameters:
  /// - [username]: The username to remove
  void removeUser(String username) {
    _credentials.remove(username);
    _userIds.remove(username);
    _userTenants.remove(username);
    _userRoles.remove(username);
  }
  
  @override
  Future<AuthResult> authenticate(shelf.Request request) async {
    // Get Authorization header
    final authHeader = request.headers['authorization'];
    if (authHeader == null || !authHeader.startsWith('Basic ')) {
      return AuthResult.failure();
    }
    
    // Decode Basic Auth credentials
    try {
      final encoded = authHeader.substring(6).trim();
      final decoded = String.fromCharCodes(base64.decode(encoded));
      final colonIndex = decoded.indexOf(':');
      
      if (colonIndex < 0) {
        return AuthResult.failure();
      }
      
      final username = decoded.substring(0, colonIndex);
      final password = decoded.substring(colonIndex + 1);
      
      // Check if credentials are valid
      final storedPassword = _credentials[username];
      if (storedPassword == null || storedPassword != password) {
        return AuthResult.failure();
      }
      
      // Get user ID, tenant ID, and roles
      final userId = _userIds[username] ?? username;
      final tenantId = _userTenants[username];
      final roles = _userRoles[username] ?? [];
      
      return AuthResult.success(
        userId: userId,
        tenantId: tenantId,
        roles: roles,
      );
    } catch (e) {
      return AuthResult.failure();
    }
  }
} 