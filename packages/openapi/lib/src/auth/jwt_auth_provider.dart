part of openapi;

/// Provider for JWT authentication.
///
/// This provider authenticates requests using a JWT token
/// in the Authorization header.
class JwtAuthProvider implements AuthProvider {
  /// The secret used to verify tokens.
  final String _secret;
  
  /// The name of the claim containing the user ID.
  final String _userIdClaim;
  
  /// The name of the claim containing the tenant ID.
  final String _tenantIdClaim;
  
  /// The name of the claim containing the roles.
  final String _rolesClaim;
  
  /// Creates a new JWT auth provider.
  ///
  /// Parameters:
  /// - [secret]: The secret used to verify tokens
  /// - [userIdClaim]: The name of the claim containing the user ID (default: 'sub')
  /// - [tenantIdClaim]: The name of the claim containing the tenant ID (default: 'tenant_id')
  /// - [rolesClaim]: The name of the claim containing the roles (default: 'roles')
  JwtAuthProvider({
    required String secret,
    String userIdClaim = 'sub',
    String tenantIdClaim = 'tenant_id',
    String rolesClaim = 'roles',
  }) : _secret = secret,
       _userIdClaim = userIdClaim,
       _tenantIdClaim = tenantIdClaim,
       _rolesClaim = rolesClaim;
  
  @override
  Future<AuthResult> authenticate(shelf.Request request) async {
    // Get Authorization header
    final authHeader = request.headers['authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return AuthResult.failure();
    }
    
    // Extract token
    final token = authHeader.substring(7).trim();
    
    try {
      // Decode token
      final parts = token.split('.');
      if (parts.length != 3) {
        return AuthResult.failure();
      }
      
      // Decode payload
      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64.decode(normalized));
      final json = jsonDecode(decoded) as Map<String, dynamic>;
      
      // TODO: In a real implementation, verify the token signature using the secret
      
      // Extract claims
      final userId = json[_userIdClaim] as String?;
      if (userId == null) {
        return AuthResult.failure();
      }
      
      final tenantId = json[_tenantIdClaim] as String?;
      
      List<String> roles = [];
      if (json[_rolesClaim] is List) {
        roles = (json[_rolesClaim] as List).cast<String>();
      } else if (json[_rolesClaim] is String) {
        roles = [(json[_rolesClaim] as String)];
      }
      
      return AuthResult.success(
        userId: userId,
        tenantId: tenantId,
        roles: roles,
      );
    } catch (e) {
      return AuthResult.failure();
    }
  }
  
  /// Generates a JWT token.
  ///
  /// Parameters:
  /// - [userId]: The user ID to include in the token
  /// - [tenantId]: Optional tenant ID to include in the token
  /// - [roles]: Optional roles to include in the token
  /// - [expiry]: Optional expiry time for the token
  ///
  /// Returns:
  /// A JWT token as a string
  String generateToken({
    required String userId,
    String? tenantId,
    List<String>? roles,
    DateTime? expiry,
  }) {
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };
    
    final payload = <String, dynamic>{
      _userIdClaim: userId,
    };
    
    if (tenantId != null) {
      payload[_tenantIdClaim] = tenantId;
    }
    
    if (roles != null && roles.isNotEmpty) {
      payload[_rolesClaim] = roles;
    }
    
    if (expiry != null) {
      payload['exp'] = expiry.millisecondsSinceEpoch ~/ 1000;
    }
    
    // Encode header
    final headerJson = jsonEncode(header);
    final headerBase64 = base64Url.encode(utf8.encode(headerJson)).replaceAll('=', '');
    
    // Encode payload
    final payloadJson = jsonEncode(payload);
    final payloadBase64 = base64Url.encode(utf8.encode(payloadJson)).replaceAll('=', '');
    
    // Create signature (simplified)
    // In a real implementation, use a proper JWT library for this
    final signature = base64Url.encode(
      utf8.encode('$headerBase64.$payloadBase64.$_secret'),
    ).replaceAll('=', '');
    
    return '$headerBase64.$payloadBase64.$signature';
  }
} 