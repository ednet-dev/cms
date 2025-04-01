import 'package:ednet_core/ednet_core.dart';

/// Examples of using the enhanced query capabilities in EDNet Core.
///
/// This file contains examples of using the new expression-based query system,
/// the query builder, and other query enhancements.
class QueryExamples {
  /// Example of using basic attribute expressions.
  ///
  /// This method demonstrates how to create simple attribute-based
  /// query expressions and use them to filter entities.
  static void attributeExpressions(Repository<Entity<dynamic>> repository, Concept concept) async {
    // Create an expression to find entities with price less than 100
    final priceExpression = AttributeExpression('price', ComparisonOperator.lessThan, 100);
    
    // Create a query using the expression
    final query = ExpressionQuery(
      'FindAffordableProducts',
      concept,
      priceExpression,
    );
    
    // Create a handler for the query
    final handler = ExpressionQueryHandler(repository, concept);
    
    // Execute the query
    final result = await handler.handle(query);
    
    // Process the results
    if (result.isSuccess) {
      print('Found ${result.data.length} affordable products:');
      for (final entity in result.data) {
        print('${entity.getAttribute('name')} - \$${entity.getAttribute('price')}');
      }
    } else {
      print('Query failed: ${result.errorMessage}');
    }
  }
  
  /// Example of using logical expressions to combine filters.
  ///
  /// This method demonstrates how to create and combine logical expressions
  /// for more complex filtering.
  static void logicalExpressions(Repository<Entity<dynamic>> repository, Concept concept) async {
    // Create expressions for filtering
    final priceExpression = AttributeExpression('price', ComparisonOperator.lessThan, 100);
    final categoryExpression = AttributeExpression('category', ComparisonOperator.equals, 'electronics');
    
    // Combine expressions with AND
    final combinedExpression = priceExpression.and(categoryExpression);
    
    // Create a query using the combined expression
    final query = ExpressionQuery(
      'FindAffordableElectronics',
      concept,
      combinedExpression,
    );
    
    // Create a handler for the query
    final handler = ExpressionQueryHandler(repository, concept);
    
    // Execute the query
    final result = await handler.handle(query);
    
    // Process the results
    if (result.isSuccess) {
      print('Found ${result.data.length} affordable electronics:');
      for (final entity in result.data) {
        print('${entity.getAttribute('name')} - \$${entity.getAttribute('price')}');
      }
    } else {
      print('Query failed: ${result.errorMessage}');
    }
  }
  
  /// Example of using relationship expressions.
  ///
  /// This method demonstrates how to create expressions that filter
  /// based on relationships with other entities.
  static void relationshipExpressions(Repository<Entity<dynamic>> repository, Concept concept) async {
    // Create an expression for the related entity (e.g., user with name containing 'John')
    final userNameExpression = AttributeExpression('name', ComparisonOperator.contains, 'John');
    
    // Create a relationship expression to find tasks assigned to John
    final assignedToJohnExpression = RelationshipExpression(
      'assignedUser',
      RelationshipType.parent,
      userNameExpression,
    );
    
    // Create a query using the relationship expression
    final query = ExpressionQuery(
      'FindTasksAssignedToJohn',
      concept,
      assignedToJohnExpression,
    );
    
    // Create a handler for the query
    final handler = ExpressionQueryHandler(repository, concept);
    
    // Execute the query
    final result = await handler.handle(query);
    
    // Process the results
    if (result.isSuccess) {
      print('Found ${result.data.length} tasks assigned to John:');
      for (final entity in result.data) {
        print('${entity.getAttribute('title')} - ${entity.getAttribute('status')}');
      }
    } else {
      print('Query failed: ${result.errorMessage}');
    }
  }
  
  /// Example of using function expressions.
  ///
  /// This method demonstrates how to use function expressions
  /// for advanced filtering.
  static void functionExpressions(Repository<Entity<dynamic>> repository, Concept concept) async {
    // Create a function expression to find tasks created this month
    final createdThisMonthExpression = FunctionExpression(
      'currentMonth',
      'createdDate',
      {},
    );
    
    // Create a query using the function expression
    final query = ExpressionQuery(
      'FindTasksCreatedThisMonth',
      concept,
      createdThisMonthExpression,
    );
    
    // Create a handler for the query
    final handler = ExpressionQueryHandler(repository, concept);
    
    // Execute the query
    final result = await handler.handle(query);
    
    // Process the results
    if (result.isSuccess) {
      print('Found ${result.data.length} tasks created this month:');
      for (final entity in result.data) {
        print('${entity.getAttribute('title')} - ${entity.getAttribute('createdDate')}');
      }
    } else {
      print('Query failed: ${result.errorMessage}');
    }
  }
  
  /// Example of using the query builder for fluent query construction.
  ///
  /// This method demonstrates how to use the query builder to
  /// construct complex queries in a fluent, readable way.
  static void queryBuilder(Repository<Entity<dynamic>> repository, Concept concept) async {
    // Build a complex query using the fluent API
    final query = QueryBuilder.forConcept(concept, 'FindRecentHighPriorityTasks')
      .where('status').equals('open')
      .and('priority').greaterThanOrEqual(3)
      .andWhere('assignedUser', RelationshipType.parent)
        .where('department').equals('Engineering')
      .orderBy('createdDate', ascending: false)
      .paginate(1, 10)
      .build();
    
    // Create a handler for the query
    final handler = ExpressionQueryHandler(repository, concept);
    
    // Execute the query
    final result = await handler.handle(query);
    
    // Process the results
    if (result.isSuccess) {
      print('Found ${result.data.length} recent high-priority tasks:');
      for (final entity in result.data) {
        print('${entity.getAttribute('title')} - Priority: ${entity.getAttribute('priority')}');
      }
      
      // Access pagination metadata
      final metadata = result.metadata;
      if (metadata != null) {
        print('Page ${metadata['page']} of ${(metadata['totalCount'] as int) / (metadata['pageSize'] as int)}');
      }
    } else {
      print('Query failed: ${result.errorMessage}');
    }
  }
  
  /// Example of using a dispatcher with expression queries.
  ///
  /// This method demonstrates how to register and use expression query
  /// handlers with a query dispatcher.
  static void queryDispatcher(Repository<Entity<dynamic>> repository, Concept concept) async {
    // Create a query dispatcher
    final dispatcher = QueryDispatcher();
    
    // Register a handler for expression queries
    final handler = ExpressionQueryHandler(repository, concept);
    dispatcher.registerHandler<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(handler);
    
    // Build a query using the builder
    final query = QueryBuilder.forConcept(concept, 'FindRecentTasks')
      .where('createdDate').greaterThan(DateTime.now().subtract(Duration(days: 7)))
      .orderBy('createdDate', ascending: false)
      .build();
    
    // Dispatch the query
    final result = await dispatcher.dispatch<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(query);
    
    // Process the results
    if (result.isSuccess) {
      print('Found ${result.data.length} recent tasks:');
      for (final entity in result.data) {
        print('${entity.getAttribute('title')} - ${entity.getAttribute('createdDate')}');
      }
    } else {
      print('Query failed: ${result.errorMessage}');
    }
  }
}

/// Real-world example of using the query system in a product catalog application.
///
/// This class demonstrates how the enhanced query capabilities can be used
/// in a realistic product catalog scenario.
class ProductCatalogExample {
  /// The query dispatcher for the application.
  final QueryDispatcher _dispatcher = QueryDispatcher();
  
  /// Repository for product entities.
  final Repository<Entity<dynamic>> _productRepository;
  
  /// The product concept.
  final Concept _productConcept;
  
  /// Creates a new product catalog example.
  ///
  /// [productRepository] is the repository for product entities.
  /// [productConcept] is the concept for products.
  ProductCatalogExample(this._productRepository, this._productConcept) {
    // Register handlers with the dispatcher
    _dispatcher.registerHandler<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(
      ExpressionQueryHandler(_productRepository, _productConcept)
    );
  }
  
  /// Searches for products based on various criteria.
  ///
  /// This method demonstrates a realistic product search feature
  /// using the enhanced query system.
  ///
  /// [searchTerm] is an optional text search term.
  /// [category] is an optional category filter.
  /// [minPrice] is an optional minimum price filter.
  /// [maxPrice] is an optional maximum price filter.
  /// [inStock] is an optional in-stock filter.
  /// [page] is the page number (1-based).
  /// [pageSize] is the number of items per page.
  ///
  /// Returns a Future with the search results.
  Future<EntityQueryResult<Entity<dynamic>>> searchProducts({
    String? searchTerm,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    int page = 1,
    int pageSize = 20,
  }) async {
    // Start building the query
    final queryBuilder = QueryBuilder.forConcept(_productConcept, 'SearchProducts');
    
    // Add filters based on the provided criteria
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder.where('name').contains(searchTerm)
        .or('description').contains(searchTerm);
    }
    
    if (category != null && category.isNotEmpty) {
      queryBuilder.andWhere('category', RelationshipType.parent)
        .where('name').equals(category);
    }
    
    if (minPrice != null) {
      queryBuilder.and('price').greaterThanOrEqual(minPrice);
    }
    
    if (maxPrice != null) {
      queryBuilder.and('price').lessThanOrEqual(maxPrice);
    }
    
    if (inStock != null) {
      queryBuilder.and('stockQuantity').greaterThan(0);
    }
    
    // Add sorting and pagination
    queryBuilder.orderBy('name')
      .paginate(page, pageSize);
    
    // Build the final query
    final query = queryBuilder.build();
    
    // Dispatch the query
    return await _dispatcher.dispatch<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(query);
  }
  
  /// Finds featured products for the home page.
  ///
  /// This method demonstrates how to use the query system to
  /// find featured products for a home page.
  ///
  /// Returns a Future with the featured products.
  Future<EntityQueryResult<Entity<dynamic>>> getFeaturedProducts() async {
    // Build a query to find featured products
    final query = QueryBuilder.forConcept(_productConcept, 'FeaturedProducts')
      .where('featured').equals(true)
      .and('stockQuantity').greaterThan(0)
      .orderBy('price', ascending: false)
      .paginate(1, 6)
      .build();
    
    // Dispatch the query
    return await _dispatcher.dispatch<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(query);
  }
  
  /// Finds products that are similar to a given product.
  ///
  /// This method demonstrates a more complex query that finds
  /// products similar to a given product based on category and price range.
  ///
  /// [productId] is the ID of the product to find similar products for.
  ///
  /// Returns a Future with similar products.
  Future<EntityQueryResult<Entity<dynamic>>> getSimilarProducts(String productId) async {
    // First, get the product
    final productQuery = QueryBuilder.forConcept(_productConcept, 'GetProduct')
      .where('id').equals(productId)
      .build();
    
    final productResult = await _dispatcher.dispatch<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(productQuery);
    
    if (!productResult.isSuccess || productResult.data.isEmpty) {
      return EntityQueryResult.failure('Product not found', concept: _productConcept);
    }
    
    final product = productResult.data.first;
    final category = product.getParent('category');
    final price = product.getAttribute<double>('price');
    
    // Calculate a price range for similar products (e.g., +/- 20%)
    final minPrice = price * 0.8;
    final maxPrice = price * 1.2;
    
    // Build a query to find similar products
    final queryBuilder = QueryBuilder.forConcept(_productConcept, 'SimilarProducts')
      .where('id').notEquals(productId); // Exclude the current product
    
    // Add category filter if available
    if (category != null) {
      queryBuilder.andWhere('category', RelationshipType.parent)
        .where('id').equals((category as Entity).getAttribute('id'));
    }
    
    // Add price range filter
    queryBuilder.and('price').between(minPrice, maxPrice)
      .orderBy('price')
      .paginate(1, 4);
    
    // Build and dispatch the query
    final query = queryBuilder.build();
    return await _dispatcher.dispatch<ExpressionQuery, EntityQueryResult<Entity<dynamic>>>(query);
  }
} 