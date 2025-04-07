import 'package:ednet_one/generated/one_application.dart';
import '../layouts/app_module.dart';
import 'domain_explorer/domain_explorer_module.dart';
import 'model_manager/model_manager_module.dart';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import '../pages/domain_modeler/domain_model_editor.dart';
import '../pages/model_instance/model_instance_page.dart';
import '../pages/domain_modeler/live_preview_editor.dart';
import '../pages/project_management/project_management_page.dart';

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

    // Domain Modeler module
    _registry.registerModule(DomainModelEditorModule());

    // Model Instance Manager module
    _registry.registerModule(ModelInstanceModule());

    // Live Preview Editor module
    _registry.registerModule(LivePreviewEditorModule());

    // Project Management module
    _registry.registerModule(ProjectManagementModule());

    _initialized = true;
  }

  /// Get all registered modules
  List<AppModule> get modules => _registry.modules;

  /// Get a specific module by ID
  AppModule? getModule(String moduleId) => _registry.findModule(moduleId);

  /// Get all registered routes
  Map<String, ModuleRoute> get routes => _registry.routes;
}

/// Module for the Domain Model Editor
class DomainModelEditorModule extends AppModule {
  @override
  String get id => 'domain-modeler';

  @override
  String get name => 'Domain Modeler';

  @override
  IconData get icon => Icons.edit_note;

  @override
  Widget buildModuleContent(BuildContext context) {
    return const DomainModelEditor();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.save),
        tooltip: 'Save Domain Model',
        onPressed: () {
          // This would be handled by the DomainModelEditor itself
        },
      ),
    ];
  }
}

/// Module for the Model Instance Manager
class ModelInstanceModule extends AppModule {
  @override
  String get id => 'model-instance';

  @override
  String get name => 'Model Instances';

  @override
  IconData get icon => Icons.play_circle_outline;

  @override
  Widget buildModuleContent(BuildContext context) {
    return const ModelInstancePage();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Create New Instance',
        onPressed: () {
          // This would be handled by the ModelInstancePage
        },
      ),
    ];
  }
}

/// Module for the Live Preview Editor
class LivePreviewEditorModule extends AppModule {
  @override
  String get id => 'live-preview-editor';

  @override
  String get name => 'Live Domain Editor';

  @override
  IconData get icon => Icons.splitscreen;

  @override
  Widget buildModuleContent(BuildContext context) {
    return const LivePreviewEditor();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.save),
        tooltip: 'Save Domain Model',
        onPressed: () {
          // This would be handled by the LivePreviewEditor itself
        },
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Refresh Preview',
        onPressed: () {
          // This would be handled by the LivePreviewEditor itself
        },
      ),
    ];
  }
}

/// Module for the Project Management
class ProjectManagementModule extends AppModule {
  @override
  String get id => 'project-management';

  @override
  String get name => 'Project Management';

  @override
  IconData get icon => Icons.business;

  @override
  Widget buildModuleContent(BuildContext context) {
    return const ProjectManagementPage();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Create New Project',
        onPressed: () {
          // This would be handled by the ProjectManagementPage
        },
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {
          // This would be handled by the ProjectManagementPage
        },
      ),
    ];
  }
}
