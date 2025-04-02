# EDNet OpenAPI

A package that creates OpenAPI-compatible REST APIs from EDNet Core domain models.

## Features

- **Automatic REST API Generation**: Automatically generate REST APIs from EDNet Core domain models
- **OpenAPI/Swagger Compatibility**: Generate OpenAPI specifications for your APIs
- **Swagger UI Integration**: Built-in Swagger UI for API documentation and testing
- **Authentication**: Support for various authentication methods (API Key, Basic, Bearer, JWT, OAuth2)
- **CORS Support**: Built-in CORS support for cross-origin requests
- **Schema Discovery**: Discover OpenAPI schemas from external services
- **Dynamic Domain Modeling**: Create domain models from OpenAPI schemas at runtime
- **Policy Tracing**: Trace policy evaluations in your domain models
- **Integration Testing**: Test your OpenAPI integrations before deployment
- **Code Generation**: Generate client and server code from domain models
- **Repository Implementation**: OpenAPI implementation of EDNet Core repositories

## Getting Started

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  ednet_core: ^1.0.0
  ednet_openapi: ^1.0.0
```

### Basic Usage

```dart
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_openapi/openapi.dart';

void main() async {
  // Create a domain model
  final domain = Domain('MyDomain');
  
  // Add concepts to the domain
  final userConcept = Concept('User')
    ..addAttribute(StringAttribute('id')..isPrimaryKey = true)
    ..addAttribute(StringAttribute('name'))
    ..addAttribute(StringAttribute('email'));
  
  domain.addConcept(userConcept);
  
  // Create and start an OpenAPI server
  final server = createOpenApiServer(
    domain: domain,
    port: 8080,
    host: 'localhost',
    enableSwaggerUi: true,
  );
  
  await server.start();
  
  print('Server started at http://localhost:8080');
  print('Swagger UI available at http://localhost:8080/swagger-ui');
}
```

## Schema Discovery and Dynamic Domain Modeling

The package now supports discovering OpenAPI schemas from external services and creating domain models from them at runtime:

```dart
// Discover an OpenAPI schema
final schema = await discoverOpenApiSchema('https://petstore.swagger.io/v2');

// Create a domain model from the schema
final domain = createDomainModelFromSchema(schema!);

// Create a repository factory
final factory = createOpenApiRepositoryFactory(
  domain: domain,
  baseUrl: 'https://petstore.swagger.io/v2',
);

// Create a repository for a concept
final petConcept = domain.findConcept('Pet');
final petRepository = factory.createRepository(petConcept!);

// Use the repository
final pets = await petRepository.findAll();
```

## Policy Tracing

You can trace policy evaluations in your domain models:

```dart
// Create a policy tracer
final tracer = PolicyEvaluationTracer(printImmediately: true);

// Trace the domain model structure
tracer.traceDomainModel(domain);

// In a real application, attach to a policy evaluator
// final policyEvaluator = PolicyEvaluator(PolicyRegistry());
// policyEvaluator.addListener(tracer.getPolicyEvaluatorListener(domain));
```

## Integration Testing

Test your OpenAPI integrations before deployment:

```dart
// Create an integration tester
final tester = createIntegrationTester(
  domain: domain,
  baseUrl: 'https://petstore.swagger.io/v2',
  verbose: true,
);

// Test all concepts
await tester.testAll();

// Print the test summary
tester.printSummary();
```

## Authentication

The package supports various authentication methods:

### API Key Authentication

```dart
final authConfig = AuthConfig.apiKey(headerName: 'X-API-Key');

final server = createOpenApiServer(
  domain: domain,
  port: 8080,
  authConfig: authConfig,
);
```

### Basic Authentication

```dart
final authConfig = AuthConfig.basic();

final server = createOpenApiServer(
  domain: domain,
  port: 8080,
  authConfig: authConfig,
);
```

### Bearer Authentication

```dart
final authConfig = AuthConfig.bearer();

final server = createOpenApiServer(
  domain: domain,
  port: 8080,
  authConfig: authConfig,
);
```

### OAuth 2.0 Authentication

```dart
final authConfig = AuthConfig.oauth2(
  authorizationUrl: 'https://auth.example.com/authorize',
  tokenUrl: 'https://auth.example.com/token',
  scopes: {
    'read': 'Read access',
    'write': 'Write access',
  },
);

final server = createOpenApiServer(
  domain: domain,
  port: 8080,
  authConfig: authConfig,
);
```

## Examples

The package includes several examples:

### Dynamic Domain Model Example

```dart
// Run the dynamic domain model example
await runDynamicExample();
```

### PetStore Example

```dart
// Run the PetStore example
await runPetStoreExample();
```

### Custom Example

See the `example/openapi_example.dart` file for a complete custom example.

## OpenAPI Repository

You can also use the OpenAPI repository without starting a server:

```dart
final factory = createOpenApiRepositoryFactory(
  domain: domain,
  baseUrl: 'https://api.example.com',
);

final repository = factory.createRepository(userConcept);
```

## Code Generation

Generate client code from a domain model:

```dart
await generateClientCode(
  domain: domain,
  language: 'dart',
  outputDir: 'lib/generated',
  packageName: 'my_api_client',
);
```

Generate server code from a domain model:

```dart
await generateServerCode(
  domain: domain,
  language: 'dart',
  outputDir: 'lib/generated',
  packageName: 'my_api_server',
);
```

## OpenAPI Specification

Generate an OpenAPI specification from a domain model:

```dart
final spec = generateOpenApiSpec(
  domain: domain,
  title: 'My API',
  version: '1.0.0',
  description: 'API for my domain model',
);

// Save to file
final file = File('openapi.json');
await file.writeAsString(spec);
```

## License

This package is licensed under the MIT License. 