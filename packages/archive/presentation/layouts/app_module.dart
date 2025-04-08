import 'package:flutter/material.dart';

/// Defines the interface for a micro-frontend module that can be registered with the AppShell.
///
/// Each module is responsible for providing its own navigation, routes, and content.
/// Modules are isolated components that can be developed and tested independently.
abstract class AppModule {
  /// Unique identifier for this module
  String get id;

  /// Display name shown in navigation
  String get name;

  /// Icon used in navigation UI
  IconData get icon;

  /// Build the main content for this module
  Widget buildModuleContent(BuildContext context);

  /// Build optional floating action button for this module
  Widget? buildFloatingActionButton(BuildContext context) => null;

  /// Build any additional app bar actions specific to this module
  List<Widget> buildAppBarActions(BuildContext context) => [];

  /// Optional method to handle initialization when the module is first loaded
  Future<void> initialize() async {}

  /// Optional method to clean up resources when the module is unloaded
  Future<void> dispose() async {}
}

/// Defines a route within a module that can be registered with the app router
class ModuleRoute {
  /// The path for this route (relative to module path)
  final String path;

  /// The builder function for this route
  final Widget Function(BuildContext context, Map<String, dynamic> params)
  builder;

  /// Optional title for this route
  final String? title;

  ModuleRoute({required this.path, required this.builder, this.title});
}

/// Registry of modules and their routes for the application
class ModuleRegistry {
  final List<AppModule> _modules = [];
  final Map<String, ModuleRoute> _routes = {};

  /// Register a module with the application
  void registerModule(AppModule module) {
    if (!_modules.any((m) => m.id == module.id)) {
      _modules.add(module);
    }
  }

  /// Register a route for a specific module
  void registerRoute(String moduleId, String path, ModuleRoute route) {
    final fullPath = '/$moduleId$path';
    _routes[fullPath] = route;
  }

  /// Get all registered modules
  List<AppModule> get modules => List.unmodifiable(_modules);

  /// Get all registered routes
  Map<String, ModuleRoute> get routes => Map.unmodifiable(_routes);

  /// Find a module by ID
  AppModule? findModule(String id) {
    try {
      return _modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
