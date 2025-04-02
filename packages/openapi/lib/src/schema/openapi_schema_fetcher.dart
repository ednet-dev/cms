part of openapi;

/// Utility for fetching OpenAPI schemas from endpoints.
///
/// This class provides methods to discover and fetch OpenAPI schemas
/// from servers, enabling runtime integration with unknown APIs.
class OpenApiSchemaFetcher {
  /// The HTTP client used for requests.
  final HttpClient _client;
  
  /// Common OpenAPI specification paths to try.
  static const List<String> _commonPaths = [
    '/openapi.json',
    '/swagger.json',
    '/api-docs',
    '/v3/api-docs',
    '/v2/api-docs',
    '/openapi',
    '/swagger',
  ];
  
  /// Creates a new schema fetcher.
  ///
  /// Parameters:
  /// - [client]: Optional HTTP client to use
  OpenApiSchemaFetcher({HttpClient? client}) 
      : _client = client ?? HttpClient();
  
  /// Fetches an OpenAPI schema from a URL.
  ///
  /// Parameters:
  /// - [url]: The URL to fetch the schema from
  /// - [headers]: Optional additional headers to include
  ///
  /// Returns:
  /// A Future with the schema as a Map
  Future<Map<String, dynamic>> fetchSchema(
    String url, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    
    try {
      final request = await _client.getUrl(uri);
      
      // Add any specified headers
      headers?.forEach((key, value) {
        request.headers.add(key, value);
      });
      
      // Add common accept headers for API docs
      request.headers.add('Accept', 'application/json');
      
      final response = await request.close();
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch schema: HTTP ${response.statusCode}');
      }
      
      final body = await response.transform(utf8.decoder).join();
      final result = json.decode(body) as Map<String, dynamic>;
      
      return result;
    } catch (e) {
      throw Exception('Failed to fetch schema: $e');
    }
  }
  
  /// Discovers an OpenAPI schema by trying common endpoints.
  ///
  /// This method attempts to find an OpenAPI schema by trying common
  /// endpoints where the specification is typically published.
  ///
  /// Parameters:
  /// - [baseUrl]: The base URL of the API
  /// - [headers]: Optional additional headers to include
  ///
  /// Returns:
  /// A Future with the schema as a Map, or null if not found
  Future<Map<String, dynamic>?> discoverSchema(
    String baseUrl, {
    Map<String, String>? headers,
  }) async {
    // Ensure the base URL doesn't end with a slash
    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;
    
    // Try each common path
    for (final path in _commonPaths) {
      try {
        return await fetchSchema(
          '$cleanBaseUrl$path',
          headers: headers,
        );
      } catch (e) {
        // Continue to next path
      }
    }
    
    // No schema found
    return null;
  }
  
  /// Checks if a URL has an OpenAPI schema.
  ///
  /// Parameters:
  /// - [url]: The URL to check
  /// - [headers]: Optional additional headers to include
  ///
  /// Returns:
  /// A Future that resolves to true if a schema is found
  Future<bool> hasOpenApiSchema(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final schema = await discoverSchema(url, headers: headers);
      return schema != null;
    } catch (e) {
      return false;
    }
  }
} 