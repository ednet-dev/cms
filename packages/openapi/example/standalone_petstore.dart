import 'dart:convert';
import 'dart:io';

/// Standalone demonstration of connecting to the Swagger PetStore API.
///
/// This example shows:
/// 1. Discovering an OpenAPI schema
/// 2. Making direct API calls without any dependencies
/// 3. Working with pets, store inventory, and orders
void main() async {
  print('EDNet OpenAPI - Standalone PetStore Example');
  print('=========================================');
  print('');
  
  final apiUrl = 'https://petstore.swagger.io/v2';
  
  //==========================================
  // STEP 1: Discover OpenAPI Schema
  //==========================================
  print('STEP 1: Discovering OpenAPI Schema');
  print('----------------------------------');
  
  print('Target API: $apiUrl');
  print('Attempting to discover schema...');
  
  final schemaUrl = await discoverOpenApiSchemaUrl(apiUrl);
  
  if (schemaUrl != null) {
    print('✅ Schema discovered at: $schemaUrl');
    
    // Fetch and parse the schema
    final schema = await fetchJson(schemaUrl);
    
    print('API title: ${schema['info']?['title']}');
    print('API version: ${schema['info']?['version']}');
    
    // Print some schema details
    final paths = schema['paths'] as Map<String, dynamic>? ?? {};
    print('Schema contains:');
    print('- ${paths.length} paths/endpoints');
    
    final definitions = schema['definitions'] as Map<String, dynamic>? ?? {};
    print('- ${definitions.length} model definitions');
    
    // Print a few sample endpoints
    print('\nSample endpoints:');
    int count = 0;
    for (final entry in paths.entries) {
      if (count++ >= 3) break;
      print('- ${entry.key}');
    }
    
    // Print a few sample models
    print('\nSample models:');
    count = 0;
    for (final entry in definitions.entries) {
      if (count++ >= 3) break;
      print('- ${entry.key}');
    }
  } else {
    print('❌ Could not discover schema. Continuing with known endpoints.');
  }
  
  print('');
  
  //==========================================
  // STEP 2: Make Direct API Calls
  //==========================================
  print('STEP 2: Making API Calls');
  print('-----------------------');
  
  // 1. Find available pets
  print('\n2.1: Finding available pets');
  print('-------------------------');
  
  try {
    final pets = await fetchJson('$apiUrl/pet/findByStatus?status=available');
    
    print('✅ Found ${pets.length} available pets');
    
    // Print first few pets
    if (pets.isNotEmpty) {
      print('\nFirst few available pets:');
      for (int i = 0; i < pets.length && i < 3; i++) {
        final pet = pets[i];
        print('Pet ${i+1}:');
        print('  ID: ${pet['id']}');
        print('  Name: ${pet['name']}');
        print('  Status: ${pet['status']}');
        
        // If pet has a category, print it
        if (pet['category'] != null) {
          print('  Category: ${pet['category']['name']}');
        }
      }
    }
  } catch (e) {
    print('❌ Error finding available pets: $e');
  }
  
  // 2. Find a specific pet
  print('\n2.2: Finding a specific pet by ID');
  print('-------------------------------');
  
  try {
    const petId = 1;
    print('Looking for pet with ID: $petId');
    
    final pet = await fetchJson('$apiUrl/pet/$petId');
    
    print('✅ Found pet:');
    print('  ID: ${pet['id']}');
    print('  Name: ${pet['name']}');
    print('  Status: ${pet['status']}');
    
    // Get category
    if (pet['category'] != null) {
      print('  Category:');
      print('    ID: ${pet['category']['id']}');
      print('    Name: ${pet['category']['name']}');
    }
    
    // Get tags
    if (pet['tags'] != null) {
      final tags = pet['tags'] as List<dynamic>;
      print('  Tags: ${tags.length}');
      for (int i = 0; i < tags.length && i < 2; i++) {
        final tag = tags[i];
        print('    - ${tag['name']}');
      }
    }
  } catch (e) {
    print('❌ Error finding pet: $e');
  }
  
  // 3. Get store inventory
  print('\n2.3: Getting store inventory');
  print('-------------------------');
  
  try {
    final inventory = await fetchJson('$apiUrl/store/inventory');
    
    print('✅ Store inventory:');
    inventory.forEach((status, count) {
      print('  $status: $count');
    });
  } catch (e) {
    print('❌ Error getting store inventory: $e');
  }
  
  // 4. Create a new pet
  print('\n2.4: Creating a new pet');
  print('---------------------');
  
  try {
    final newPet = {
      'name': 'Fluffy',
      'status': 'available',
      'photoUrls': ['https://example.com/fluffy.jpg'],
      'category': {
        'id': 1,
        'name': 'Dogs'
      },
      'tags': [
        {
          'id': 1,
          'name': 'cute'
        }
      ]
    };
    
    final createdPet = await postJson('$apiUrl/pet', newPet);
    
    print('✅ Pet created successfully!');
    print('  ID: ${createdPet['id']}');
    print('  Name: ${createdPet['name']}');
  } catch (e) {
    print('❌ Error creating pet: $e');
    print('Note: The pet store may reject new pets if not authenticated');
  }
  
  // 5. Find pets by status
  print('\n2.5: Finding pets by status');
  print('-------------------------');
  
  try {
    final soldPets = await fetchJson('$apiUrl/pet/findByStatus?status=sold');
    
    print('✅ Found ${soldPets.length} sold pets');
    
    // Print first few pets
    if (soldPets.isNotEmpty) {
      print('\nFirst few sold pets:');
      for (int i = 0; i < soldPets.length && i < 3; i++) {
        final pet = soldPets[i];
        print('Pet ${i+1}:');
        print('  ID: ${pet['id']}');
        print('  Name: ${pet['name']}');
      }
    }
  } catch (e) {
    print('❌ Error finding sold pets: $e');
  }
  
  // 6. Place an order
  print('\n2.6: Placing an order');
  print('-------------------');
  
  try {
    final order = {
      'petId': 1,
      'quantity': 1,
      'shipDate': DateTime.now().toIso8601String(),
      'status': 'placed',
      'complete': false
    };
    
    final placedOrder = await postJson('$apiUrl/store/order', order);
    
    print('✅ Order placed successfully!');
    print('  Order ID: ${placedOrder['id']}');
    print('  Pet ID: ${placedOrder['petId']}');
    print('  Status: ${placedOrder['status']}');
  } catch (e) {
    print('❌ Error placing order: $e');
  }
  
  print('');
  print('Example completed successfully!');
  print('This demonstrates how to:');
  print('1. Discover an OpenAPI schema from a service');
  print('2. Make direct API calls to work with Pets and Store inventory');
  print('3. Create and read data from a RESTful service');
}

/// Attempts to discover an OpenAPI schema URL from a base URL.
///
/// Parameters:
/// - [baseUrl]: The base URL to discover from
///
/// Returns:
/// A Future that resolves to the schema URL, or null if not found
Future<String?> discoverOpenApiSchemaUrl(String baseUrl) async {
  // Common paths where OpenAPI schemas are published
  final commonPaths = [
    '/openapi.json',
    '/swagger.json',
    '/api-docs',
    '/v3/api-docs',
    '/v2/api-docs',
    '/openapi',
    '/swagger',
  ];
  
  // Ensure the base URL doesn't end with a slash
  final cleanBaseUrl = baseUrl.endsWith('/') 
      ? baseUrl.substring(0, baseUrl.length - 1) 
      : baseUrl;
  
  final client = HttpClient();
  
  // Try each common path
  for (final path in commonPaths) {
    final url = '$cleanBaseUrl$path';
    
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.headers.add('Accept', 'application/json');
      
      final response = await request.close();
      
      if (response.statusCode == 200) {
        await response.drain();
        return url;
      }
      
      await response.drain();
    } catch (e) {
      // Continue to next path
    }
  }
  
  // No schema found
  return null;
}

/// Fetches JSON from a URL.
///
/// Parameters:
/// - [url]: The URL to fetch from
///
/// Returns:
/// A Future that resolves to the parsed JSON
Future<dynamic> fetchJson(String url) async {
  final client = HttpClient();
  
  try {
    final request = await client.getUrl(Uri.parse(url));
    request.headers.add('Accept', 'application/json');
    
    final response = await request.close();
    
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    
    final body = await response.transform(utf8.decoder).join();
    return json.decode(body);
  } finally {
    client.close();
  }
}

/// Posts JSON to a URL.
///
/// Parameters:
/// - [url]: The URL to post to
/// - [data]: The data to post
///
/// Returns:
/// A Future that resolves to the parsed JSON response
Future<dynamic> postJson(String url, Map<String, dynamic> data) async {
  final client = HttpClient();
  
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers.add('Content-Type', 'application/json');
    request.headers.add('Accept', 'application/json');
    
    request.write(json.encode(data));
    
    final response = await request.close();
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}');
    }
    
    final body = await response.transform(utf8.decoder).join();
    return json.decode(body);
  } finally {
    client.close();
  }
} 