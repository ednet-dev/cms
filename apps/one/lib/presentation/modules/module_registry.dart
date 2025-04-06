import 'package:ednet_one/generated/one_application.dart';
import '../layouts/app_module.dart';
import 'domain_explorer/domain_explorer_module.dart';
import 'model_manager/model_manager_module.dart';

/// A singleton registry for all application modules
class AppModuleRegistry {
  static final AppModuleRegistry _instance = AppModuleRegistry._internal();

  factory AppModuleRegistry() => _instance;

  AppModuleRegistry._internal();

  final ModuleRegistry _registry = ModuleRegistry();
  bool _initialized = false;

  /// Register all modules with the application
  void registerModules(OneApplication app) {
    if (_initialized) return;

    // Register all modules
    _registry.registerModule(DomainExplorerModule(app));
    _registry.registerModule(ModelManagerModule(app));

    // TODO: Implement and register other modules:
    // - EntityWorkspaceModule
    // - GraphVisualizerModule
    // - SettingsModule

    _initialized = true;
  }

  /// Get all registered modules
  List<AppModule> get modules => _registry.modules;

  /// Get a specific module by ID
  AppModule? getModule(String moduleId) => _registry.findModule(moduleId);

  /// Get all registered routes
  Map<String, ModuleRoute> get routes => _registry.routes;
}
