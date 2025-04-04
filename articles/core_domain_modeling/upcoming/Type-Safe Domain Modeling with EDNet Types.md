# Type-Safe Domain Modeling with EDNet Types

## Introduction

Domain modeling requires precision, and one of the most common sources of bugs and runtime errors is type mismatches. EDNet Core provides basic type safety through Dart's static type system, but complex domains often require more specialized typing capabilities. The EDNet Types package extends EDNet Core with an advanced type system that enables domain-specific types, custom validations, and sophisticated type transformations.

## Beyond Primitive Types

Standard data types like strings, numbers, and booleans are often insufficient for expressing domain-specific concepts. Consider these real-world examples:

- An email address is technically a string, but has specific formatting requirements
- A percentage is a number, but should be constrained between 0 and 100
- A tax identification number has country-specific validation rules
- A geographic coordinate pair should validate longitude and latitude ranges

EDNet Types addresses these challenges by providing:

1. **Semantic Types**: Types that carry domain meaning beyond their technical representation
2. **Validation Rules**: Constraints that ensure values conform to domain rules
3. **Type Transformations**: Safe conversion between compatible types
4. **Type Hierarchies**: Support for type inheritance and polymorphism

## Core Type System Architecture

EDNet Types is built around a flexible type system architecture:

```dart
abstract class EDNetType<T> {
  /// Unique type identifier
  String get typeId;
  
  /// Human-readable type name
  String get name;
  
  /// Type description for documentation
  String get description;
  
  /// The base Dart type this wraps
  Type get dartType;
  
  /// Validates if a value conforms to this type's constraints
  ValidationResult validate(dynamic value);
  
  /// Converts a value to this type if possible
  T? tryConvert(dynamic value);
  
  /// Safely cast a value that should already be of this type
  T cast(dynamic value);
  
  /// Creates a JSON schema representation of this type
  Map<String, dynamic> toJsonSchema();
}
```

This foundation enables the creation of domain-specific type systems that are both strict and expressive.

## Built-in Domain-Specific Types

EDNet Types provides an extensive library of pre-built domain types:

### Personal Information Types

```dart
// Email address with validation
final emailType = EDNetEmailType();
final validEmail = emailType.tryConvert("user@example.com"); // Valid
final invalidResult = emailType.validate("not-an-email"); // ValidationError

// Phone number with international format support
final phoneType = EDNetPhoneType(defaultCountryCode: "US");
final validPhone = phoneType.tryConvert("+1 555-123-4567"); // Valid
phoneType.validate("555-123"); // ValidationError: incomplete number

// Personal identification
final ssnType = EDNetNationalIdType.us();
final validSsn = ssnType.tryConvert("123-45-6789"); // Valid
```

### Financial Types

```dart
// Currency with amount and code
final currencyType = EDNetCurrencyType(defaultCurrency: "USD");
final amount = currencyType.tryConvert("$99.99"); // $99.99 USD

// Percentage with range validation
final percentageType = EDNetPercentageType(allowExceedingRange: false);
final valid = percentageType.tryConvert(75); // 75%
percentageType.validate(150); // ValidationError: exceeds 100%

// Tax identification
final vatType = EDNetVatIdType.eu();
final validVat = vatType.tryConvert("DE123456789"); // Valid German VAT ID
```

### Geographic Types

```dart
// Geographic coordinates
final coordType = EDNetGeoCoordinateType();
final location = coordType.tryConvert({
  "latitude": 37.7749, 
  "longitude": -122.4194
}); // San Francisco coordinates

// Country codes with validation
final countryType = EDNetCountryType();
final country = countryType.tryConvert("US"); // United States
```

### Temporal Types

```dart
// Date range with validation
final dateRangeType = EDNetDateRangeType();
final range = dateRangeType.tryConvert({
  "start": "2023-01-01", 
  "end": "2023-12-31"
});

// Business quarter
final quarterType = EDNetQuarterType();
final q1 = quarterType.tryConvert("2023Q1"); // First quarter of 2023
```

## Creating Custom Domain Types

EDNet Types makes it easy to create custom domain types:

```dart
// Electoral candidate identifier type
class CandidateIdType extends EDNetType<String> {
  @override
  String get typeId => "electoral.candidateId";
  
  @override
  String get name => "Candidate Identifier";
  
  @override
  String get description => 
      "Uniquely identifies an electoral candidate in format CC-YY-NNNN";
  
  @override
  Type get dartType => String;
  
  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return ValidationResult.error("Value must be a string");
    }
    
    final pattern = RegExp(r'^[A-Z]{2}-\d{2}-\d{4}$');
    if (!pattern.hasMatch(value)) {
      return ValidationResult.error(
        "Candidate ID must be in format CC-YY-NNNN (country code, year, number)"
      );
    }
    
    return ValidationResult.success();
  }
  
  @override
  String? tryConvert(dynamic value) {
    if (value is String) {
      final result = validate(value);
      if (result.isValid) return value;
    }
    return null;
  }
  
  @override
  String cast(dynamic value) {
    final converted = tryConvert(value);
    if (converted == null) {
      throw TypeCastException(
        "Cannot cast $value to CandidateIdType"
      );
    }
    return converted;
  }
  
  @override
  Map<String, dynamic> toJsonSchema() {
    return {
      "type": "string",
      "pattern": "^[A-Z]{2}-\\d{2}-\\d{4}$",
      "description": description
    };
  }
}
```

## Type Composition and Inheritance

Complex domain types can be composed from simpler ones:

```dart
// Electoral ballot type composed of multiple other types
class ElectoralBallotType extends EDNetCompositeType {
  @override
  String get typeId => "electoral.ballot";
  
  @override
  String get name => "Electoral Ballot";
  
  @override
  String get description => "A complete electoral ballot with voter and votes";
  
  @override
  Map<String, EDNetType> get fieldTypes => {
    "ballotId": EDNetUuidType(),
    "voterId": EDNetNationalIdType(),
    "electoralUnit": ElectoralUnitType(),
    "timestamp": EDNetTimestampType(),
    "votes": EDNetListType(CandidateIdType()),
    "spoiled": EDNetBooleanType(),
  };
  
  @override
  List<String> get requiredFields => [
    "ballotId", "voterId", "electoralUnit", "timestamp"
  ];
}
```

## Integration with EDNet Core

EDNet Types integrates seamlessly with EDNet Core's entity system:

```dart
// Enhanced attribute with rich type information
class TypedAttribute extends Attribute {
  final EDNetType type;
  
  TypedAttribute(String name, Concept concept, this.type) 
      : super(name, concept);
  
  @override
  bool validateValue(dynamic value) {
    return type.validate(value).isValid;
  }
  
  @override
  String get validationMessage {
    return "Value must be a valid ${type.name}";
  }
}

// Entity with typed attributes
class ElectionEntity extends Entity<ElectionEntity> {
  // Initialize with typed attributes
  void initializeTypes() {
    // Register type validators
    registerAttributeType(
      "electionDate", 
      EDNetDateType(format: "yyyy-MM-dd")
    );
    
    registerAttributeType(
      "candidates", 
      EDNetListType(CandidateIdType())
    );
    
    registerAttributeType(
      "voterTurnout", 
      EDNetPercentageType()
    );
  }
}
```

## Type-Safe Domain Modeling Patterns

With EDNet Types, several powerful domain modeling patterns become possible:

### 1. Value Objects

Value objects are immutable, equality-comparable domain objects that encode both data and validation rules:

```dart
class ElectoralAddress extends ValueObject<ElectoralAddress> {
  final String street;
  final String city;
  final String postalCode;
  final String countryCode;
  
  ElectoralAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.countryCode,
  });
  
  @override
  ValidationResult validate() {
    final validator = CompositeValidator([
      PropertyValidator("street", street, EDNetNonEmptyStringType()),
      PropertyValidator("city", city, EDNetNonEmptyStringType()),
      PropertyValidator("postalCode", postalCode, EDNetPostalCodeType()),
      PropertyValidator("countryCode", countryCode, EDNetCountryCodeType()),
    ]);
    
    return validator.validate();
  }
  
  @override
  bool equals(ElectoralAddress other) {
    return street == other.street &&
           city == other.city &&
           postalCode == other.postalCode &&
           countryCode == other.countryCode;
  }
  
  // Factory method with validation
  static Result<ElectoralAddress> create({
    required String street,
    required String city,
    required String postalCode,
    required String countryCode,
  }) {
    final address = ElectoralAddress(
      street: street,
      city: city,
      postalCode: postalCode,
      countryCode: countryCode,
    );
    
    final validation = address.validate();
    if (!validation.isValid) {
      return Result.failure(validation.errorMessage);
    }
    
    return Result.success(address);
  }
}
```

### 2. Type-Safe Commands

Commands become more robust with type validation:

```dart
class RegisterVoterCommand extends TypedCommand {
  @override
  String get name => "RegisterVoter";
  
  @override
  Map<String, EDNetType> get parameterTypes => {
    "fullName": EDNetPersonNameType(),
    "dateOfBirth": EDNetDateType(),
    "nationalId": EDNetNationalIdType(),
    "address": ElectoralAddressType(),
    "electoralDistrict": ElectoralDistrictType(),
  };
  
  @override
  bool doIt() {
    // Command execution with type safety
    final fullName = getTypedParameter<String>("fullName");
    final dateOfBirth = getTypedParameter<DateTime>("dateOfBirth");
    final nationalId = getTypedParameter<String>("nationalId");
    final address = getTypedParameter<ElectoralAddress>("address");
    final district = getTypedParameter<ElectoralDistrict>("electoralDistrict");
    
    // Implementation...
    return true;
  }
}
```

### 3. Schema Generation

EDNet Types can automatically generate schemas for documentation and validation:

```dart
// Generate OpenAPI schema for an entity
class ElectionApiSchema {
  static Map<String, dynamic> generateSchema(Concept concept) {
    final schema = {
      "type": "object",
      "properties": <String, dynamic>{},
      "required": <String>[],
    };
    
    for (final attribute in concept.attributes.whereType<TypedAttribute>()) {
      schema["properties"][attribute.code] = attribute.type.toJsonSchema();
      
      if (attribute.required) {
        schema["required"].add(attribute.code);
      }
    }
    
    return schema;
  }
}
```

## Future Directions

EDNet Types continues to evolve with several exciting developments on the horizon:

1. **Graphical Type Designer**: A visual IDE for creating and managing domain-specific types
2. **AI-Assisted Type Inference**: Using machine learning to suggest appropriate types based on data samples
3. **Cross-Language Type Generation**: Generating type definitions for multiple programming languages from a single source
4. **Runtime Type Evolution**: Supporting safe migrations when types need to change over time

## Conclusion

Type safety is a fundamental aspect of robust domain modeling. EDNet Types elevates type safety beyond simple primitive types, enabling domain experts to express complex constraints and validations as part of the type system itself. By integrating seamlessly with EDNet Core, it provides a solid foundation for building domain models that are not just functionally correct but semantically meaningful.

In our next article, we'll explore how these type-safe domain models can be exposed as API endpoints using EDNet OpenAPI, creating a complete solution for building, documenting, and integrating domain models.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*
```

Now I'll write the article on "API-First Domain Models with EDNet OpenAPI":

# API-First Domain Models with EDNet OpenAPI

```markdown
# API-First Domain Models with EDNet OpenAPI

## Introduction

Modern software systems rarely exist in isolation. They need to communicate with other systems, exposing their domain models as APIs that can be consumed by web applications, mobile clients, and integration partners. EDNet OpenAPI bridges the gap between rich domain models and API interfaces, enabling an API-first approach to domain modeling that maintains semantic integrity across system boundaries.

## The API-First Paradigm

Traditional approaches often treat API design as an afterthought, leading to inconsistencies between internal domain models and their external representations. The API-first paradigm reverses this relationship:

1. **Start with the interface**: Define how your domain will be exposed to the outside world
2. **Document thoroughly**: Create comprehensive API specifications that serve as contracts
3. **Generate code**: Derive implementation code from the API specification
4. **Maintain consistency**: Ensure changes to the domain model are reflected in the API

EDNet OpenAPI embraces this paradigm while adding a unique twist: rather than starting from scratch, it can derive API specifications directly from existing EDNet domain models, ensuring perfect alignment between your domain and its API representation.

## OpenAPI Specification Integration

The [OpenAPI Specification](https://www.openapis.org/) (formerly Swagger) is the industry standard for describing RESTful APIs. EDNet OpenAPI provides bidirectional integration with OpenAPI:

### Domain to API: Exposing EDNet Models

```dart
// Generate OpenAPI specification from a domain model
final apiGenerator = EDNetOpenApiGenerator();
final openApiSpec = apiGenerator.generateFromDomain(
  domain: myDomain,
  info: OpenApiInfo(
    title: 'Electoral System API',
    version: '1.0.0',
    description: 'API for managing electoral processes',
  ),
  servers: [
    OpenApiServer(url: 'https://api.electoral-system.org/v1'),
  ],
);

// Export to JSON or YAML
final jsonSpec = openApiSpec.toJson();
File('openapi.json').writeAsStringSync(jsonEncode(jsonSpec));
```

### API to Domain: Importing External APIs

```dart
// Import an existing OpenAPI specification
final apiImporter = EDNetOpenApiImporter();
final domain = apiImporter.importFromOpenApi(
  openApiSource: File('external-electoral-api.yaml').readAsStringSync(),
  domainName: 'ExternalElectoralSystem',
  options: ImportOptions(
    includeExamples: true,
    generateEntities: true,
    generateRepositories: true,
  ),
);

// Use the imported domain model
final externalVoterRepo = domain.getRepository<ExternalVoter>();
final externalVoters = await externalVoterRepo.findAll();
```

## Automatic Route Generation

EDNet OpenAPI can automatically generate API routes from your domain model:

```dart
// Define API controller from aggregate root
@ApiController('/elections')
class ElectionController {
  final ElectionRepository _repository;
  
  ElectionController(this._repository);
  
  @ApiGet('/')
  Future<List<Election>> getAllElections() async {
    return await _repository.findAll();
  }
  
  @ApiGet('/{id}')
  Future<Election> getElection(@PathParam('id') String id) async {
    final election = await _repository.findById(id);
    if (election == null) {
      throw NotFoundException('Election not found');
    }
    return election;
  }
  
  @ApiPost('/')
  Future<Election> createElection(@Body() CreateElectionDto dto) async {
    final election = Election.fromDto(dto);
    await _repository.save(election);
    return election;
  }
  
  @ApiPut('/{id}')
  Future<Election> updateElection(
    @PathParam('id') String id,
    @Body() UpdateElectionDto dto,
  ) async {
    final election = await _repository.findById(id);
    if (election == null) {
      throw NotFoundException('Election not found');
    }
    
    election.update(dto);
    await _repository.save(election);
    return election;
  }
  
  @ApiDelete('/{id}')
  Future<void> deleteElection(@PathParam('id') String id) async {
    final election = await _repository.findById(id);
    if (election == null) {
      throw NotFoundException('Election not found');
    }
    
    await _repository.delete(election);
  }
}
```

## DTOs and Domain Mapping

Data Transfer Objects (DTOs) serve as the bridge between your domain model and API endpoints:

```dart
// DTO for creating a new election
class CreateElectionDto {
  final String name;
  final String description;
  final DateTime electionDate;
  final List<String> candidateIds;
  final Map<String, dynamic> electionRules;
  
  CreateElectionDto({
    required this.name,
    required this.description,
    required this.electionDate,
    required this.candidateIds,
    required this.electionRules,
  });
  
  // JSON serialization
  factory CreateElectionDto.fromJson(Map<String, dynamic> json) {
    return CreateElectionDto(
      name: json['name'],
      description: json['description'],
      electionDate: DateTime.parse(json['electionDate']),
      candidateIds: List<String>.from(json['candidateIds']),
      electionRules: json['electionRules'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'electionDate': electionDate.toIso8601String(),
      'candidateIds': candidateIds,
      'electionRules': electionRules,
    };
  }
}

// Domain model extension to work with DTOs
extension ElectionDtoMapping on Election {
  static Election fromDto(CreateElectionDto dto) {
    final election = Election();
    election.setAttribute('name', dto.name);
    election.setAttribute('description', dto.description);
    election.setAttribute('electionDate', dto.electionDate);
    election.setAttribute('electionRules', dto.electionRules);
    
    // Handle relationship with candidates
    for (final candidateId in dto.candidateIds) {
      final candidate = candidateRepository.findById(candidateId);
      if (candidate != null) {
        election.addCandidate(candidate);
      }
    }
    
    return election;
  }
  
  void update(UpdateElectionDto dto) {
    if (dto.name != null) setAttribute('name', dto.name!);
    if (dto.description != null) setAttribute('description', dto.description!);
    if (dto.electionDate != null) setAttribute('electionDate', dto.electionDate!);
    if (dto.electionRules != null) setAttribute('electionRules', dto.electionRules!);
    
    // Update candidate relationships if provided
    if (dto.candidateIds != null) {
      // Clear existing candidates
      final candidates = getChild('candidates') as Entities<Candidate>;
      candidates.clear();
      
      // Add new candidates
      for (final candidateId in dto.candidateIds!) {
        final candidate = candidateRepository.findById(candidateId);
        if (candidate != null) {
          addCandidate(candidate);
        }
      }
    }
  }
}
```

## Interactive API Documentation

EDNet OpenAPI generates interactive API documentation that helps developers understand and test your API:

```dart
// Generate and serve interactive API documentation
final apiDocs = EDNetOpenApiDocs(
  openApiSpec: openApiSpec,
  title: 'Electoral System API Documentation',
  options: DocsOptions(
    theme: DocsTheme.material,
    enableTryItOut: true,
    includeExamples: true,
    syntaxHighlight: true,
  ),
);

// Serve documentation on a web server
final server = await apiDocs.serve(port: 8080);
print('API documentation available at http://localhost:8080');
```

## API Versioning and Evolution

Domain models evolve over time, and APIs need to evolve with them. EDNet OpenAPI supports versioning strategies to manage this evolution:

```dart
// Version-specific controller methods
@ApiController('/elections')
class ElectionController {
  // V1 API endpoint
  @ApiGet('/', version: '1')
  Future<List<ElectionResponseV1>> getAllElectionsV1() async {
    final elections = await _repository.findAll();
    return elections.map((e) => ElectionResponseV1.fromEntity(e)).toList();
  }
  
  // V2 API endpoint with enhanced response format
  @ApiGet('/', version: '2')
  Future<PaginatedResponse<ElectionResponseV2>> getAllElectionsV2(
    @QueryParam('page') int page = 1,
    @QueryParam('pageSize') int pageSize = 20,
  ) async {
    final totalCount = await _repository.count();
    final elections = await _repository.findPaginated(page, pageSize);
    
    return PaginatedResponse(
      items: elections.map((e) => ElectionResponseV2.fromEntity(e)).toList(),
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: (totalCount / pageSize).ceil(),
    );
  }
}
```

## Client SDK Generation

EDNet OpenAPI can generate client SDKs in multiple languages, making it easy for consumers to integrate with your API:

```dart
// Generate client SDKs from OpenAPI specification
final sdkGenerator = EDNetOpenApiSdkGenerator(openApiSpec);

// Generate Dart client
final dartClient = sdkGenerator.generateDartClient(
  packageName: 'electoral_client',
  options: DartClientOptions(
    nullSafety: true,
    generateTests: true,
  ),
);
await dartClient.writeToDirectory('clients/dart');

// Generate TypeScript client
final tsClient = sdkGenerator.generateTypeScriptClient(
  packageName: 'electoral-client',
  options: TypeScriptClientOptions(
    framework: TsFramework.angular,
    includeModels: true,
  ),
);
await tsClient.writeToDirectory('clients/typescript');
```

## GraphQL Integration

While REST APIs remain prevalent, GraphQL has emerged as a powerful alternative for flexible data querying. EDNet OpenAPI supports GraphQL integration:

```dart
// Generate GraphQL schema from domain model
final graphQLGenerator = EDNetGraphQLGenerator();
final graphQLSchema = graphQLGenerator.generateFromDomain(
  domain: myDomain,
  options: GraphQLOptions(
    includeQueries: true,
    includeMutations: true,
    includeSubscriptions: true,
  ),
);

// Generate GraphQL resolvers from domain repositories
final resolvers = graphQLGenerator.generateResolvers(
  domain: myDomain,
  repositories: {
    'Election': electionRepository,
    'Candidate': candidateRepository,
    'Voter': voterRepository,
  },
);

// Serve GraphQL API
final server = await graphQLGenerator.serveApi(
  schema: graphQLSchema,
  resolvers: resolvers,
  port: 4000,
);
```

## API Security

Security is paramount for domain APIs. EDNet OpenAPI provides comprehensive security features:

```dart
// Define API security requirements
final apiSecurity = OpenApiSecuritySchemes(
  schemes: {
    'bearerAuth': OpenApiSecurityScheme(
      type: 'http',
      scheme: 'bearer',
      bearerFormat: 'JWT',
    ),
    'apiKey': OpenApiSecurityScheme(
      type: 'apiKey',
      in: 'header',
      name: 'X-API-Key',
    ),
  },
);

// Apply security to controllers
@ApiController('/elections')
@ApiSecurity(['bearerAuth'])
class ElectionController {
  // Implementation...
}

// Role-based access control
@ApiGet('/{id}/results')
@ApiSecurity(['bearerAuth'])
@Roles(['election_admin', 'observer'])
Future<ElectionResults> getElectionResults(@PathParam('id') String id) async {
  // Implementation...
}
```

## Testing API Endpoints

EDNet OpenAPI facilitates comprehensive API testing:

```dart
// Test API endpoints with EDNet OpenAPI test utilities
void main() {
  group('Election API', () {
    late ApiTestClient client;
    late ElectionRepository repository;
    
    setUp(() {
      repository = MockElectionRepository();
      final controller = ElectionController(repository);
      client = ApiTestClient(controller);
    });
    
    test('GET /elections returns all elections', () async {
      // Arrange
      final elections = [
        Election()..setAttribute('name', 'Presidential Election 2024'),
        Election()..setAttribute('name', 'Parliamentary Election 2024'),
      ];
      when(repository.findAll()).thenAnswer((_) async => elections);
      
      // Act
      final response = await client.get('/elections');
      
      // Assert
      expect(response.statusCode, equals(200));
      expect(response.body, isList);
      expect(response.body.length, equals(2));
      expect(response.body[0]['name'], equals('Presidential Election 2024'));
    });
    
    test('GET /elections/invalid-id returns 404', () async {
      // Arrange
      when(repository.findById('invalid-id')).thenAnswer((_) async => null);
      
      // Act
      final response = await client.get('/elections/invalid-id');
      
      // Assert
      expect(response.statusCode, equals(404));
      expect(response.body['error'], contains('not found'));
    });
    
    // Additional tests...
  });
}
```

## Real-time API Capabilities

Modern applications often require real-time updates. EDNet OpenAPI supports this through WebSockets and Server-Sent Events:

```dart
// Real-time election results controller
@ApiController('/elections')
class ElectionRealTimeController {
  final ElectionService _service;
  
  ElectionRealTimeController(this._service);
  
  @ApiWebSocket('/{id}/live-results')
  Stream<ElectionResultUpdate> getLiveResults(@PathParam('id') String id) {
    return _service.getLiveResultsStream(id);
  }
  
  @ApiServerSentEvents('/{id}/results-feed')
  Stream<ElectionResultUpdate> getResultsFeed(@PathParam('id') String id) {
    return _service.getLiveResultsStream(id);
  }
}
```

## Practical Application: Electoral API Platform

Let's consider a practical application of EDNet OpenAPI in building an electoral system API platform:

```dart
// Electoral system API definition
@ApiDefinition(
  info: OpenApiInfo(
    title: 'Universal Electoral System API',
    version: '1.0.0',
    description: 'API for managing electoral processes across multiple jurisdictions',
  ),
)
class ElectoralSystemApi {
  // System controllers
  final ElectionController electionController;
  final CandidateController candidateController;
  final VoterController voterController;
  final BallotController ballotController;
  final ResultController resultController;
  
  // Jurisdiction-specific controllers
  final Map<String, JurisdictionController> jurisdictionControllers;
  
  ElectoralSystemApi({
    required this.electionController,
    required this.candidateController,
    required this.voterController,
    required this.ballotController,
    required this.resultController,
    required this.jurisdictionControllers,
  });
  
  // Initialize the API with repositories
  factory ElectoralSystemApi.fromRepositories(
    ElectionRepository electionRepo,
    CandidateRepository candidateRepo,
    VoterRepository voterRepo,
    BallotRepository ballotRepo,
    ResultRepository resultRepo,
    Map<String, JurisdictionRepository> jurisdictionRepos,
  ) {
    return ElectoralSystemApi(
      electionController: ElectionController(electionRepo),
      candidateController: CandidateController(candidateRepo),
      voterController: VoterController(voterRepo),
      ballotController: BallotController(ballotRepo),
      resultController: ResultController(resultRepo),
      jurisdictionControllers: jurisdictionRepos.map(
        (code, repo) => MapEntry(code, JurisdictionController(code, repo)),
      ),
    );
  }
  
  // Initialize the API server
  Future<ApiServer> serve({int port = 8000}) async {
    final server = ApiServer();
    
    // Register controllers
    server.registerController(electionController);
    server.registerController(candidateController);
    server.registerController(voterController);
    server.registerController(ballotController);
    server.registerController(resultController);
    
    // Register jurisdiction-specific controllers
    for (final controller in jurisdictionControllers.values) {
      server.registerController(controller);
    }
    
    // Start the server
    await server.listen(port: port);
    print('Electoral System API running at http://localhost:$port');
    
    return server;
  }
}
```

This API design allows for:

1. **Cross-Jurisdiction Support**: The API can handle multiple electoral systems
2. **Flexible Integration**: Clients can interact with the API via REST, GraphQL, or real-time connections
3. **Consistent Documentation**: All endpoints are thoroughly documented using OpenAPI
4. **Secure Access**: Authentication and authorization are built in

## Future Directions

EDNet OpenAPI continues to evolve with several exciting developments on the horizon:

1. **AI-Enhanced API Design**: Using machine learning to suggest optimal API designs based on domain models
2. **API Analytics**: Gathering insights on API usage to improve design and performance
3. **Automated Compliance Checking**: Verifying that APIs meet regulatory requirements
4. **Multi-Protocol Support**: Expanding beyond HTTP to support gRPC, MQTT, and other protocols

## Conclusion

EDNet OpenAPI bridges the gap between rich domain models and API interfaces, enabling an API-first approach to domain modeling that maintains semantic integrity across system boundaries. By generating comprehensive OpenAPI specifications directly from your domain model, it ensures that your API accurately reflects your domain semantics while providing all the benefits of modern API practices: documentation, client generation, testing, and security.

In our next article, we'll explore how EDNet P2P enables distributed domain models that can synchronize across peers in a decentralized network, creating truly resilient and collaborative systems.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.*
```

Now let me write the article on "Distributed Domain Models with EDNet P2P":

# Distributed Domain Models with EDNet P2P

```markdown
# Distributed Domain Models with EDNet P2P

## Introduction

Modern applications increasingly require distributed architectures where data and processing are spread across multiple nodes. Traditional client-server models can create single points of failure and limit collaboration. EDNet P2P extends EDNet Core with peer-to-peer networking capabilities, enabling truly decentralized domain models that can operate across networks of equal peers, share data, and maintain consistency without central coordination.

## Beyond Client-Server

The client-server paradigm has dominated application architecture for decades, but it has significant limitations:

1. **Central Point of Failure**: If the server goes down, all clients are affected
2. **Scalability Challenges**: Servers must be scaled to handle peak loads
3. **Connectivity Requirements**: Clients typically need constant server access
4. **Trust Requirements**: All participants must trust the central authority
5. **Ownership Constraints**: Data and processing are controlled by the server owner

In many domains – especially those involving collaboration, local autonomy, or resilience requirements – a peer-to-peer approach offers significant advantages:

1. **No Single Point of Failure**: The network can function even if some nodes fail
2. **Natural Scalability**: Each peer adds resources to the network
3. **Offline Capability**: Peers can work offline and synchronize later
4. **Distributed Trust**: No central authority is required
5. **Shared Ownership**: Data and processing can be distributed among participants

## EDNet P2P Architecture

EDNet P2P implements a distributed domain model architecture with several key components:

```dart
// The core P2P node that represents a peer in the network
class EDNetP2PNode {
  final String nodeId;
  final DomainModelRegistry modelRegistry;
  final PeerDiscovery peerDiscovery;
  final ConnectionManager connectionManager;
  final SynchronizationEngine syncEngine;
  final EventBus eventBus;
  
  EDNetP2PNode({
    required this.nodeId,
    required this.modelRegistry,
    required this.peerDiscovery,
    required this.connectionManager,
    required this.syncEngine,
    required this.eventBus,
  });
  
  // Start the P2P node
  Future<void> start() async {
    // Start peer discovery
    await peerDiscovery.start();
    
    // Start connection manager
    await connectionManager.start();
    
    // Start synchronization engine
    await syncEngine.start();
    
    // Register event handlers
    _registerEventHandlers();
  }
  
  // Register a domain model for P2P synchronization
  void registerDomainModel(String modelId, SynchronizableDomainModel model) {
    modelRegistry.register(modelId, model);
    syncEngine.registerModel(modelId, model);
  }
  
  // Connect to a known peer
  Future<bool> connectToPeer(PeerAddress address) async {
    return await connectionManager.connectToPeer(address);
  }
  
  // Synchronize a specific model with connected peers
  Future<SyncResult> synchronizeModel(String modelId) async {
    return await syncEngine.synchronize(modelId);
  }
  
  // Internal event handling setup
  void _registerEventHandlers() {
    // Handle new peer discovery
    eventBus.on<PeerDiscoveredEvent>().listen((event) {
      connectionManager.connectToPeer(event.peerAddress);
    });
    
    // Handle peer disconnection
    eventBus.on<PeerDisconnectedEvent>().listen((event) {
      // Handle peer disconnection, possibly retry connection
    });
    
    // Handle model change events
    eventBus.on<ModelChangedEvent>().listen((event) {
      // Trigger synchronization for the changed model
      syncEngine.synchronize(event.modelId);
    });
  }
}
```

## Synchronizable Domain Models

To participate in a P2P network, domain models must implement the `SynchronizableDomainModel` interface:

```dart
abstract class SynchronizableDomainModel {
  // Unique identifier for this model instance
  String get modelId;
  
  // Current version of the model (typically a vector clock or version vector)
  VersionVector get version;
  
  // Get all changes since a specific version
  List<ModelChange> getChangesSince(VersionVector sinceVersion);
  
  // Apply changes from another peer
  Future<ApplyChangesResult> applyChanges(List<ModelChange> changes);
  
  // Resolve conflicts between concurrent changes
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflictingChanges);
  
  // Get a snapshot of the entire model
  Future<ModelSnapshot> getSnapshot();
  
  // Initialize from a snapshot
  Future<bool> initializeFromSnapshot(ModelSnapshot snapshot);
}

// Implementation for an electoral system domain model
class ElectoralSystemModel implements SynchronizableDomainModel {
  final String _modelId;
  final ElectionRepository _electionRepo;
  final CandidateRepository _candidateRepo;
  final VoterRepository _voterRepo;
  final ConflictResolver _conflictResolver;
  final VersionVector _version = VersionVector();
  
  ElectoralSystemModel(
    this._modelId,
    this._electionRepo,
    this._candidateRepo,
    this._voterRepo,
    this._conflictResolver,
  );
  
  @override
  String get modelId => _modelId;
  
  @override
  VersionVector get version => _version;
  
  @override
  List<ModelChange> getChangesSince(VersionVector sinceVersion) {
    final changes = <ModelChange>[];
    
    // Get changes from each repository
    changes.addAll(_electionRepo.getChangesSince(sinceVersion));
    changes.addAll(_candidateRepo.getChangesSince(sinceVersion));
    changes.addAll(_voterRepo.getChangesSince(sinceVersion));
    
    return changes;
  }
  
  @override
  Future<ApplyChangesResult> applyChanges(List<ModelChange> changes) async {
    final result = ApplyChangesResult();
    
    // Group changes by entity type
    final electionChanges = changes.where((c) => c.entityType == 'Election').toList();
    final candidateChanges = changes.where((c) => c.entityType == 'Candidate').toList();
    final voterChanges = changes.where((c) => c.entityType == 'Voter').toList();
    
    // Apply changes to each repository
    result.electionResults = await _electionRepo.applyChanges(electionChanges);
    result.candidateResults = await _candidateRepo.applyChanges(candidateChanges);
    result.voterResults = await _voterRepo.applyChanges(voterChanges);
    
    // Update version vector
    for (final change in changes) {
      _version.update(change.sourceNodeId, change.sourceSequence);
    }
    
    return result;
  }
  
  @override
  Future<ConflictResolution> resolveConflicts(List<ModelChange> conflictingChanges) async {
    return await _conflictResolver.resolveConflicts(conflictingChanges);
  }
  
  @override
  Future<ModelSnapshot> getSnapshot() async {
    final snapshot = ModelSnapshot(modelId: _modelId, version: _version);
    
    // Add all entities to the snapshot
    snapshot.elections = await _electionRepo.getAll();
    snapshot.candidates = await _candidateRepo.getAll();
    snapshot.voters = await _voterRepo.getAll();
    
    return snapshot;
  }
  
  @override
  Future<bool> initializeFromSnapshot(ModelSnapshot snapshot) async {
    if (snapshot.modelId != _modelId) {
      return false;
    }
    
    // Clear existing data
    await _electionRepo.clear();
    await _candidateRepo.clear();
    await _voterRepo.clear();
    
    // Load from snapshot
    await _electionRepo.addAll(snapshot.elections);
    await _candidateRepo.addAll(snapshot.candidates);
    await _voterRepo.addAll(snapshot.voters);
    
    // Update version
    _version.mergeWith(snapshot.version);
    
    return true;
  }
}
```

## CRDT-Based Entity Synchronization

Conflict-Free Replicated Data Types (CRDTs) are a fundamental building block for distributed domain models, allowing for automatic conflict resolution:

```dart
// CRDT-based entity class
class CRDTEntity<T extends Entity<T>> extends Entity<T> {
  // Last-Write-Wins register for each attribute
  final Map<String, LWWRegister<dynamic>> _attributeRegisters = {};
  
  // Add-Wins Set for child collections
  final Map<String, AWSet<Entity>> _childSets = {};
  
  // Version vector for the entity
  final VersionVector _version = VersionVector();
  
  @override
  dynamic getAttribute<K>(String attributeCode) {
    final register = _attributeRegisters[attributeCode];
    return register?.value as K?;
  }
  
  @override
  bool setAttribute(String name, dynamic value) {
    // Get the current time and node ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nodeId = P2PContext.current.nodeId;
    
    // Create or update the LWW register
    _attributeRegisters[name] ??= LWWRegister<dynamic>();
    _attributeRegisters[name]!.update(value, timestamp, nodeId);
    
    // Update version vector
    _version.increment(nodeId);
    
    // Notify about the change
    P2PContext.current.eventBus.fire(
      EntityAttributeChangedEvent(
        entityId: oid.toString(),
        attributeName: name,
        newValue: value,
        timestamp: timestamp,
        nodeId: nodeId,
      ),
    );
    
    return true;
  }
  
  @override
  Object? getChild(String name) {
    final childSet = _childSets[name];
    if (childSet == null) return null;
    
    // Convert the AWSet to an Entities collection
    final entities = Entities<Entity>();
    for (final entity in childSet.items) {
      entities.add(entity);
    }
    
    return entities;
  }
  
  @override
  bool setChild(String name, Object entities) {
    if (entities is! Entities) return false;
    
    // Create or get the AWSet for this child relationship
    _childSets[name] ??= AWSet<Entity>();
    final childSet = _childSets[name]!;
    
    // Update the set with the entities
    for (final entity in entities) {
      childSet.add(entity);
    }
    
    // Update version vector
    _version.increment(P2PContext.current.nodeId);
    
    return true;
  }
  
  // Merge with another version of the same entity
  bool mergeWith(CRDTEntity<T> other) {
    if (oid != other.oid) return false;
    
    // Merge attribute registers
    for (final entry in other._attributeRegisters.entries) {
      _attributeRegisters[entry.key] ??= LWWRegister<dynamic>();
      _attributeRegisters[entry.key]!.mergeWith(entry.value);
    }
    
    // Merge child sets
    for (final entry in other._childSets.entries) {
      _childSets[entry.key] ??= AWSet<Entity>();
      _childSets[entry.key]!.mergeWith(entry.value);
    }
    
    // Merge version vectors
    _version.mergeWith(other._version);
    
    return true;
  }
}
```

## Peer Discovery Mechanisms

For peers to collaborate, they first need to find each other. EDNet P2P supports multiple discovery mechanisms:

```dart
// Base peer discovery interface
abstract class PeerDiscovery {
  Stream<PeerDiscoveredEvent> get peerDiscovered;
  Future<void> start();
  Future<void> stop();
  Future<List<PeerAddress>> discoverPeers();
}

// Local network discovery using mDNS/Bonjour
class LocalNetworkDiscovery implements PeerDiscovery {
  final String serviceType;
  final int servicePort;
  final StreamController<PeerDiscoveredEvent> _peerDiscoveredController = 
      StreamController.broadcast();
  
  LocalNetworkDiscovery({
    this.serviceType = '_ednet-p2p._tcp',
    this.servicePort = 8765,
  });
  
  @override
  Stream<PeerDiscoveredEvent> get peerDiscovered => _peerDiscoveredController.stream;
  
  @override
  Future<void> start() async {
    // Register our service
    await MDnsClient.register(serviceType, servicePort);
    
    // Start discovery
    MDnsClient.discover(serviceType).listen((service) {
      final address = PeerAddress(
        host: service.host,
        port: service.port,
        nodeId: service.attributes['nodeId'],
      );
      
      _peerDiscoveredController.add(PeerDiscoveredEvent(address));
    });
  }
  
  @override
  Future<void> stop() async {
    await MDnsClient.unregister(serviceType);
  }
  
  @override
  Future<List<PeerAddress>> discoverPeers() async {
    final peers = <PeerAddress>[];
    final services = await MDnsClient.discoverOnce(serviceType);
    
    for (final service in services) {
      peers.add(PeerAddress(
        host: service.host,
        port: service.port,
        nodeId: service.attributes['nodeId'],
      ));
    }
    
    return peers;
  }
}

// Server-based peer discovery
class ServerBasedDiscovery implements PeerDiscovery {
  final String serverUrl;
  final HttpClient _client = HttpClient();
  final StreamController<PeerDiscoveredEvent> _peerDiscoveredController = 
      StreamController.broadcast();
  Timer? _refreshTimer;
  
  ServerBasedDiscovery(this.serverUrl);
  
  @override
  Stream<PeerDiscoveredEvent> get peerDiscovered => _peerDiscoveredController.stream;
  
  @override
  Future<void> start() async {
    // Register with the discovery server
    final myAddress = PeerAddress(
      host: await getLocalIpAddress(),
      port: P2PContext.current.port,
      nodeId:
