import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

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

  /// Navigate to a named route
  Future<dynamic> navigateTo(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
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
    return navigateTo(AppRoutes.graph);
  }

  /// Navigate back to the previous route
  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
