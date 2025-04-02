import 'package:drift/drift.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:drift/cqrs_drift.dart';

/// Example demonstrating the integration of EDNet Core's unified query system with Drift.
///
/// This example shows how to:
/// 1. Set up the Drift repository with the unified query system
/// 2. Execute different types of queries against the Drift database
/// 3. Use Drift-specific query features
void main() async {
  // Create a domain model with static and dynamic concepts
  final domain = createDomainModel();
  
  // Create a query dispatcher for the unified query system
  final queryDispatcher = QueryDispatcher();
  
  // Create the Drift repository with the query dispatcher
  final repository = EDNetDriftRepository(
    domain: domain,
    sqlitePath: 'example.db',
    queryDispatcher: queryDispatcher,
  );
  
  // Ensure the database is open
  await repository.open();
  
  // --- Execute standard concept queries ---
  
  // Example 1: Find all users with a standard concept query
  final usersResult = await repository.executeConceptQuery(
    'Users',
    'FindAll',
  );
  
  print('All users:');
  if (usersResult.isSuccess) {
    for (final user in usersResult.data as List<User>) {
      print('  - ${user.name} (${user.isAdmin ? 'Admin' : 'User'})');
    }
  } else {
    print('Error: ${usersResult.errorMessage}');
  }
  
  // Example 2: Find users with specific parameters
  final activeUsersResult = await repository.executeConceptQuery(
    'Users',
    'FindByStatus',
    {'status': 'active'},
  );
  
  print('\nActive users:');
  if (activeUsersResult.isSuccess) {
    for (final user in activeUsersResult.data as List<User>) {
      print('  - ${user.name}');
    }
  } else {
    print('Error: ${activeUsersResult.errorMessage}');
  }
  
  // --- Execute Drift-specific queries ---
  
  // Example 3: Use raw SQL with a DriftQuery
  final driftQuery = repository.createDriftQuery(
    'FindRecentUsers',
    'Users',
    rawSql: 'created_at > ? AND status = ?',
    sqlVariables: [
      Variable(DateTime.now().subtract(Duration(days: 30))),
      Variable('active'),
    ],
  );
  
  final recentUsersResult = await repository.executeQuery(driftQuery);
  
  print('\nRecent active users:');
  if (recentUsersResult.isSuccess) {
    for (final user in recentUsersResult.data as List<User>) {
      print('  - ${user.name} (created ${user.createdAt})');
    }
  } else {
    print('Error: ${recentUsersResult.errorMessage}');
  }
  
  // Example 4: Use JOINs with a DriftQuery
  final joinQuery = DriftQuery(
    'FindUsersWithPosts',
    conceptCode: 'Users',
    joins: [
      'LEFT JOIN posts ON users.id = posts.user_id',
    ],
    rawSql: 'posts.id IS NOT NULL',
    parameters: {
      'sortBy': 'users.name',
      'sortDirection': 'asc',
    },
  );
  
  final usersWithPostsResult = await repository.executeQuery(joinQuery);
  
  print('\nUsers with posts:');
  if (usersWithPostsResult.isSuccess) {
    for (final user in usersWithPostsResult.data as List<User>) {
      print('  - ${user.name}');
    }
  } else {
    print('Error: ${usersWithPostsResult.errorMessage}');
  }
  
  // Example 5: Paginated query with dynamic concept
  final postsQuery = ConceptQuery(
    'FindAllPosts',
    domain.findConcept('Post')!,
  )
    .withPagination(page: 1, pageSize: 10)
    .withSorting('createdAt', ascending: false);
  
  final postsResult = await repository.executeQuery(postsQuery);
  
  print('\nLatest posts (page 1):');
  if (postsResult.isSuccess) {
    final posts = postsResult.data as List<DomainEntity>;
    for (final post in posts) {
      print('  - ${post.data['title']} (${post.data['createdAt']})');
    }
    
    if (postsResult.isPaginated) {
      print('  Showing ${posts.length} of ${postsResult.totalCount} posts');
    }
  } else {
    print('Error: ${postsResult.errorMessage}');
  }
  
  // Close any resources
  // (In a real app, you would have proper resource management)
}

/// Creates a sample domain model for the example.
Domain createDomainModel() {
  final domain = Domain('ExampleDomain');
  
  // Create a static concept for Users
  final usersConcept = Concept('Users')
    ..isStatic = true
    ..addAttribute(IntegerAttribute('id')..isPrimaryKey = true)
    ..addAttribute(StringAttribute('name'))
    ..addAttribute(BooleanAttribute('isAdmin'))
    ..addAttribute(DateTimeAttribute('createdAt'));
  
  // Create a dynamic concept for Posts
  final postConcept = Concept('Post')
    ..addAttribute(StringAttribute('id')..isPrimaryKey = true)
    ..addAttribute(StringAttribute('title'))
    ..addAttribute(StringAttribute('content'))
    ..addAttribute(StringAttribute('userId'))
    ..addAttribute(DateTimeAttribute('createdAt'));
  
  // Add concepts to the domain
  domain.addConcept(usersConcept);
  domain.addConcept(postConcept);
  
  return domain;
}

/// Model class for User (static concept).
class User {
  final int id;
  final String name;
  final bool isAdmin;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.name,
    this.isAdmin = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  /// Creates a User from a JSON map.
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      isAdmin: json['is_admin'] as bool? ?? false,
      createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
    );
  }
  
  /// Converts this User to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_admin': isAdmin,
      'created_at': createdAt.toIso8601String(),
    };
  }
} 