import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// Add imports for the Graph page
import '../pages/graph_page.dart';

/// Routes available in the application
class AppRoutes {
  static const home = '/';
  static const domain = '/domain/:id';
  static const model = '/domain/:domainId/model/:modelId';
  static const concept = '/domain/:domainId/model/:modelId/concept/:conceptId';
  static const graph = '/graph';
  static const settings = '/settings';

  /// Convert a route pattern to a concrete path
  static String mapToPath(String route, Map<String, String> params) {
    String path = route;
    params.forEach((key, value) {
      path = path.replaceAll(':$key', value);
    });
    return path;
  }
}

/// Service for handling navigation in the application
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// The current moduleId being displayed
  String? _currentModuleId;

  /// Function that will be called when module navigation is requested
  Function(String moduleId)? _moduleNavigationHandler;

  /// Get the current module ID
  String? get currentModuleId => _currentModuleId;

  /// Set module navigation handler - called by the AppShell during initialization
  void setModuleNavigationHandler(Function(String moduleId) handler) {
    _moduleNavigationHandler = handler;
  }

  /// Update the current module ID - called by the AppShell when module changes
  void updateCurrentModuleId(String moduleId) {
    _currentModuleId = moduleId;
  }

  /// Navigate to a specific module
  void navigateToModule(String moduleId) {
    if (_moduleNavigationHandler != null) {
      developer.log('Navigating to module: $moduleId', name: 'Navigation');
      _moduleNavigationHandler!(moduleId);
    } else {
      developer.log(
        'Module navigation handler not set',
        name: 'Navigation',
        error: true,
      );
    }
  }

  /// Navigate to a named route
  Future<dynamic> navigateTo(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    developer.log('Navigating to: $routeName', name: 'Navigation');
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a route and remove all previous routes
  Future<dynamic> navigateToAndRemoveUntil(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  /// Navigate to a domain details page
  Future<dynamic> navigateToDomain(Domain domain) {
    return navigateTo(
      AppRoutes.mapToPath(AppRoutes.domain, {'id': domain.code}),
      arguments: {'domain': domain},
    );
  }

  /// Navigate to a model details page
  Future<dynamic> navigateToModel(Domain domain, Model model) {
    return navigateTo(
      AppRoutes.mapToPath(AppRoutes.model, {
        'domainId': domain.code,
        'modelId': model.code,
      }),
      arguments: {'domain': domain, 'model': model},
    );
  }

  /// Navigate to a concept details page
  Future<dynamic> navigateToConcept(
    Domain domain,
    Model model,
    Concept concept,
  ) {
    return navigateTo(
      AppRoutes.mapToPath(AppRoutes.concept, {
        'domainId': domain.code,
        'modelId': model.code,
        'conceptId': concept.code,
      }),
      arguments: {'domain': domain, 'model': model, 'concept': concept},
    );
  }

  /// Navigate to graph view
  Future<dynamic> navigateToGraph() {
    developer.log('Navigating to Graph Visualization', name: 'Navigation');
    try {
      return navigatorKey.currentState!.pushNamed(GraphPage.routeName);
    } catch (e, stack) {
      developer.log(
        'Error navigating to graph: $e\n$stack',
        name: 'Navigation',
      );
      // Fallback to creating a new route if the named route fails
      return navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => const GraphPage()),
      );
    }
  }

  /// Navigate back to the previous route
  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  // Add a method for debug access to the graph page
  void setDebugGraphAccess() {
    developer.log('Setting up debug graph access', name: 'Navigation');
    // Nothing to set up by default - this is just a hook for debugging
  }
}
