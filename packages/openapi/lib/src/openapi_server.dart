part of openapi;

/// Server for OpenAPI endpoints.
///
/// This class creates a web server that exposes OpenAPI endpoints
/// for all concepts in a domain model.
class OpenApiServer {
  /// The domain model.
  final Domain _domain;
  
  /// The server port.
  final int _port;
  
  /// The server host.
  final String _host;
  
  /// The repository factory.
  final RepositoryFactory _repositoryFactory;
  
  /// Configuration for authentication.
  final AuthConfig _authConfig;
  
  /// Whether to enable Swagger UI.
  final bool _enableSwaggerUi;
  
  /// The HTTP server instance.
  HttpServer? _server;
  
  /// The router for handling requests.
  late final shelf_router.Router _router;
  
  /// The auth provider for authentication.
  late final AuthProvider _authProvider;
  
  /// Creates a new OpenAPI server.
  ///
  /// Parameters:
  /// - [domain]: The domain model
  /// - [port]: The port to listen on
  /// - [host]: The host to bind to
  /// - [repositoryFactory]: Optional repository factory
  /// - [authConfig]: Optional authentication configuration
  /// - [enableSwaggerUi]: Whether to enable Swagger UI
  OpenApiServer({
    required Domain domain,
    required int port,
    String host = 'localhost',
    RepositoryFactory? repositoryFactory,
    AuthConfig? authConfig,
    bool enableSwaggerUi = true,
  }) : _domain = domain,
       _port = port,
       _host = host,
       _repositoryFactory = repositoryFactory ?? OpenApiRepositoryFactory(
         domain: domain,
         baseUrl: 'http://$host:$port',
         authConfig: authConfig,
       ),
       _authConfig = authConfig ?? AuthConfig.none(),
       _enableSwaggerUi = enableSwaggerUi {
    _router = shelf_router.Router();
    _authProvider = _createAuthProvider();
    _setupRoutes();
  }
  
  /// Starts the server.
  ///
  /// Returns:
  /// A Future that completes when the server is started
  Future<void> start() async {
    final handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addMiddleware(_createAuthMiddleware())
        .addMiddleware(_createCorsMiddleware())
        .addHandler(_router);
    
    _server = await shelf_io.serve(handler, _host, _port);
    
    print('Server started at http://$_host:$_port');
    if (_enableSwaggerUi) {
      print('Swagger UI available at http://$_host:$_port/swagger-ui');
    }
  }
  
  /// Stops the server.
  ///
  /// Returns:
  /// A Future that completes when the server is stopped
  Future<void> stop() async {
    await _server?.close();
    print('Server stopped');
  }
  
  /// Creates authentication middleware based on auth config.
  ///
  /// Returns:
  /// Authentication middleware
  shelf.Middleware _createAuthMiddleware() {
    return (shelf.Handler handler) {
      return (shelf.Request request) async {
        // Skip authentication for OpenAPI spec and Swagger UI
        if (request.url.path == 'openapi.json' ||
            request.url.path.startsWith('swagger-ui')) {
          return handler(request);
        }
        
        // Skip authentication if none is configured
        if (_authConfig.type == AuthType.none) {
          return handler(request);
        }
        
        // Check authentication
        final authResult = await _authProvider.authenticate(request);
        if (authResult.authenticated) {
          // Add authentication context to request
          final newRequest = request.change(context: {
            'userId': authResult.userId,
            'tenantId': authResult.tenantId,
            'roles': authResult.roles,
          });
          return handler(newRequest);
        } else {
          return shelf.Response.unauthorized(
            'Unauthorized',
            headers: {'WWW-Authenticate': _getAuthenticateHeader()},
          );
        }
      };
    };
  }
  
  /// Creates CORS middleware.
  ///
  /// Returns:
  /// CORS middleware
  shelf.Middleware _createCorsMiddleware() {
    return (shelf.Handler handler) {
      return (shelf.Request request) async {
        // Handle preflight requests
        if (request.method == 'OPTIONS') {
          return shelf.Response.ok('', headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization, X-Requested-With',
            'Access-Control-Max-Age': '86400',
          });
        }
        
        // Handle actual requests
        final response = await handler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          ...response.headers,
        });
      };
    };
  }
  
  /// Creates an auth provider based on auth config.
  ///
  /// Returns:
  /// An auth provider
  AuthProvider _createAuthProvider() {
    switch (_authConfig.type) {
      case AuthType.apiKey:
        return ApiKeyAuthProvider(headerName: _authConfig.headerName ?? 'X-API-Key');
      case AuthType.bearer:
        return BearerAuthProvider();
      case AuthType.basic:
        return BasicAuthProvider();
      case AuthType.oauth2:
        return OAuth2AuthProvider(
          authorizationUrl: _authConfig.authorizationUrl ?? '',
          tokenUrl: _authConfig.tokenUrl ?? '',
          scopes: _authConfig.scopes ?? {},
        );
      case AuthType.none:
      default:
        return NoAuthProvider();
    }
  }
  
  /// Gets the WWW-Authenticate header based on auth config.
  ///
  /// Returns:
  /// The WWW-Authenticate header value
  String _getAuthenticateHeader() {
    switch (_authConfig.type) {
      case AuthType.apiKey:
        return 'APIKey';
      case AuthType.bearer:
        return 'Bearer';
      case AuthType.basic:
        return 'Basic realm="EDNet API"';
      case AuthType.oauth2:
        return 'OAuth2';
      case AuthType.none:
      default:
        return '';
    }
  }
  
  /// Sets up all routes for the server.
  void _setupRoutes() {
    // OpenAPI specification
    _router.get('/openapi.json', _handleOpenApiSpec);
    
    // Swagger UI
    if (_enableSwaggerUi) {
      _router.get('/swagger-ui', _handleSwaggerUiRedirect);
      _router.get('/swagger-ui/', _handleSwaggerUiIndex);
      _router.get('/swagger-ui/<file|.*>', _handleSwaggerUiFile);
    }
    
    // Routes for each concept
    for (final concept in _domain.concepts) {
      final entityName = concept.name;
      final endpoint = entityName.toLowerCase();
      
      // Create repository for this concept
      final repository = _repositoryFactory.createRepository(concept);
      
      // GET /endpoint - List all entities
      _router.get('/$endpoint', (shelf.Request request) => _handleList(request, concept, repository));
      
      // GET /endpoint/count - Count entities
      _router.get('/$endpoint/count', (shelf.Request request) => _handleCount(request, concept, repository));
      
      // GET /endpoint/{id} - Get entity by ID
      _router.get('/$endpoint/<id>', (shelf.Request request, String id) => _handleGet(request, concept, repository, id));
      
      // POST /endpoint - Create new entity
      _router.post('/$endpoint', (shelf.Request request) => _handleCreate(request, concept, repository));
      
      // PUT /endpoint/{id} - Update entity
      _router.put('/$endpoint/<id>', (shelf.Request request, String id) => _handleUpdate(request, concept, repository, id));
      
      // DELETE /endpoint/{id} - Delete entity
      _router.delete('/$endpoint/<id>', (shelf.Request request, String id) => _handleDelete(request, concept, repository, id));
    }
    
    // Default route
    _router.all('/<ignored|.*>', _handleNotFound);
  }
  
  /// Handles requests for the OpenAPI specification.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  ///
  /// Returns:
  /// A response with the OpenAPI specification
  Future<shelf.Response> _handleOpenApiSpec(shelf.Request request) async {
    final factory = _repositoryFactory as OpenApiRepositoryFactory;
    final spec = factory.generateOpenApiSpec(
      title: '${_domain.name} API',
      version: '1.0.0',
      description: 'API for ${_domain.name} domain',
    );
    
    return shelf.Response.ok(
      jsonEncode(spec),
      headers: {'Content-Type': 'application/json'},
    );
  }
  
  /// Handles redirects for Swagger UI.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  ///
  /// Returns:
  /// A redirect response
  Future<shelf.Response> _handleSwaggerUiRedirect(shelf.Request request) async {
    return shelf.Response.found('/swagger-ui/');
  }
  
  /// Handles requests for the Swagger UI index page.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  ///
  /// Returns:
  /// A response with the Swagger UI index page
  Future<shelf.Response> _handleSwaggerUiIndex(shelf.Request request) async {
    final html = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Swagger UI</title>
  <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css">
  <style>
    html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
    *, *:before, *:after { box-sizing: inherit; }
    body { margin: 0; padding: 0; }
  </style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js"></script>
  <script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-standalone-preset.js"></script>
  <script>
    window.onload = function() {
      const ui = SwaggerUIBundle({
        url: "/openapi.json",
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [
          SwaggerUIBundle.presets.apis,
          SwaggerUIStandalonePreset
        ],
        layout: "StandaloneLayout",
      });
      window.ui = ui;
    };
  </script>
</body>
</html>
''';
    
    return shelf.Response.ok(
      html,
      headers: {'Content-Type': 'text/html'},
    );
  }
  
  /// Handles requests for Swagger UI files.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [file]: The file to serve
  ///
  /// Returns:
  /// A response with the requested file or a 404
  Future<shelf.Response> _handleSwaggerUiFile(shelf.Request request, String file) async {
    // All files are served from unpkg.com in this implementation
    return shelf.Response.notFound('File not found');
  }
  
  /// Handles list requests.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [concept]: The concept being queried
  /// - [repository]: The repository for the concept
  ///
  /// Returns:
  /// A response with the list of entities
  Future<shelf.Response> _handleList(
    shelf.Request request,
    Concept concept,
    Repository<Entity> repository,
  ) async {
    try {
      // Extract query parameters
      final queryParams = request.url.queryParameters;
      
      // Build filter criteria
      final criteria = FilterCriteria<Entity>();
      
      // Extract pagination parameters
      final skip = int.tryParse(queryParams['skip'] ?? '');
      final take = int.tryParse(queryParams['take'] ?? '');
      
      // Extract sorting parameters
      final sortBy = queryParams['sortBy'];
      final sortDirection = queryParams['sortDirection'];
      
      if (sortBy != null) {
        criteria.orderBy(sortBy, ascending: sortDirection != 'desc');
      }
      
      // Add filter criteria for each attribute
      for (final entry in queryParams.entries) {
        final key = entry.key;
        final value = entry.value;
        
        // Skip pagination and sorting parameters
        if (['skip', 'take', 'sortBy', 'sortDirection'].contains(key)) {
          continue;
        }
        
        // Add criterion for this parameter
        criteria.addCriterion(Criterion(key, value));
      }
      
      // Execute the query
      final entities = await repository.findByCriteria(criteria, skip: skip, take: take);
      
      // Convert entities to JSON
      final jsonList = entities.map(_entityToJson).toList();
      
      return shelf.Response.ok(
        jsonEncode(jsonList),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  
  /// Handles count requests.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [concept]: The concept being queried
  /// - [repository]: The repository for the concept
  ///
  /// Returns:
  /// A response with the count of entities
  Future<shelf.Response> _handleCount(
    shelf.Request request,
    Concept concept,
    Repository<Entity> repository,
  ) async {
    try {
      // Extract query parameters
      final queryParams = request.url.queryParameters;
      
      // Build filter criteria
      final criteria = FilterCriteria<Entity>();
      
      // Add filter criteria for each attribute
      for (final entry in queryParams.entries) {
        final key = entry.key;
        final value = entry.value;
        
        // Skip count parameter
        if (key == 'count') {
          continue;
        }
        
        // Add criterion for this parameter
        criteria.addCriterion(Criterion(key, value));
      }
      
      // Execute the query
      final count = await repository.countByCriteria(criteria);
      
      return shelf.Response.ok(
        jsonEncode({'count': count}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  
  /// Handles get requests.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [concept]: The concept being queried
  /// - [repository]: The repository for the concept
  /// - [id]: The ID of the entity to get
  ///
  /// Returns:
  /// A response with the entity or a 404
  Future<shelf.Response> _handleGet(
    shelf.Request request,
    Concept concept,
    Repository<Entity> repository,
    String id,
  ) async {
    try {
      final entity = await repository.findById(id);
      
      if (entity == null) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Entity not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      
      return shelf.Response.ok(
        jsonEncode(_entityToJson(entity)),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  
  /// Handles create requests.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [concept]: The concept being modified
  /// - [repository]: The repository for the concept
  ///
  /// Returns:
  /// A response with the created entity
  Future<shelf.Response> _handleCreate(
    shelf.Request request,
    Concept concept,
    Repository<Entity> repository,
  ) async {
    try {
      // Parse request body
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      
      // Create entity
      final entity = DomainEntity(concept, data);
      
      // Save entity
      await repository.save(entity);
      
      return shelf.Response(
        201,
        body: jsonEncode(_entityToJson(entity)),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  
  /// Handles update requests.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [concept]: The concept being modified
  /// - [repository]: The repository for the concept
  /// - [id]: The ID of the entity to update
  ///
  /// Returns:
  /// A response with the updated entity or a 404
  Future<shelf.Response> _handleUpdate(
    shelf.Request request,
    Concept concept,
    Repository<Entity> repository,
    String id,
  ) async {
    try {
      // Check if entity exists
      final existingEntity = await repository.findById(id);
      if (existingEntity == null) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Entity not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      
      // Parse request body
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      
      // Ensure ID matches
      data['id'] = id;
      
      // Create updated entity
      final updatedEntity = DomainEntity(concept, data);
      
      // Save entity
      await repository.save(updatedEntity);
      
      return shelf.Response.ok(
        jsonEncode(_entityToJson(updatedEntity)),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  
  /// Handles delete requests.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  /// - [concept]: The concept being modified
  /// - [repository]: The repository for the concept
  /// - [id]: The ID of the entity to delete
  ///
  /// Returns:
  /// A response indicating success or a 404
  Future<shelf.Response> _handleDelete(
    shelf.Request request,
    Concept concept,
    Repository<Entity> repository,
    String id,
  ) async {
    try {
      // Check if entity exists
      final entity = await repository.findById(id);
      if (entity == null) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Entity not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      
      // Delete entity
      await repository.delete(entity);
      
      return shelf.Response(
        204,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  
  /// Handles 404 (not found) responses.
  ///
  /// Parameters:
  /// - [request]: The HTTP request
  ///
  /// Returns:
  /// A 404 response
  Future<shelf.Response> _handleNotFound(shelf.Request request) async {
    return shelf.Response.notFound(
      jsonEncode({'error': 'Not found'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
  
  /// Converts an entity to a JSON map.
  ///
  /// Parameters:
  /// - [entity]: The entity to convert
  ///
  /// Returns:
  /// A JSON-serializable map
  Map<String, dynamic> _entityToJson(Entity entity) {
    if (entity is DomainEntity) {
      return Map<String, dynamic>.from(entity.data);
    } else {
      final result = <String, dynamic>{};
      
      // Add the ID
      result['id'] = entity.id;
      
      // Extract other attributes
      final concept = _domain.findConcept(entity.runtimeType.toString());
      if (concept != null) {
        for (final attribute in concept.attributes) {
          final key = attribute.name;
          final value = entity.getAttribute(key);
          if (value != null) {
            result[key] = value;
          }
        }
      }
      
      return result;
    }
  }
} 