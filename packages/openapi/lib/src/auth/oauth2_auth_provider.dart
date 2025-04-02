part of openapi;

/// Provider for OAuth 2.0 authentication.
///
/// This provider authenticates requests using OAuth 2.0 tokens
/// in the Authorization header.
class OAuth2AuthProvider implements AuthProvider {
  /// The authorization URL.
  final String _authorizationUrl;
  
  /// The token URL.
  final String _tokenUrl;
  
  /// The available scopes.
  final Map<String, String> _scopes;
  
  /// Map of valid tokens to token info.
  final Map<String, _TokenInfo> _tokens = {};
  
  /// Creates a new OAuth 2.0 auth provider.
  ///
  /// Parameters:
  /// - [authorizationUrl]: The authorization URL
  /// - [tokenUrl]: The token URL
  /// - [scopes]: The available scopes
  OAuth2AuthProvider({
    required String authorizationUrl,
    required String tokenUrl,
    Map<String, String> scopes = const {},
  }) : _authorizationUrl = authorizationUrl,
       _tokenUrl = tokenUrl,
       _scopes = Map.from(scopes);
  
  /// Gets the authorization URL.
  ///
  /// Returns:
  /// The authorization URL
  String get authorizationUrl => _authorizationUrl;
  
  /// Gets the token URL.
  ///
  /// Returns:
  /// The token URL
  String get tokenUrl => _tokenUrl;
  
  /// Gets the available scopes.
  ///
  /// Returns:
  /// The available scopes
  Map<String, String> get scopes => Map.from(_scopes);
  
  /// Adds a token.
  ///
  /// Parameters:
  /// - [token]: The token to add
  /// - [userId]: The user ID the token belongs to
  /// - [tenantId]: Optional tenant ID for the user
  /// - [roles]: Optional roles for the user
  /// - [scopes]: Optional scopes for the token
  /// - [expiry]: Optional expiry time for the token
  void addToken(
    String token,
    String userId, {
    String? tenantId,
    List<String>? roles,
    List<String>? scopes,
    DateTime? expiry,
  }) {
    _tokens[token] = _TokenInfo(
      userId: userId,
      tenantId: tenantId,
      roles: roles ?? [],
      scopes: scopes ?? [],
      expiry: expiry,
    );
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
    final tokenInfo = _tokens[token];
    if (tokenInfo == null) {
      return AuthResult.failure();
    }
    
    // Check if token has expired
    if (tokenInfo.expiry != null && tokenInfo.expiry!.isBefore(DateTime.now())) {
      _tokens.remove(token);
      return AuthResult.failure();
    }
    
    return AuthResult.success(
      userId: tokenInfo.userId,
      tenantId: tokenInfo.tenantId,
      roles: tokenInfo.roles,
    );
  }
  
  /// Generates an authorization URL.
  ///
  /// Parameters:
  /// - [clientId]: The client ID
  /// - [redirectUri]: The redirect URI
  /// - [state]: Optional state parameter
  /// - [scopes]: Optional scopes to request
  ///
  /// Returns:
  /// The authorization URL
  String getAuthorizationUrl({
    required String clientId,
    required String redirectUri,
    String? state,
    List<String>? scopes,
  }) {
    final params = <String, String>{
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
    };
    
    if (state != null) {
      params['state'] = state;
    }
    
    if (scopes != null && scopes.isNotEmpty) {
      params['scope'] = scopes.join(' ');
    }
    
    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$_authorizationUrl?$query';
  }
}

/// Information about a token.
class _TokenInfo {
  /// The user ID associated with the token.
  final String userId;
  
  /// The tenant ID associated with the token.
  final String? tenantId;
  
  /// The roles associated with the token.
  final List<String> roles;
  
  /// The scopes associated with the token.
  final List<String> scopes;
  
  /// The expiry time of the token.
  final DateTime? expiry;
  
  /// Creates new token info.
  ///
  /// Parameters:
  /// - [userId]: The user ID associated with the token
  /// - [tenantId]: The tenant ID associated with the token
  /// - [roles]: The roles associated with the token
  /// - [scopes]: The scopes associated with the token
  /// - [expiry]: The expiry time of the token
  _TokenInfo({
    required this.userId,
    this.tenantId,
    this.roles = const [],
    this.scopes = const [],
    this.expiry,
  });
} 