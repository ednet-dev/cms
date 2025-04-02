part of cqrs_drift;

/// Adapter for converting REST API query parameters to domain model queries.
///
/// This class handles common REST API query patterns, including:
/// - Filtering: ?filter[field]=value
/// - Sorting: ?sort=field or ?sort=-field (descending)
/// - Pagination: ?page=1&limit=10
/// - Field selection: ?fields=field1,field2
/// - Search: ?q=search terms
///
/// Example usage:
/// ```dart
/// final adapter = RestQueryAdapter();
/// final conceptQuery = adapter.fromRequestParameters(
///   concept,
///   {
///     'filter': {'status': 'active'},
///     'sort': 'name',
///     'page': '1',
///     'limit': '10',
///   },
/// );
/// ```
class RestQueryAdapter {
  /// Default query name used for REST API queries
  static const String DEFAULT_QUERY_NAME = 'FindByCriteria';
  
  /// Default page size for pagination
  static const int DEFAULT_PAGE_SIZE = 20;
  
  /// Maximum page size allowed
  static const int MAX_PAGE_SIZE = 100;
  
  /// Creates a ConceptQuery from REST API request parameters.
  ///
  /// This method converts common REST API query parameters to a
  /// domain model ConceptQuery that can be executed by a query handler.
  ///
  /// Parameters:
  /// - [concept]: The concept to query
  /// - [params]: The REST API query parameters
  /// - [queryName]: Optional custom query name (defaults to 'FindByCriteria')
  ///
  /// Returns a ConceptQuery for the specified concept with parameters
  /// derived from the REST API query parameters
  model.ConceptQuery fromRequestParameters(
    model.Concept concept,
    Map<String, dynamic> params, [
    String queryName = DEFAULT_QUERY_NAME,
  ]) {
    // Create a new concept query
    final query = model.ConceptQuery(queryName, concept);
    
    // Handle filtering
    _applyFilters(query, params);
    
    // Handle sorting
    _applySorting(query, params);
    
    // Handle pagination
    _applyPagination(query, params);
    
    // Handle search
    _applySearch(query, params);
    
    return query;
  }
  
  /// Applies filters from REST API parameters to the query.
  ///
  /// This method handles filter parameters in formats like:
  /// - filter[field]=value
  /// - filter: { field: value }
  ///
  /// Parameters:
  /// - [query]: The query to apply filters to
  /// - [params]: The REST API parameters
  void _applyFilters(model.ConceptQuery query, Map<String, dynamic> params) {
    // Process filter parameters
    if (params.containsKey('filter')) {
      final filter = params['filter'];
      
      if (filter is Map) {
        // Handle filter object syntax: { filter: { field: value } }
        for (var entry in filter.entries) {
          final field = entry.key.toString();
          final value = entry.value;
          query.withParameter(field, DriftValueConverter.fromRestParameter(value));
        }
      } else if (filter is String) {
        // Try to parse JSON string: { filter: '{"field":"value"}' }
        try {
          final filterMap = jsonDecode(filter);
          if (filterMap is Map) {
            for (var entry in filterMap.entries) {
              final field = entry.key.toString();
              final value = entry.value;
              query.withParameter(field, DriftValueConverter.fromRestParameter(value));
            }
          }
        } catch (_) {
          // Not a valid JSON string, ignore
        }
      }
    }
    
    // Also check for filter[field]=value syntax
    for (var key in params.keys) {
      if (key.startsWith('filter[') && key.endsWith(']')) {
        final field = key.substring(7, key.length - 1);
        final value = params[key];
        query.withParameter(field, DriftValueConverter.fromRestParameter(value));
      }
    }
  }
  
  /// Applies sorting from REST API parameters to the query.
  ///
  /// This method handles sort parameters in formats like:
  /// - sort=field (ascending)
  /// - sort=-field (descending)
  /// - sort=field1,-field2 (multiple fields)
  ///
  /// Parameters:
  /// - [query]: The query to apply sorting to
  /// - [params]: The REST API parameters
  void _applySorting(model.ConceptQuery query, Map<String, dynamic> params) {
    if (params.containsKey('sort')) {
      final sort = params['sort'].toString();
      
      // Handle multiple sort fields separated by commas
      final sortFields = sort.split(',');
      
      if (sortFields.isNotEmpty) {
        final firstField = sortFields[0];
        
        // Check if it's descending (prefixed with -)
        if (firstField.startsWith('-')) {
          query.withSorting(firstField.substring(1), ascending: false);
        } else {
          query.withSorting(firstField);
        }
      }
    }
  }
  
  /// Applies pagination from REST API parameters to the query.
  ///
  /// This method handles pagination parameters in formats like:
  /// - page=1&limit=10
  /// - page=1&per_page=10
  /// - offset=0&limit=10
  ///
  /// Parameters:
  /// - [query]: The query to apply pagination to
  /// - [params]: The REST API parameters
  void _applyPagination(model.ConceptQuery query, Map<String, dynamic> params) {
    // Default pagination
    int page = 1;
    int pageSize = DEFAULT_PAGE_SIZE;
    
    // Handle page number
    if (params.containsKey('page')) {
      page = int.tryParse(params['page'].toString()) ?? 1;
      page = page < 1 ? 1 : page; // Ensure page is at least 1
    }
    
    // Handle page size (multiple common formats)
    if (params.containsKey('limit')) {
      pageSize = int.tryParse(params['limit'].toString()) ?? DEFAULT_PAGE_SIZE;
    } else if (params.containsKey('per_page')) {
      pageSize = int.tryParse(params['per_page'].toString()) ?? DEFAULT_PAGE_SIZE;
    } else if (params.containsKey('pageSize')) {
      pageSize = int.tryParse(params['pageSize'].toString()) ?? DEFAULT_PAGE_SIZE;
    }
    
    // Enforce maximum page size
    pageSize = pageSize > MAX_PAGE_SIZE ? MAX_PAGE_SIZE : pageSize;
    
    // Handle offset-based pagination as an alternative
    if (params.containsKey('offset')) {
      final offset = int.tryParse(params['offset'].toString()) ?? 0;
      if (offset >= 0) {
        // Convert offset to page
        page = (offset / pageSize).floor() + 1;
      }
    }
    
    // Apply pagination parameters
    query.withPagination(page: page, pageSize: pageSize);
  }
  
  /// Applies search terms from REST API parameters to the query.
  ///
  /// This method handles search parameters in formats like:
  /// - q=search terms
  /// - search=search terms
  ///
  /// Parameters:
  /// - [query]: The query to apply search to
  /// - [params]: The REST API parameters
  void _applySearch(model.ConceptQuery query, Map<String, dynamic> params) {
    String? searchTerm;
    
    // Handle different common search parameter names
    if (params.containsKey('q')) {
      searchTerm = params['q'].toString();
    } else if (params.containsKey('search')) {
      searchTerm = params['search'].toString();
    } else if (params.containsKey('query')) {
      searchTerm = params['query'].toString();
    }
    
    if (searchTerm != null && searchTerm.isNotEmpty) {
      query.withParameter('search', searchTerm);
    }
  }
  
  /// Converts a ConceptQuery to REST API query parameters.
  ///
  /// This method is useful for generating links to related resources
  /// with the same query parameters.
  ///
  /// Parameters:
  /// - [query]: The concept query to convert
  ///
  /// Returns a map of REST API query parameters
  Map<String, dynamic> toRequestParameters(model.ConceptQuery query) {
    final params = <String, dynamic>{};
    final parameters = query.getParameters();
    
    // Extract pagination parameters
    if (parameters.containsKey('page')) {
      params['page'] = parameters['page'];
    }
    
    if (parameters.containsKey('pageSize')) {
      params['limit'] = parameters['pageSize'];
    }
    
    // Extract sorting parameters
    if (parameters.containsKey('sortBy')) {
      final sortDirection = parameters['sortDirection'] as String?;
      if (sortDirection == 'desc') {
        params['sort'] = '-${parameters['sortBy']}';
      } else {
        params['sort'] = parameters['sortBy'];
      }
    }
    
    // Extract search parameter
    if (parameters.containsKey('search')) {
      params['q'] = parameters['search'];
    }
    
    // Extract filter parameters
    final filter = <String, dynamic>{};
    for (var key in parameters.keys) {
      // Skip pagination, sorting, and search parameters
      if (['page', 'pageSize', 'sortBy', 'sortDirection', 'search'].contains(key)) {
        continue;
      }
      
      filter[key] = parameters[key];
    }
    
    if (filter.isNotEmpty) {
      params['filter'] = filter;
    }
    
    return params;
  }
} 