// part of ednet_core;
//
// /// Factory for creating OpenAPI repositories.
// ///
// /// This factory creates repositories that communicate with
// /// OpenAPI services for entity persistence.
// class OpenApiRepositoryFactory implements RepositoryFactory {
//   /// The domain model this factory works with.
//   final Domain _domain;
//
//   /// The base URL for API requests.
//   final String _baseUrl;
//
//   /// Configuration for authentication.
//   final AuthConfig _authConfig;
//
//   /// Creates a new OpenAPI repository factory.
//   ///
//   /// Parameters:
//   /// - [domain]: The domain model this factory works with
//   /// - [baseUrl]: The base URL for API requests
//   /// - [authConfig]: Optional configuration for authentication
//   OpenApiRepositoryFactory({
//     required Domain domain,
//     required String baseUrl,
//     AuthConfig? authConfig,
//   }) : _domain = domain,
//        _baseUrl = baseUrl,
//        _authConfig = authConfig ?? AuthConfig.none();
//
//   @override
//   Repository<Entity> createRepository(Concept concept) {
//     return OpenApiRepository<Entity>(
//       concept: concept,
//       baseUrl: _baseUrl,
//       fromJson: (json) => _createEntityFromJson(concept, json),
//       toJson: (entity) => _createJsonFromEntity(entity),
//     );
//   }
//
//   @override
//   Repository<T> createGenericRepository<T extends Entity>(Concept concept) {
//     return OpenApiRepository<T>(
//       concept: concept,
//       baseUrl: _baseUrl,
//       fromJson: (json) => _createEntityFromJson(concept, json) as T,
//       toJson: (entity) => _createJsonFromEntity(entity),
//     );
//   }
//
//   @override
//   AggregateRepository<AggregateRoot> createAggregateRepository(
//     Concept concept, {
//     QueryDispatcher? queryDispatcher,
//     IDomainSession? session,
//   }) {
//     // TODO: Implement this method
//     throw UnimplementedError();
//   }
//
//   @override
//   QueryableRepository<Entity> createQueryableRepository(
//     Concept concept, {
//     QueryDispatcher? queryDispatcher,
//   }) {
//     return OpenApiQueryableRepository<Entity>(
//       concept: concept,
//       baseUrl: _baseUrl,
//       fromJson: (json) => _createEntityFromJson(concept, json),
//       toJson: (entity) => _createJsonFromEntity(entity),
//       queryDispatcher: queryDispatcher,
//     );
//   }
//
//   @override
//   MultiTenantRepository<Entity> createMultiTenantRepository(
//     Concept concept, {
//     required String tenantId,
//     String tenantField = 'tenantId',
//   }) {
//     // TODO: Implement this method
//     throw UnimplementedError();
//   }
//
//   @override
//   AuditableRepository<Entity> createAuditableRepository(
//     Concept concept, {
//     required String userId,
//   }) {
//     // TODO: Implement this method
//     throw UnimplementedError();
//   }
//
//   @override
//   Repository<Entity> createEnterpriseRepository(
//     Concept concept, {
//     QueryDispatcher? queryDispatcher,
//     IDomainSession? session,
//     String? tenantId,
//     String? userId,
//   }) {
//     // TODO: Implement this method
//     throw UnimplementedError();
//   }
//
//   @override
//   Domain getDomain() {
//     return _domain;
//   }
//
//   /// Creates an entity from a JSON map.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept for the entity
//   /// - [json]: The JSON map to create from
//   ///
//   /// Returns:
//   /// A new entity
//   Entity _createEntityFromJson(Concept concept, Map<String, dynamic> json) {
//     final data = <String, dynamic>{};
//
//     // Extract values for each attribute
//     for (final attribute in concept.attributes) {
//       final key = attribute.name;
//       if (json.containsKey(key)) {
//         data[key] = json[key];
//       }
//     }
//
//     return DomainEntity(concept, data);
//   }
//
//   /// Creates a JSON map from an entity.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to convert
//   ///
//   /// Returns:
//   /// A JSON map representation of the entity
//   Map<String, dynamic> _createJsonFromEntity(Entity entity) {
//     final result = <String, dynamic>{};
//
//     // Add the ID
//     result['id'] = entity.id;
//
//     // Extract other attributes
//     final concept = _domain.findConcept(entity.runtimeType.toString());
//     if (concept != null) {
//       for (final attribute in concept.attributes) {
//         final key = attribute.name;
//         final value = entity.getAttribute(key);
//         if (value != null) {
//           result[key] = value;
//         }
//       }
//     } else if (entity is DomainEntity) {
//       // For DomainEntity, copy all data
//       result.addAll(entity.data);
//     }
//
//     return result;
//   }
//
//   /// Generates OpenAPI documentation for the domain model.
//   ///
//   /// Parameters:
//   /// - [title]: The title for the API documentation
//   /// - [version]: The version of the API
//   /// - [description]: Optional description for the API
//   ///
//   /// Returns:
//   /// OpenAPI specification as a JSON-serializable map
//   Map<String, dynamic> generateOpenApiSpec({
//     required String title,
//     required String version,
//     String description = '',
//   }) {
//     final paths = <String, dynamic>{};
//     final components = <String, dynamic>{
//       'schemas': <String, dynamic>{},
//     };
//
//     // Generate paths and schemas for each concept
//     for (final concept in _domain.concepts) {
//       final entityName = concept.name;
//       final endpoint = entityName.toLowerCase();
//
//       // Generate schema for this entity
//       components['schemas'][entityName] = _generateSchemaForConcept(concept);
//
//       // Generate paths for this entity
//       paths['/$endpoint'] = {
//         'get': {
//           'summary': 'List all $entityName entities',
//           'description': 'Returns a list of $entityName entities',
//           'parameters': _generateQueryParameters(concept),
//           'responses': {
//             '200': {
//               'description': 'A list of $entityName entities',
//               'content': {
//                 'application/json': {
//                   'schema': {
//                     'type': 'array',
//                     'items': {
//                       '\$ref': '#/components/schemas/$entityName',
//                     },
//                   },
//                 },
//               },
//             },
//           },
//         },
//         'post': {
//           'summary': 'Create a new $entityName entity',
//           'description': 'Creates a new $entityName entity',
//           'requestBody': {
//             'description': '$entityName entity to create',
//             'required': true,
//             'content': {
//               'application/json': {
//                 'schema': {
//                   '\$ref': '#/components/schemas/$entityName',
//                 },
//               },
//             },
//           },
//           'responses': {
//             '201': {
//               'description': 'Created $entityName entity',
//               'content': {
//                 'application/json': {
//                   'schema': {
//                     '\$ref': '#/components/schemas/$entityName',
//                   },
//                 },
//               },
//             },
//           },
//         },
//       };
//
//       paths['/$endpoint/{id}'] = {
//         'get': {
//           'summary': 'Get a $entityName entity by ID',
//           'description': 'Returns a single $entityName entity',
//           'parameters': [
//             {
//               'name': 'id',
//               'in': 'path',
//               'description': 'ID of the $entityName entity to get',
//               'required': true,
//               'schema': {
//                 'type': 'string',
//               },
//             },
//           ],
//           'responses': {
//             '200': {
//               'description': 'A $entityName entity',
//               'content': {
//                 'application/json': {
//                   'schema': {
//                     '\$ref': '#/components/schemas/$entityName',
//                   },
//                 },
//               },
//             },
//             '404': {
//               'description': '$entityName entity not found',
//             },
//           },
//         },
//         'put': {
//           'summary': 'Update a $entityName entity',
//           'description': 'Updates an existing $entityName entity',
//           'parameters': [
//             {
//               'name': 'id',
//               'in': 'path',
//               'description': 'ID of the $entityName entity to update',
//               'required': true,
//               'schema': {
//                 'type': 'string',
//               },
//             },
//           ],
//           'requestBody': {
//             'description': '$entityName entity to update',
//             'required': true,
//             'content': {
//               'application/json': {
//                 'schema': {
//                   '\$ref': '#/components/schemas/$entityName',
//                 },
//               },
//             },
//           },
//           'responses': {
//             '200': {
//               'description': 'Updated $entityName entity',
//               'content': {
//                 'application/json': {
//                   'schema': {
//                     '\$ref': '#/components/schemas/$entityName',
//                   },
//                 },
//               },
//             },
//             '404': {
//               'description': '$entityName entity not found',
//             },
//           },
//         },
//         'delete': {
//           'summary': 'Delete a $entityName entity',
//           'description': 'Deletes an existing $entityName entity',
//           'parameters': [
//             {
//               'name': 'id',
//               'in': 'path',
//               'description': 'ID of the $entityName entity to delete',
//               'required': true,
//               'schema': {
//                 'type': 'string',
//               },
//             },
//           ],
//           'responses': {
//             '204': {
//               'description': 'No content',
//             },
//             '404': {
//               'description': '$entityName entity not found',
//             },
//           },
//         },
//       };
//
//       paths['/$endpoint/count'] = {
//         'get': {
//           'summary': 'Count $entityName entities',
//           'description': 'Returns the count of $entityName entities',
//           'parameters': _generateQueryParameters(concept, excludePagination: true),
//           'responses': {
//             '200': {
//               'description': 'Count of $entityName entities',
//               'content': {
//                 'application/json': {
//                   'schema': {
//                     'type': 'object',
//                     'properties': {
//                       'count': {
//                         'type': 'integer',
//                         'minimum': 0,
//                       },
//                     },
//                   },
//                 },
//               },
//             },
//           },
//         },
//       };
//     }
//
//     // Build the spec
//     final spec = <String, dynamic>{
//       'openapi': '3.0.0',
//       'info': {
//         'title': title,
//         'version': version,
//         'description': description,
//       },
//       'paths': paths,
//       'components': components,
//     };
//
//     // Add security schemes if authentication is configured
//     if (_authConfig.type != AuthType.none) {
//       spec['components']['securitySchemes'] = _generateSecuritySchemes();
//       spec['security'] = _generateSecurityRequirements();
//     }
//
//     return spec;
//   }
//
//   /// Generates schema for a concept.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to generate schema for
//   ///
//   /// Returns:
//   /// OpenAPI schema as a JSON-serializable map
//   Map<String, dynamic> _generateSchemaForConcept(Concept concept) {
//     final properties = <String, dynamic>{
//       'id': {
//         'type': 'string',
//         'description': 'Unique identifier',
//       },
//     };
//
//     // Add properties for each attribute
//     for (final attribute in concept.attributes) {
//       if (attribute.name == 'id') continue; // Skip ID attribute
//
//       var type = 'string';
//       var format = '';
//
//       // Determine type and format based on attribute type
//       if (attribute is StringAttribute) {
//         type = 'string';
//       } else if (attribute is IntegerAttribute) {
//         type = 'integer';
//       } else if (attribute is DoubleAttribute) {
//         type = 'number';
//         format = 'double';
//       } else if (attribute is BooleanAttribute) {
//         type = 'boolean';
//       } else if (attribute is DateTimeAttribute) {
//         type = 'string';
//         format = 'date-time';
//       }
//
//       final property = <String, dynamic>{
//         'type': type,
//         'description': attribute.description ?? attribute.name,
//       };
//
//       if (format.isNotEmpty) {
//         property['format'] = format;
//       }
//
//       properties[attribute.name] = property;
//     }
//
//     // Build the schema
//     final schema = <String, dynamic>{
//       'type': 'object',
//       'properties': properties,
//       'required': ['id'],
//     };
//
//     return schema;
//   }
//
//   /// Generates query parameters for a concept.
//   ///
//   /// Parameters:
//   /// - [concept]: The concept to generate parameters for
//   /// - [excludePagination]: Whether to exclude pagination parameters
//   ///
//   /// Returns:
//   /// A list of parameter objects
//   List<Map<String, dynamic>> _generateQueryParameters(
//     Concept concept, {
//     bool excludePagination = false,
//   }) {
//     final parameters = <Map<String, dynamic>>[];
//
//     // Add filter parameters for each attribute
//     for (final attribute in concept.attributes) {
//       var type = 'string';
//
//       // Determine parameter type based on attribute type
//       if (attribute is StringAttribute) {
//         type = 'string';
//       } else if (attribute is IntegerAttribute) {
//         type = 'integer';
//       } else if (attribute is DoubleAttribute) {
//         type = 'number';
//       } else if (attribute is BooleanAttribute) {
//         type = 'boolean';
//       } else if (attribute is DateTimeAttribute) {
//         type = 'string';
//       }
//
//       parameters.add({
//         'name': attribute.name,
//         'in': 'query',
//         'description': 'Filter by ${attribute.name}',
//         'required': false,
//         'schema': {
//           'type': type,
//         },
//       });
//     }
//
//     // Add sorting parameters
//     parameters.add({
//       'name': 'sortBy',
//       'in': 'query',
//       'description': 'Attribute to sort by',
//       'required': false,
//       'schema': {
//         'type': 'string',
//         'enum': concept.attributes.map((a) => a.name).toList(),
//       },
//     });
//
//     parameters.add({
//       'name': 'sortDirection',
//       'in': 'query',
//       'description': 'Sort direction',
//       'required': false,
//       'schema': {
//         'type': 'string',
//         'enum': ['asc', 'desc'],
//         'default': 'asc',
//       },
//     });
//
//     // Add pagination parameters if not excluded
//     if (!excludePagination) {
//       parameters.add({
//         'name': 'skip',
//         'in': 'query',
//         'description': 'Number of items to skip',
//         'required': false,
//         'schema': {
//           'type': 'integer',
//           'minimum': 0,
//           'default': 0,
//         },
//       });
//
//       parameters.add({
//         'name': 'take',
//         'in': 'query',
//         'description': 'Number of items to take',
//         'required': false,
//         'schema': {
//           'type': 'integer',
//           'minimum': 1,
//           'maximum': 100,
//           'default': 20,
//         },
//       });
//     }
//
//     return parameters;
//   }
//
//   /// Generates security schemes based on auth config.
//   ///
//   /// Returns:
//   /// Security schemes as a JSON-serializable map
//   Map<String, dynamic> _generateSecuritySchemes() {
//     final schemes = <String, dynamic>{};
//
//     switch (_authConfig.type) {
//       case AuthType.apiKey:
//         schemes['ApiKey'] = {
//           'type': 'apiKey',
//           'in': 'header',
//           'name': _authConfig.headerName ?? 'X-API-Key',
//         };
//         break;
//       case AuthType.bearer:
//         schemes['Bearer'] = {
//           'type': 'http',
//           'scheme': 'bearer',
//           'bearerFormat': 'JWT',
//         };
//         break;
//       case AuthType.basic:
//         schemes['Basic'] = {
//           'type': 'http',
//           'scheme': 'basic',
//         };
//         break;
//       case AuthType.oauth2:
//         schemes['OAuth2'] = {
//           'type': 'oauth2',
//           'flows': {
//             'authorizationCode': {
//               'authorizationUrl': _authConfig.authorizationUrl ?? '',
//               'tokenUrl': _authConfig.tokenUrl ?? '',
//               'scopes': _authConfig.scopes ?? {},
//             },
//           },
//         };
//         break;
//       case AuthType.none:
//       default:
//         // No security schemes
//         break;
//     }
//
//     return schemes;
//   }
//
//   /// Generates security requirements based on auth config.
//   ///
//   /// Returns:
//   /// Security requirements as a JSON-serializable list
//   List<Map<String, List<String>>> _generateSecurityRequirements() {
//     switch (_authConfig.type) {
//       case AuthType.apiKey:
//         return [
//           {'ApiKey': []},
//         ];
//       case AuthType.bearer:
//         return [
//           {'Bearer': []},
//         ];
//       case AuthType.basic:
//         return [
//           {'Basic': []},
//         ];
//       case AuthType.oauth2:
//         return [
//           {'OAuth2': _authConfig.scopes?.keys.toList() ?? []},
//         ];
//       case AuthType.none:
//       default:
//         return [];
//     }
//   }
// }
//
// /// Authentication types supported by the OpenAPI repository.
// enum AuthType {
//   /// No authentication.
//   none,
//
//   /// API key authentication.
//   apiKey,
//
//   /// Bearer token authentication.
//   bearer,
//
//   /// Basic authentication.
//   basic,
//
//   /// OAuth 2.0 authentication.
//   oauth2,
// }
//
// /// Configuration for authentication.
// class AuthConfig {
//   /// The type of authentication.
//   final AuthType type;
//
//   /// The header name for API key authentication.
//   final String? headerName;
//
//   /// The authorization URL for OAuth 2.0 authentication.
//   final String? authorizationUrl;
//
//   /// The token URL for OAuth 2.0 authentication.
//   final String? tokenUrl;
//
//   /// The scopes for OAuth 2.0 authentication.
//   final Map<String, String>? scopes;
//
//   /// Creates a new authentication configuration.
//   ///
//   /// Parameters:
//   /// - [type]: The type of authentication
//   /// - [headerName]: The header name for API key authentication
//   /// - [authorizationUrl]: The authorization URL for OAuth 2.0 authentication
//   /// - [tokenUrl]: The token URL for OAuth 2.0 authentication
//   /// - [scopes]: The scopes for OAuth 2.0 authentication
//   AuthConfig({
//     required this.type,
//     this.headerName,
//     this.authorizationUrl,
//     this.tokenUrl,
//     this.scopes,
//   });
//
//   /// Creates a configuration for no authentication.
//   ///
//   /// Returns:
//   /// A configuration for no authentication
//   factory AuthConfig.none() {
//     return AuthConfig(type: AuthType.none);
//   }
//
//   /// Creates a configuration for API key authentication.
//   ///
//   /// Parameters:
//   /// - [headerName]: The header name for the API key (default: 'X-API-Key')
//   ///
//   /// Returns:
//   /// A configuration for API key authentication
//   factory AuthConfig.apiKey({String headerName = 'X-API-Key'}) {
//     return AuthConfig(
//       type: AuthType.apiKey,
//       headerName: headerName,
//     );
//   }
//
//   /// Creates a configuration for bearer token authentication.
//   ///
//   /// Returns:
//   /// A configuration for bearer token authentication
//   factory AuthConfig.bearer() {
//     return AuthConfig(type: AuthType.bearer);
//   }
//
//   /// Creates a configuration for basic authentication.
//   ///
//   /// Returns:
//   /// A configuration for basic authentication
//   factory AuthConfig.basic() {
//     return AuthConfig(type: AuthType.basic);
//   }
//
//   /// Creates a configuration for OAuth 2.0 authentication.
//   ///
//   /// Parameters:
//   /// - [authorizationUrl]: The authorization URL
//   /// - [tokenUrl]: The token URL
//   /// - [scopes]: The available scopes
//   ///
//   /// Returns:
//   /// A configuration for OAuth 2.0 authentication
//   factory AuthConfig.oauth2({
//     required String authorizationUrl,
//     required String tokenUrl,
//     Map<String, String>? scopes,
//   }) {
//     return AuthConfig(
//       type: AuthType.oauth2,
//       authorizationUrl: authorizationUrl,
//       tokenUrl: tokenUrl,
//       scopes: scopes,
//     );
//   }
// }