/// EDNet OpenAPI repository package.
///
/// This package provides OpenAPI repository implementations for EDNet Core.
library openapi;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:ednet_core/ednet_core.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

// Main components
part 'src/openapi_repository.dart';
part 'src/openapi_repository_factory.dart';
part 'src/openapi_server.dart';

// Schema discovery and modeling
part 'src/schema/openapi_schema_fetcher.dart';
part 'src/schema/domain_model_builder.dart';
part 'src/schema/policy_evaluation_tracer.dart';
part 'src/schema/integration_tester.dart';

// Examples
part 'src/examples/dynamic_domain_model_example.dart';
part 'src/examples/petstore_example.dart';

// Serialization and mapping
part 'src/json_serializer.dart';
part 'src/entity_mapper.dart';

// Authentication
part 'src/auth/auth_middleware.dart';
part 'src/auth/auth_provider.dart';
part 'src/auth/basic_auth_provider.dart';
part 'src/auth/bearer_auth_provider.dart';
part 'src/auth/jwt_auth_provider.dart';
part 'src/auth/api_key_auth_provider.dart';
part 'src/auth/oauth2_auth_provider.dart';
part 'src/auth/no_auth_provider.dart';

// Code generation
part 'src/code_generation/openapi_generator.dart';
part 'src/code_generation/client_generator.dart';
part 'src/code_generation/server_generator.dart';
part 'src/code_generation/model_generator.dart';

// Utilities
part 'src/utils/openapi_spec_builder.dart';
part 'src/utils/path_builder.dart';
part 'src/utils/schema_builder.dart';

/// Creates a new OpenAPI repository factory.
///
/// Parameters:
/// - [domain]: The domain model
/// - [baseUrl]: The base URL for API requests
/// - [authConfig]: Optional authentication configuration
///
/// Returns:
/// A new OpenAPI repository factory
RepositoryFactory createOpenApiRepositoryFactory({
  required Domain domain,
  required String baseUrl,
  AuthConfig? authConfig,
}) {
  return OpenApiRepositoryFactory(
    domain: domain,
    baseUrl: baseUrl,
    authConfig: authConfig,
  );
}

/// Creates a new OpenAPI server.
///
/// Parameters:
/// - [domain]: The domain model
/// - [port]: The port to listen on
/// - [host]: The host to bind to
/// - [repositoryFactory]: Optional repository factory
/// - [authConfig]: Optional authentication configuration
/// - [enableSwaggerUi]: Whether to enable Swagger UI
///
/// Returns:
/// A new OpenAPI server
OpenApiServer createOpenApiServer({
  required Domain domain,
  required int port,
  String host = 'localhost',
  RepositoryFactory? repositoryFactory,
  AuthConfig? authConfig,
  bool enableSwaggerUi = true,
}) {
  return OpenApiServer(
    domain: domain,
    port: port,
    host: host,
    repositoryFactory: repositoryFactory,
    authConfig: authConfig,
    enableSwaggerUi: enableSwaggerUi,
  );
}

/// Generates OpenAPI specification for a domain model.
///
/// Parameters:
/// - [domain]: The domain model
/// - [title]: The title for the API
/// - [version]: The version of the API
/// - [description]: Optional description for the API
/// - [authConfig]: Optional authentication configuration
///
/// Returns:
/// OpenAPI specification as a JSON string
String generateOpenApiSpec({
  required Domain domain,
  required String title,
  required String version,
  String description = '',
  AuthConfig? authConfig,
}) {
  final factory = OpenApiRepositoryFactory(
    domain: domain,
    baseUrl: '',
    authConfig: authConfig,
  );
  
  final spec = factory.generateOpenApiSpec(
    title: title,
    version: version,
    description: description,
  );
  
  return jsonEncode(spec);
}

/// Discovers an OpenAPI schema from a URL.
///
/// This function attempts to find an OpenAPI schema at the given URL
/// by trying common endpoints.
///
/// Parameters:
/// - [url]: The URL to discover the schema from
/// - [headers]: Optional headers to include in the request
///
/// Returns:
/// A Future with the schema as a Map, or null if not found
Future<Map<String, dynamic>?> discoverOpenApiSchema(
  String url, {
  Map<String, String>? headers,
}) {
  final fetcher = OpenApiSchemaFetcher();
  return fetcher.discoverSchema(url, headers: headers);
}

/// Creates a domain model from an OpenAPI schema.
///
/// This function takes an OpenAPI schema and transforms it into an EDNet
/// domain model.
///
/// Parameters:
/// - [schema]: The OpenAPI schema to build from
/// - [domainName]: Optional name for the domain (defaults to schema title)
/// - [includeExtensions]: Whether to include OpenAPI extensions (x-* fields)
///
/// Returns:
/// An EDNet domain model
Domain createDomainModelFromSchema(
  Map<String, dynamic> schema, {
  String? domainName,
  bool includeExtensions = false,
}) {
  final builder = DomainModelBuilder();
  return builder.buildDomainFromSchema(
    schema,
    domainName: domainName,
    includeExtensions: includeExtensions,
  );
}

/// Creates an integration tester for an OpenAPI service.
///
/// This function creates a tester that can validate connectivity
/// and compatibility with an OpenAPI service.
///
/// Parameters:
/// - [domain]: The domain model to test with
/// - [baseUrl]: The base URL of the API
/// - [authConfig]: Optional authentication configuration
/// - [verbose]: Whether to print detailed logs
///
/// Returns:
/// An OpenAPI integration tester
OpenApiIntegrationTester createIntegrationTester({
  required Domain domain,
  required String baseUrl,
  AuthConfig? authConfig,
  bool verbose = false,
}) {
  return OpenApiIntegrationTester(
    domain: domain,
    baseUrl: baseUrl,
    authConfig: authConfig,
    verbose: verbose,
  );
}

/// Runs the dynamic domain model example.
///
/// This function demonstrates fetching an OpenAPI schema,
/// building a domain model, and interacting with the API.
///
/// Parameters:
/// - [apiName]: The name of the API to use
/// - [tracePolicies]: Whether to trace policy evaluations
/// - [printModelDetails]: Whether to print model details
///
/// Returns:
/// A Future that completes when the example is done
Future<void> runDynamicExample({
  String apiName = 'PetStore',
  bool tracePolicies = true,
  bool printModelDetails = true,
}) {
  final example = DynamicDomainModelExample();
  return example.run(
    apiName: apiName,
    tracePolicies: tracePolicies,
    printModelDetails: printModelDetails,
  );
}

/// Runs the PetStore example.
///
/// This function demonstrates integration with the Swagger PetStore API.
///
/// Parameters:
/// - [tracePolicies]: Whether to trace policy evaluations
///
/// Returns:
/// A Future that completes when the example is done
Future<void> runPetStoreExample({bool tracePolicies = true}) {
  final example = PetStoreExample();
  return example.run(tracePolicies: tracePolicies);
}

/// Generates client code from a domain model.
///
/// Parameters:
/// - [domain]: The domain model
/// - [language]: The language to generate code for
/// - [outputDir]: The directory to output code to
/// - [packageName]: The name of the package/library
///
/// Returns:
/// A Future that completes when code generation is done
Future<void> generateClientCode({
  required Domain domain,
  required String language,
  required String outputDir,
  required String packageName,
}) async {
  final generator = ClientGenerator(
    domain: domain,
    language: language,
    outputDir: outputDir,
    packageName: packageName,
  );
  
  await generator.generate();
}

/// Generates server code for a domain model.
///
/// Parameters:
/// - [domain]: The domain model
/// - [language]: The language to generate code for
/// - [outputDir]: The directory to output code to
/// - [packageName]: The name of the package/library
///
/// Returns:
/// A Future that completes when code generation is done
Future<void> generateServerCode({
  required Domain domain,
  required String language,
  required String outputDir,
  required String packageName,
}) async {
  final generator = ServerGenerator(
    domain: domain,
    language: language,
    outputDir: outputDir,
    packageName: packageName,
  );
  
  await generator.generate();
} 