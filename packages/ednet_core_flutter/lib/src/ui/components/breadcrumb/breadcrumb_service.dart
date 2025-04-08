part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Service for managing breadcrumb navigation
///
/// This service maintains the breadcrumb state and provides
/// methods for navigation through the breadcrumb path.
class BreadcrumbService {
  /// The current breadcrumb items
  final List<BreadcrumbItem> _items = [];

  /// The current breadcrumb channel for messages
  final UXChannel _channel =
      UXChannel('breadcrumb_channel', name: 'Breadcrumb Channel');

  /// The maximum number of breadcrumbs to maintain in history
  int _maxHistory;

  /// Static singleton instance
  static final BreadcrumbService _instance = BreadcrumbService._internal();

  /// Factory constructor that returns the singleton instance
  factory BreadcrumbService({int maxHistory = 20}) {
    _instance._maxHistory = maxHistory;
    return _instance;
  }

  /// Private constructor for singleton pattern
  BreadcrumbService._internal() : _maxHistory = 20;

  /// Get the current breadcrumb items
  List<BreadcrumbItem> get items => List.unmodifiable(_items);

  /// Get the breadcrumb channel
  UXChannel get channel => _channel;

  /// Add a new breadcrumb to the path
  ///
  /// This will add the breadcrumb to the end of the path and mark it as active.
  /// Previous active breadcrumb will be marked as inactive.
  void add(BreadcrumbItem item) {
    // First make all existing items inactive
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].isActive) {
        _items[i] = _items[i].copyWith(isActive: false);
      }
    }

    // Make the new item active
    final newItem = item.copyWith(isActive: true);
    _items.add(newItem);

    // Trim history if needed
    if (_items.length > _maxHistory) {
      _items.removeAt(0);
    }

    // Notify listeners
    _notifyUpdate();
  }

  /// Navigate to an existing breadcrumb by index
  ///
  /// This will remove all breadcrumbs after the selected index
  /// and mark the selected breadcrumb as active.
  void navigateToIndex(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    // Update active status
    for (int i = 0; i < _items.length; i++) {
      if (i == index) {
        _items[i] = _items[i].copyWith(isActive: true);
      } else if (_items[i].isActive) {
        _items[i] = _items[i].copyWith(isActive: false);
      }
    }

    // Remove all items after this index
    if (index < _items.length - 1) {
      _items.removeRange(index + 1, _items.length);
    }

    // Notify listeners
    _notifyUpdate();
  }

  /// Navigate to an existing breadcrumb by destination
  ///
  /// This will find the breadcrumb with the matching destination,
  /// remove all breadcrumbs after it, and mark it as active.
  void navigateToDestination(String destination) {
    final index = _items.indexWhere((item) => item.destination == destination);
    if (index >= 0) {
      navigateToIndex(index);
    }
  }

  /// Navigate to an existing breadcrumb
  ///
  /// This will find the breadcrumb in the list, remove all
  /// breadcrumbs after it, and mark it as active.
  void navigateTo(BreadcrumbItem item) {
    navigateToDestination(item.destination);
  }

  /// Replace the breadcrumb at the specified index
  void replaceAt(int index, BreadcrumbItem item) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final isActive = _items[index].isActive;
    _items[index] = item.copyWith(isActive: isActive);

    // Notify listeners
    _notifyUpdate();
  }

  /// Clear all breadcrumbs
  void clear() {
    _items.clear();
    _notifyUpdate();
  }

  /// Reset to just a home breadcrumb
  void resetToHome(BreadcrumbItem home) {
    _items.clear();
    _items.add(home.copyWith(isActive: true));
    _notifyUpdate();
  }

  /// Get the active breadcrumb
  BreadcrumbItem? get activeBreadcrumb {
    for (final item in _items) {
      if (item.isActive) {
        return item;
      }
    }
    return _items.isNotEmpty ? _items.last : null;
  }

  /// Listen for breadcrumb updates
  void addListener(void Function(List<BreadcrumbItem>) listener) {
    _channel.onUXMessageType('breadcrumb_update', (message) {
      final items = message.payload['items'] as List<dynamic>;
      final breadcrumbItems = items
          .map((item) => BreadcrumbItem(
                label: item['label'] as String,
                destination: item['destination'] as String,
                icon: item['icon'] != null
                    ? IconData(item['icon'] as int, fontFamily: 'MaterialIcons')
                    : null,
                isActive: item['isActive'] as bool,
                metadata: item['metadata'] as Map<String, dynamic>?,
              ))
          .toList();
      listener(breadcrumbItems);
    });
  }

  /// Notify listeners of updates
  void _notifyUpdate() {
    final itemMaps = _items
        .map((item) => {
              'label': item.label,
              'destination': item.destination,
              'icon': item.icon?.codePoint,
              'isActive': item.isActive,
              'metadata': item.metadata,
            })
        .toList();

    _channel.sendUXMessage(UXMessage.create(
      type: 'breadcrumb_update',
      payload: {'items': itemMaps},
      source: 'breadcrumb_service',
    ));
  }
}
