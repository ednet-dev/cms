import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_openapi/openapi.dart';

import 'schema_discovery_test.mocks.dart';

// Generate mocks
@GenerateMocks([HttpClient, HttpClientRequest, HttpClientResponse])
void main() {
  group('OpenApiSchemaFetcher', () {
    late MockHttpClient mockClient;
    late OpenApiSchemaFetcher fetcher;
    
    setUp(() {
      mockClient = MockHttpClient();
      fetcher = OpenApiSchemaFetcher(client: mockClient);
    });
    
    test('fetchSchema returns schema from valid endpoint', () async {
      // Mock request and response
      final mockRequest = MockHttpClientRequest();
      final mockResponse = MockHttpClientResponse();
      
      // Sample OpenAPI schema
      final schema = {
        'openapi': '3.0.0',
        'info': {
          'title': 'Test API',
          'version': '1.0.0',
        },
        'paths': {},
      };
      
      // Setup response stream
      final responseBody = jsonEncode(schema);
      when(mockResponse.transform(any)).thenAnswer((_) {
        return Stream.value(utf8.encode(responseBody));
      });
      when(mockResponse.statusCode).thenReturn(200);
      
      // Setup request
      when(mockRequest.headers).thenReturn(MockHttpHeaders());
      when(mockRequest.close()).thenAnswer((_) async => mockResponse);
      
      // Setup client
      when(mockClient.getUrl(any)).thenAnswer((_) async => mockRequest);
      
      // Execute test
      final result = await fetcher.fetchSchema('https://example.com/openapi.json');
      
      // Verify
      expect(result, isA<Map<String, dynamic>>());
      expect(result['openapi'], '3.0.0');
      expect(result['info']['title'], 'Test API');
    });
    
    test('fetchSchema throws exception for non-200 status', () async {
      // Mock request and response
      final mockRequest = MockHttpClientRequest();
      final mockResponse = MockHttpClientResponse();
      
      // Setup response
      when(mockResponse.statusCode).thenReturn(404);
      
      // Setup request
      when(mockRequest.headers).thenReturn(MockHttpHeaders());
      when(mockRequest.close()).thenAnswer((_) async => mockResponse);
      
      // Setup client
      when(mockClient.getUrl(any)).thenAnswer((_) async => mockRequest);
      
      // Execute test and expect exception
      expect(
        () => fetcher.fetchSchema('https://example.com/openapi.json'),
        throwsA(isA<Exception>()),
      );
    });
    
    test('discoverSchema tries multiple paths', () async {
      // Mock request and response
      final mockRequest = MockHttpClientRequest();
      final mockResponse = MockHttpClientResponse();
      
      // Sample OpenAPI schema
      final schema = {
        'openapi': '3.0.0',
        'info': {
          'title': 'Test API',
          'version': '1.0.0',
        },
        'paths': {},
      };
      
      // Setup response stream
      final responseBody = jsonEncode(schema);
      when(mockResponse.transform(any)).thenAnswer((_) {
        return Stream.value(utf8.encode(responseBody));
      });
      
      // First request fails with 404
      final mockResponse404 = MockHttpClientResponse();
      when(mockResponse404.statusCode).thenReturn(404);
      
      // Second request succeeds with 200
      when(mockResponse.statusCode).thenReturn(200);
      
      // Setup request
      final mockRequest404 = MockHttpClientRequest();
      when(mockRequest404.headers).thenReturn(MockHttpHeaders());
      when(mockRequest404.close()).thenAnswer((_) async => mockResponse404);
      
      when(mockRequest.headers).thenReturn(MockHttpHeaders());
      when(mockRequest.close()).thenAnswer((_) async => mockResponse);
      
      // Setup client to return different responses for different paths
      when(mockClient.getUrl(Uri.parse('https://example.com/openapi.json')))
          .thenAnswer((_) async => mockRequest404);
      when(mockClient.getUrl(Uri.parse('https://example.com/swagger.json')))
          .thenAnswer((_) async => mockRequest);
      
      // Execute test
      final result = await fetcher.discoverSchema('https://example.com');
      
      // Verify
      expect(result, isA<Map<String, dynamic>>());
      expect(result!['openapi'], '3.0.0');
      expect(result['info']['title'], 'Test API');
    });
    
    test('discoverSchema returns null if no schema found', () async {
      // Mock request and response
      final mockRequest = MockHttpClientRequest();
      final mockResponse = MockHttpClientResponse();
      
      // All requests fail with 404
      when(mockResponse.statusCode).thenReturn(404);
      
      // Setup request
      when(mockRequest.headers).thenReturn(MockHttpHeaders());
      when(mockRequest.close()).thenAnswer((_) async => mockResponse);
      
      // Setup client to return 404 for all paths
      when(mockClient.getUrl(any)).thenAnswer((_) async => mockRequest);
      
      // Execute test
      final result = await fetcher.discoverSchema('https://example.com');
      
      // Verify
      expect(result, isNull);
    });
  });
  
  group('DomainModelBuilder', () {
    late DomainModelBuilder builder;
    
    setUp(() {
      builder = DomainModelBuilder();
    });
    
    test('buildDomainFromSchema creates domain model from OpenAPI schema', () {
      // Sample OpenAPI schema
      final schema = {
        'openapi': '3.0.0',
        'info': {
          'title': 'Test API',
          'version': '1.0.0',
        },
        'components': {
          'schemas': {
            'User': {
              'type': 'object',
              'properties': {
                'id': {
                  'type': 'string',
                  'description': 'User ID',
                },
                'name': {
                  'type': 'string',
                  'description': 'User name',
                },
                'email': {
                  'type': 'string',
                  'format': 'email',
                },
                'age': {
                  'type': 'integer',
                },
                'isActive': {
                  'type': 'boolean',
                },
              },
              'required': ['name', 'email'],
            },
            'Post': {
              'type': 'object',
              'properties': {
                'id': {
                  'type': 'string',
                },
                'title': {
                  'type': 'string',
                },
                'content': {
                  'type': 'string',
                },
                'user': {
                  '\$ref': '#/components/schemas/User',
                },
              },
            },
          },
        },
      };
      
      // Execute test
      final domain = builder.buildDomainFromSchema(schema);
      
      // Verify domain
      expect(domain, isA<Domain>());
      expect(domain.name, 'Test API');
      
      // Verify concepts
      expect(domain.concepts.length, 2);
      expect(domain.concepts[0].name, 'User');
      expect(domain.concepts[1].name, 'Post');
      
      // Verify User attributes
      final userConcept = domain.findConcept('User');
      expect(userConcept, isNotNull);
      expect(userConcept!.attributes.length, 5);
      expect(userConcept.getAttribute('id'), isNotNull);
      expect(userConcept.getAttribute('name'), isNotNull);
      expect(userConcept.getAttribute('name')?.required, isTrue);
      
      // Verify Post attributes
      final postConcept = domain.findConcept('Post');
      expect(postConcept, isNotNull);
      expect(postConcept!.attributes.length, 3);
      expect(postConcept.getAttribute('id'), isNotNull);
      expect(postConcept.getAttribute('title'), isNotNull);
      
      // Verify relationships
      expect(postConcept.parents.length, 1);
      expect(postConcept.parents.first.name, 'user');
      expect(postConcept.parents.first.destination.name, 'User');
    });
    
    test('buildDomainFromSchema handles missing components', () {
      // Sample OpenAPI schema without components
      final schema = {
        'openapi': '3.0.0',
        'info': {
          'title': 'Empty API',
          'version': '1.0.0',
        },
        'paths': {},
      };
      
      // Execute test
      final domain = builder.buildDomainFromSchema(schema);
      
      // Verify domain
      expect(domain, isA<Domain>());
      expect(domain.name, 'Empty API');
      expect(domain.concepts.length, 0);
    });
  });
}

// Mock HttpHeaders
class MockHttpHeaders extends Mock implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
} 