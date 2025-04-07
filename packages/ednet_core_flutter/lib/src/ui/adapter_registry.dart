part of ednet_core_flutter;

/// Registry for UX adapters
class AdapterRegistry {
  final Map<Type, UXAdapter> _adapters = {};

  /// Register a UX adapter for a specific entity type
  void register<T extends Entity<T>>(UXAdapter adapter) {
    _adapters[T] = adapter;
  }

  /// Get a UX adapter for a specific entity type
  UXAdapter? getAdapter<T extends Entity<T>>() {
    return _adapters[T];
  }

  /// Check if an adapter exists for a specific entity type
  bool hasAdapter<T extends Entity<T>>() {
    return _adapters.containsKey(T);
  }

  /// Clear all registered adapters
  void clear() {
    _adapters.clear();
  }
}
