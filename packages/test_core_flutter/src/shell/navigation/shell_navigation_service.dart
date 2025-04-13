part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Service responsible for coordinating navigation in the Shell architecture
///
/// This service manages the navigation state, breadcrumbs, and routing throughout
/// the application, providing a unified navigation experience that's connected to
/// the domain model.
class ShellNavigationService {
  /// The breadcrumb service for managing navigation path
  final BreadcrumbService _breadcrumbService = BreadcrumbService();

  /// Navigation message channel for app-wide navigation coordination
  final UXChannel _navigationChannel = UXChannel(
    'navigation_channel',
    name: 'Shell Navigation Channel',
  );

  /// Current location in the application
  String _currentLocation = '/';

  /// Navigation history stack
  final List<String> _navigationHistory = [];

  /// Parameters for the current location
  Map<String, dynamic> _currentParameters = {};

  /// The domain model being navigated
  late Domain? _domain;

  /// Reference to the shell app
  late ShellApp? _shellApp;

  /// Maximum navigation history entries to keep
  final int _maxHistoryEntries = 50;

  /// Navigation state change listeners
  final List<void Function(String)> _navigationListeners = [];

  /// Static singleton instance
  static final ShellNavigationService _instance =
      ShellNavigationService._internal();

  /// Factory constructor that returns a singleton instance
  factory ShellNavigationService({Domain? domain, ShellApp? shellApp}) {
    _instance._domain = domain;
    _instance._shellApp = shellApp;
    return _instance;
  }

  /// Private constructor for singleton pattern
  ShellNavigationService._internal()
      : _domain = null,
        _shellApp = null;

  /// Get the breadcrumb service
  BreadcrumbService get breadcrumbService => _breadcrumbService;

  /// Get the navigation message channel
  UXChannel get navigationChannel => _navigationChannel;

  /// Get the current location
  String get currentLocation => _currentLocation;

  /// Get the current parameters
  Map<String, dynamic> get currentParameters =>
      Map.unmodifiable(_currentParameters);

  /// Initialize the navigation service with default home breadcrumb
  void initialize() {
    // Add home breadcrumb
    _breadcrumbService.resetToHome(
      const BreadcrumbItem(
        label: 'Home',
        destination: '/',
        icon: Icons.home,
      ),
    );

    // Set up navigation message handlers
    _setupMessageHandlers();

    // Log initialization with domain and shell app information
    if (_domain != null) {
      print('Navigation service initialized with domain: ${_domain!.code}');
    }

    if (_shellApp != null) {
      print('Navigation service connected to ShellApp instance');
    }
  }

  /// Set up handlers for navigation messages
  void _setupMessageHandlers() {
    _navigationChannel.onUXMessageType('navigate_to', (message) {
      final destination = message.payload['destination'] as String;
      final parameters = message.payload['parameters'] as Map<String, dynamic>?;

      navigateTo(
        destination,
        parameters: parameters,
        label: message.payload['label'] as String?,
        icon: message.payload['icon'] != null
            ? IconData(message.payload['icon'] as int,
                fontFamily: 'MaterialIcons')
            : null,
      );
    });

    _navigationChannel.onUXMessageType('navigate_back', (message) {
      navigateBack();
    });
  }

  /// Navigate to a specific destination
  void navigateTo(
    String destination, {
    Map<String, dynamic>? parameters,
    String? label,
    IconData? icon,
  }) {
    // Update current location and parameters
    final previousLocation = _currentLocation;
    _currentLocation = destination;
    _currentParameters = parameters ?? {};

    // Add to history if it's a new location
    if (previousLocation != destination) {
      _navigationHistory.add(previousLocation);

      // Trim history if it exceeds maximum size
      if (_navigationHistory.length > _maxHistoryEntries) {
        _navigationHistory.removeAt(0);
      }
    }

    // Derive label from destination if not provided
    final effectiveLabel = label ?? _getLabelFromDestination(destination);

    // Create a breadcrumb item for this destination
    final breadcrumbItem = BreadcrumbItem(
      label: effectiveLabel,
      destination: destination,
      icon: icon,
      metadata: parameters,
    );

    // Update breadcrumbs
    if (_breadcrumbService.items
        .any((item) => item.destination == destination)) {
      // Navigate to existing breadcrumb
      _breadcrumbService.navigateToDestination(destination);
    } else {
      // Add new breadcrumb
      _breadcrumbService.add(breadcrumbItem);
    }

    // Send navigation message
    _sendNavigationMessage(destination, parameters);

    // Notify listeners
    _notifyListeners(destination);
  }

  /// Navigate to a domain entity
  void navigateToEntity(
    Entity entity, {
    Map<String, dynamic>? parameters,
    IconData? icon,
  }) {
    // Determine the destination path for the entity
    final concept = entity.concept;
    final model = concept.model;
    final destination = '/domain/${model.code}/${concept.code}/${entity.id}';

    // Navigate to the entity path
    navigateTo(
      destination,
      parameters: parameters,
      label: _getEntityDisplayName(entity),
      icon: icon ?? Icons.circle,
    );
  }

  /// Get a display name for an entity
  String _getEntityDisplayName(Entity entity) {
    // Try to find a suitable display name attribute
    // Common attribute names for entity identity/display
    final nameAttributes = ['name', 'title', 'label', 'code', 'id'];

    // Try each name attribute
    for (final attr in nameAttributes) {
      try {
        // Use reflection to try to access property
        final value = entity.getAttribute(attr)?.toString();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      } catch (e) {
        // Ignore errors and try next attribute
        continue;
      }
    }

    // Fallback to ID with concept name
    return '${entity.concept.code} ${entity.id}';
  }

  /// Navigate to a domain model
  void navigateToModel(
    Model model, {
    Map<String, dynamic>? parameters,
    IconData? icon,
  }) {
    // Determine the destination path for the model
    final destination = '/domain/${model.code}';

    // Navigate to the model path
    navigateTo(
      destination,
      parameters: parameters,
      label: model.code,
      icon: icon ?? Icons.category,
    );
  }

  /// Navigate to a concept within a model
  void navigateToConcept(
    Concept concept, {
    Map<String, dynamic>? parameters,
    IconData? icon,
  }) {
    // Determine the destination path for the concept
    final model = concept.model;
    final destination = '/domain/${model.code}/${concept.code}';

    // Navigate to the concept path
    navigateTo(
      destination,
      parameters: parameters,
      label: concept.code,
      icon: icon ?? Icons.bubble_chart,
    );
  }

  /// Navigate back to the previous location
  bool navigateBack() {
    // Check if there's history to go back to
    if (_navigationHistory.isEmpty) {
      return false;
    }

    // Get previous location
    final previousLocation = _navigationHistory.removeLast();

    // Navigate to previous location
    _currentLocation = previousLocation;
    _currentParameters = {};

    // Update breadcrumbs
    if (_breadcrumbService.items
        .any((item) => item.destination == previousLocation)) {
      _breadcrumbService.navigateToDestination(previousLocation);
    }

    // Send navigation message
    _sendNavigationMessage(previousLocation, null);

    // Notify listeners
    _notifyListeners(previousLocation);

    return true;
  }

  /// Add a navigation listener
  void addListener(void Function(String) listener) {
    _navigationListeners.add(listener);
  }

  /// Remove a navigation listener
  void removeListener(void Function(String) listener) {
    _navigationListeners.remove(listener);
  }

  /// Notify all listeners of a navigation change
  void _notifyListeners(String destination) {
    for (final listener in _navigationListeners) {
      listener(destination);
    }
  }

  /// Send a navigation message on the channel
  void _sendNavigationMessage(
      String destination, Map<String, dynamic>? parameters) {
    _navigationChannel.sendUXMessage(UXMessage.create(
      type: 'navigation_changed',
      payload: {
        'destination': destination,
        'parameters': parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      source: 'shell_navigation_service',
    ));
  }

  /// Generate a human-readable label from a destination path
  String _getLabelFromDestination(String destination) {
    // Extract the last path segment
    final segments = destination.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) {
      return 'Home';
    }

    // Get the last segment and make it title case
    final lastSegment = segments.last;

    // Convert kebab-case or snake_case to title case
    final words = lastSegment
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');

    return words;
  }

  /// Check if a specific path is in the navigation history
  bool isInHistory(String path) {
    return _navigationHistory.contains(path) || _currentLocation == path;
  }

  /// Clear navigation history
  void clearHistory() {
    _navigationHistory.clear();
    _breadcrumbService.clear();
    _breadcrumbService.resetToHome(
      const BreadcrumbItem(
        label: 'Home',
        destination: '/',
        icon: Icons.home,
      ),
    );

    // Update current location to home
    _currentLocation = '/';
    _currentParameters = {};

    // Send navigation message
    _sendNavigationMessage('/', null);

    // Notify listeners
    _notifyListeners('/');
  }
}
