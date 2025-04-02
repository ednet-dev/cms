part of openapi;

/// Provider for API key authentication.
///
/// This provider authenticates requests using an API key
/// in a header.
class ApiKeyAuthProvider implements AuthProvider {
  /// The name of the header containing the API key.
  final String _headerName;
  
  /// Map of valid API keys to user IDs.
  final Map<String, String> _apiKeys;
  
  /// Map of user IDs to tenant IDs.
  final Map<String, String> _userTenants;
  
  /// Map of user IDs to roles.
  final Map<String, List<String>> _userRoles;
  
  /// Creates a new API key auth provider.
  ///
  /// Parameters:
  /// - [headerName]: The name of the header containing the API key
  /// - [apiKeys]: Optional map of valid API keys to user IDs
  /// - [userTenants]: Optional map of user IDs to tenant IDs
  /// - [userRoles]: Optional map of user IDs to roles
  ApiKeyAuthProvider({
    String headerName = 'X-API-Key',
    Map<String, String>? apiKeys,
    Map<String, String>? userTenants,
    Map<String, List<String>>? userRoles,
  }) : _headerName = headerName,
       _apiKeys = apiKeys ?? {},
       _userTenants = userTenants ?? {},
       _userRoles = userRoles ?? {};
  
  /// Adds an API key.
  ///
  /// Parameters:
  /// - [apiKey]: The API key to add
  /// - [userId]: The user ID the API key belongs to
  /// - [tenantId]: Optional tenant ID for the user
  /// - [roles]: Optional roles for the user
  void addApiKey(
    String apiKey,
    String userId, {
    String? tenantId,
    List<String>? roles,
  }) {
    _apiKeys[apiKey] = userId;
    
    if (tenantId != null) {
      _userTenants[userId] = tenantId;
    }
    
    if (roles != null) {
      _userRoles[userId] = roles;
    }
  }
  
  /// Removes an API key.
  ///
  /// Parameters:
  /// - [apiKey]: The API key to remove
  void removeApiKey(String apiKey) {
    _apiKeys.remove(apiKey);
  }
  
  @override
  Future<AuthResult> authenticate(shelf.Request request) async {
    // Get API key from header
    final apiKey = request.headers[_headerName];
    if (apiKey == null) {
      return AuthResult.failure();
    }
    
    // Check if API key is valid
    final userId = _apiKeys[apiKey];
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