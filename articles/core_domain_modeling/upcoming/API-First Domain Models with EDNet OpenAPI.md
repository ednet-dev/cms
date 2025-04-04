# API-First Domain Models with EDNet OpenAPI: Bridging Domains and Services

## Introduction

In an increasingly interconnected world, domain models don't exist in isolation. They need to be accessible to other systems, exposed to front-end applications, and documented for developers who consume them. While EDNet Core provides powerful domain modeling capabilities, EDNet OpenAPI extends these capabilities by enabling an API-first approach to domain modeling.

This article explores how EDNet OpenAPI seamlessly translates your domain models into well-documented, standards-compliant APIs, making your domain logic accessible to the wider world while maintaining the integrity and expressiveness of your domain model.

## The API-First Approach

Traditional approaches to exposing domain models often involve:

1. **Retrofitting APIs**: Adding an API layer on top of an existing domain model
2. **Manual translation**: Manually creating DTOs (Data Transfer Objects) to map between domain entities and API responses
3. **Custom documentation**: Maintaining separate API documentation that can drift from the actual implementation

The API-first approach with EDNet OpenAPI reverses this flow:

1. **Define domain boundaries**: Identify which parts of your domain should be exposed via APIs
2. **Generate OpenAPI specifications**: Automatically create OpenAPI specifications from your domain model
3. **Implement API handlers**: Connect the generated API endpoints to your domain logic
4. **Generate client SDKs**: Optionally generate client libraries for various platforms

This approach ensures that your API is:

- **Consistent with your domain model**: All API endpoints directly reflect domain concepts
- **Automatically documented**: Documentation is generated from the same source as the implementation
- **Standards-compliant**: Following the OpenAPI specification ensures broad compatibility
- **Evolvable**: Changes to your domain model can automatically propagate to your API

## Introducing EDNet OpenAPI

EDNet OpenAPI is a package that provides:

1. **OpenAPI generation**: Convert EDNet Core domain models to OpenAPI specifications
2. **API server implementation**: Automatically implement API endpoints that connect to your domain model
3. **Interactive documentation**: Generate Swagger UI to explore and test your API
4. **Client SDK generation**: Create client libraries for multiple platforms
5. **Versioning support**: Manage API versions as your domain evolves

Let's explore each of these capabilities in detail.

## OpenAPI Specification Generation

The first step in the API-first approach is to generate an OpenAPI specification from your domain model:

```dart
// Convert an EDNet Core domain model to an OpenAPI specification
Future<OpenApiDocument> generateOpenApiFromDomain(Domain domain) async {
  final generator = EDNetOpenApiGenerator(
    title: 'My Domain API',
    description: 'API for accessing my domain model',
    version: '1.0.0',
  );
  
  // Generate the OpenAPI document
  final openApiDoc = await generator.generateFromDomain(domain);
  
  // Optionally customize the generated specification
  openApiDoc.servers = [
    OpenApiServer(url: 'https://api.example.com/v1'),
  ];
  
  // Save the specification to a file
  await generator.writeToFile(openApiDoc, 'openapi.yaml');
  
  return openApiDoc;
}
```

The resulting OpenAPI specification defines all your domain entities as schemas and exposes standard CRUD operations for each entity type.

## Example OpenAPI Specification

Here's a snippet of what the generated OpenAPI specification might look like for a simple electoral system:

```yaml
openapi: 3.0.3
info:
  title: Electoral System API
  description: API for accessing the electoral system domain model
  version: 1.0.0
servers:
  - url: https://api.elections.example.com/v1
paths:
  /parties:
    get:
      summary: List all political parties
      operationId: listParties
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
        - name: offset
          in: query
          schema:
            type: integer
            default: 0
      responses:
        '200':
          description: A list of political parties
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Party'
    post:
      summary: Create a new political party
      operationId: createParty
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PartyInput'
      responses:
        '201':
          description: The created party
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Party'
  /parties/{partyId}:
    get:
      summary: Get a political party by ID
      operationId: getParty
      parameters:
        - name: partyId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: The requested party
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Party'
components:
  schemas:
    Party:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        code:
          type: string
        logoUrl:
          type: string
          format: uri
        foundedDate:
          type: string
          format: date
      required:
        - id
        - name
        - code
    PartyInput:
      type: object
      properties:
        name:
          type: string
        code:
          type: string
        logoUrl:
          type: string
          format: uri
        foundedDate:
          type: string
          format: date
      required:
        - name
        - code
```

## API Server Implementation

Once the OpenAPI specification is generated, EDNet OpenAPI can automatically implement the API server:

```dart
// Create an API server from the OpenAPI specification
Future<void> startApiServer(
  OpenApiDocument openApiDoc,
  Domain domain,
  Repository repository,
) async {
  // Create the server implementation
  final server = EDNetOpenApiServer(
    openApiDoc: openApiDoc,
    domainRepository: repository,
  );
  
  // Register custom handlers for specific operations
  server.registerOperationHandler(
    'createParty',
    (request, params) => createPartyHandler(request, params, repository),
  );
  
  // Start the server
  await server.start(port: 8080);
  print('API server listening on port 8080');
}

// Custom handler for the createParty operation
Future<Response> createPartyHandler(
  Request request,
  Map<String, dynamic> params,
  Repository repository,
) async {
  final json = await request.readAsJson();
  
  // Create a domain entity from the request
  final party = Party();
  party.name = json['name'];
  party.code = json['code'];
  if (json['logoUrl'] != null) {
    party.logoUrl = json['logoUrl'];
  }
  if (json['foundedDate'] != null) {
    party.foundedDate = DateTime.parse(json['foundedDate']);
  }
  
  // Save to the repository
  await repository.save(party);
  
  // Return the created entity
  return Response.ok(
    jsonEncode(party.toJsonMap()),
    headers: {'Content-Type': 'application/json'},
  );
}
```

With this implementation, your domain model is now accessible through a RESTful API that follows the OpenAPI specification.

## Connecting Domain Logic to API Endpoints

One of the key benefits of EDNet OpenAPI is that it preserves your domain logic when exposing it through APIs. This means that business rules, validations, and policies defined in your domain model are automatically enforced through the API.

For example, if your domain model has a policy that prevents creating parties with duplicate names, this policy will be enforced when creating a party through the API:

```dart
// Domain policy for party uniqueness
class PartyUniquenessPolicy implements IPolicy {
  @override
  String get name => 'PartyUniquenessPolicy';
  
  @override
  bool evaluate(Entity entity) {
    if (entity is! Party) return true;
    
    // Check if a party with this name already exists
    final existingParty = entity.session.domain.models
        .getModelEntries('Party')
        .where((p) => p.getAttribute<String>('name') == entity.name)
        .whereType<Party>()
        .firstOrNull;
    
    // Policy passes if there's no existing party or it's the same entity
    return existingParty == null || existingParty.oid == entity.oid;
  }
}

// When a client makes a POST request to /parties with a duplicate name,
// the API will return a validation error:
// {
//   "error": "ValidationError",
//   "message": "A party with this name already exists",
//   "code": "POLICY_VIOLATION",
//   "details": {
//     "policy": "PartyUniquenessPolicy"
//   }
// }
```

This maintains the integrity of your domain model while making it accessible through a well-defined API.

## Interactive API Documentation

EDNet OpenAPI automatically generates interactive documentation for your API using Swagger UI:

```dart
// Create a documentation server
void startDocumentationServer(OpenApiDocument openApiDoc) {
  final server = EDNetSwaggerUIServer(
    openApiDoc: openApiDoc,
    title: 'Electoral System API Documentation',
  );
  
  server.start(port: 8081);
  print('Documentation server listening on port 8081');
}
```

This provides a user-friendly interface for exploring your API:

```
┌─────────────────────────────────────────────────────────────┐
│ Electoral System API Documentation                     v1.0.0│
├─────────────────────────────────────────────────────────────┤
│ ▾ Parties                                                   │
│   │                                                         │
│   ├─ GET /parties - List all political parties              │
│   │                                                         │
│   ├─ POST /parties - Create a new political party           │
│   │                                                         │
│   ├─ GET /parties/{partyId} - Get a political party by ID   │
│   │                                                         │
│   ├─ PUT /parties/{partyId} - Update a political party      │
│   │                                                         │
│   └─ DELETE /parties/{partyId} - Delete a political party   │
│                                                             │
│ ▾ Electoral Lists                                           │
│   │                                                         │
│   ├─ GET /electoral-lists - List all electoral lists        │
│   ...                                                       │
└─────────────────────────────────────────────────────────────┘
```

This documentation is not only helpful for developers but also serves as a communication tool when discussing your domain model with stakeholders.

## Client SDK Generation

Beyond serving the API, EDNet OpenAPI can also generate client SDKs for various platforms:

```dart
// Generate a Dart client SDK
Future<void> generateDartClient(OpenApiDocument openApiDoc) async {
  final generator = DartClientGenerator(
    openApiDoc: openApiDoc,
    packageName: 'electoral_system_client',
    outputDirectory: 'clients/dart',
  );
  
  await generator.generate();
  print('Dart client SDK generated');
}

// Generate client SDKs for other platforms
Future<void> generateClientSdks(OpenApiDocument openApiDoc) async {
  final generators = [
    DartClientGenerator(
      openApiDoc: openApiDoc,
      packageName: 'electoral_system_client',
      outputDirectory: 'clients/dart',
    ),
    TypeScriptClientGenerator(
      openApiDoc: openApiDoc,
      packageName: 'electoral-system-client',
      outputDirectory: 'clients/typescript',
    ),
    SwiftClientGenerator(
      openApiDoc: openApiDoc,
      packageName: 'ElectoralSystemClient',
      outputDirectory: 'clients/swift',
    ),
    // More generators for other platforms...
  ];
  
  for (final generator in generators) {
    await generator.generate();
  }
}
```

These client SDKs make it easy to consume your API from various platforms while maintaining type safety and proper error handling.

## API Versioning and Evolution

As your domain model evolves, your API will need to evolve with it. EDNet OpenAPI provides tools for managing this evolution:

```dart
// Generate a versioned OpenAPI specification
Future<OpenApiDocument> generateVersionedOpenApi(
  Domain domain,
  String version,
) async {
  final generator = EDNetOpenApiGenerator(
    title: 'Electoral System API',
    description: 'API for accessing the electoral system domain model',
    version: version,
  );
  
  // Generate based on the specified version
  switch (version) {
    case '1.0.0':
      return generator.generateFromDomain(domain, excludeModels: ['VoteAnalytics']);
    case '2.0.0':
      return generator.generateFromDomain(domain);
    default:
      throw ArgumentError('Unknown version: $version');
  }
}

// Serve multiple API versions
Future<void> startMultiVersionApiServer(
  Map<String, OpenApiDocument> versionedDocs,
  Repository repository,
) async {
  final server = EDNetMultiVersionServer();
  
  // Add each version
  for (final entry in versionedDocs.entries) {
    final version = entry.key;
    final openApiDoc = entry.value;
    
    server.addVersion(
      version: version,
      basePath: '/v${version.split('.')[0]}',
      openApiDoc: openApiDoc,
      repository: repository,
    );
  }
  
  await server.start(port: 8080);
  print('Multi-version API server listening on port 8080');
}
```

This allows you to evolve your API while maintaining backward compatibility for existing clients.

## Real-World Example: Electoral System API

Let's see how EDNet OpenAPI can be applied to our electoral system domain model:

```dart
void main() async {
  // Initialize the domain model
  final domain = Domain('ElectoralSystem');
  final model = Model(domain, 'Elections');
  
  // Initialize the repositories
  final session = DomainSession(domain);
  final partyRepo = PartyRepository(session);
  final voterRepo = VoterRepository(session);
  final electionRepo = ElectionRepository(session);
  
  // Generate OpenAPI specification
  final openApiDoc = await generateOpenApiFromDomain(domain);
  
  // Start the API server
  await startApiServer(openApiDoc, domain, {
    'parties': partyRepo,
    'voters': voterRepo,
    'elections': electionRepo,
  });
  
  // Start the documentation server
  startDocumentationServer(openApiDoc);
  
  // Generate client SDKs
  await generateClientSdks(openApiDoc);
}
```

With this implementation, we have:

1. An API server that exposes our electoral system domain model
2. Interactive documentation for exploring the API
3. Client SDKs for multiple platforms
4. All while preserving the domain logic and business rules

## Integration with Other EDNet Components

EDNet OpenAPI integrates seamlessly with other components of the EDNet ecosystem:

1. **EDNet Core**: Domain models defined with EDNet Core provide the foundation for the API
2. **EDNet Drift**: Persistent domain models can be exposed through the API
3. **EDNet One Interpreter**: DSLs can generate both domain models and API specifications
4. **EDNet Types**: Custom types are properly translated to OpenAPI schema definitions
5. **EDNet P2P**: APIs can serve as synchronization points for distributed domain models

## Advanced Features

### Custom API Operations

Beyond the standard CRUD operations, EDNet OpenAPI allows defining custom domain operations:

```dart
// Define a custom operation in the OpenAPI specification
Path createElectionResultPath() {
  return Path(
    summary: 'Calculate election results',
    operations: {
      'post': Operation(
        operationId: 'calculateElectionResults',
        summary: 'Calculate results for an election',
        requestBody: RequestBody(
          content: {
            'application/json': MediaType(
              schema: Schema.object(
                properties: {
                  'electionId': Schema.string(),
                  'method': Schema.string(
                    description: 'Seat allocation method',
                    enum: ['dHondt', 'sainteLague', 'largestRemainder'],
                  ),
                },
                required: ['electionId'],
              ),
            ),
          },
        ),
        responses: {
          '200': Response(
            description: 'Election results',
            content: {
              'application/json': MediaType(
                schema: Schema.ref('#/components/schemas/ElectionResult'),
              ),
            },
          ),
        },
      ),
    },
  );
}

// Implement the custom operation handler
Future<Response> calculateElectionResultsHandler(
  Request request,
  Map<String, dynamic> params,
  Repository repository,
) async {
  final json = await request.readAsJson();
  final electionId = json['electionId'];
  final method = json['method'] ?? 'dHondt';
  
  // Load the election
  final election = await repository.getElection(electionId);
  if (election == null) {
    return Response(404, body: 'Election not found');
  }
  
  // Calculate the results
  final calculator = SeatAllocationCalculatorFactory.create(method);
  final results = calculator.calculateResults(election);
  
  // Return the results
  return Response.ok(
    jsonEncode(results.toJsonMap()),
    headers: {'Content-Type': 'application/json'},
  );
}
```

### API Security

EDNet OpenAPI supports various security schemes:

```dart
// Add security schemes to the OpenAPI specification
OpenApiDocument addSecurityToOpenApi(OpenApiDocument openApiDoc) {
  // Define security schemes
  openApiDoc.components.securitySchemes = {
    'apiKey': SecurityScheme(
      type: SecuritySchemeType.apiKey,
      name: 'X-API-Key',
      in: SecuritySchemeLocation.header,
    ),
    'oauth2': SecurityScheme(
      type: SecuritySchemeType.oauth2,
      flows: OAuthFlows(
        authorizationCode: OAuthFlow(
          authorizationUrl: 'https://auth.example.com/authorize',
          tokenUrl: 'https://auth.example.com/token',
          scopes: {
            'read': 'Read access to API',
            'write': 'Write access to API',
          },
        ),
      ),
    ),
  };
  
  // Apply security to all operations
  openApiDoc.security = [
    {'apiKey': []},
    {'oauth2': ['read', 'write']},
  ];
  
  return openApiDoc;
}

// Implement security middleware for the API server
Middleware createSecurityMiddleware(Repository userRepository) {
  return (Handler innerHandler) {
    return (Request request) async {
      // Check for API key
      final apiKey = request.headers['X-API-Key'];
      if (apiKey != null) {
        final user = await userRepository.getUserByApiKey(apiKey);
        if (user != null) {
          // Add user to request context and proceed
          return innerHandler(request.change(context: {
            'user': user,
          }));
        }
      }
      
      // Check for OAuth2 token
      final authHeader = request.headers['Authorization'];
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        final user = await userRepository.getUserByToken(token);
        if (user != null) {
          // Add user to request context and proceed
          return innerHandler(request.change(context: {
            'user': user,
          }));
        }
      }
      
      // No valid authentication found
      return Response(401, body: 'Unauthorized');
    };
  };
}
```

### API Monitoring and Analytics

EDNet OpenAPI also provides tools for monitoring API usage and performance:

```dart
// Create middleware for API monitoring
Middleware createMonitoringMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final startTime = DateTime.now();
      
      // Proceed with the request
      final response = await innerHandler(request);
      
      // Record metrics
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      final metrics = {
        'path': request.url.path,
        'method': request.method,
        'statusCode': response.statusCode,
        'duration': duration.inMilliseconds,
        'timestamp': startTime.toIso8601String(),
      };
      
      // Log or store metrics
      print('API Request: ${jsonEncode(metrics)}');
      await MetricsStorage.save(metrics);
      
      return response;
    };
  };
}
```

## Conclusion

EDNet OpenAPI bridges the gap between rich domain models and API interfaces, enabling an API-first approach to domain modeling that maintains semantic integrity across system boundaries. By generating comprehensive OpenAPI specifications directly from your domain model, it ensures that your API accurately reflects your domain semantics while providing all the benefits of modern API practices: documentation, client generation, testing, and security.

This API-first approach to domain modeling bridges the gap between domain-driven design and service-oriented architecture, allowing your domain model to be accessed and consumed by various clients while maintaining its conceptual integrity.

In the next article, we'll explore how EDNet P2P enables distributed domain models that can synchronize across peers in a decentralized network, creating truly resilient and collaborative systems.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.* 