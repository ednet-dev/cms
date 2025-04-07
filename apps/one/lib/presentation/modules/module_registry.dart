import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/presentation/pages/project_management/project_management_page.dart';
import 'package:provider/provider.dart';
import '../pages/domain_modeler/live_preview_editor.dart';
import '../theme/providers/theme_provider.dart';

import 'domain_explorer/domain_explorer_module.dart';
import 'model_manager/model_manager_module.dart';

/// Registry for application modules
class AppModuleRegistry {
  final List<AppModule> _modules = [];

  /// Register a module
  void registerModule(AppModule module) {
    _modules.add(module);
  }

  /// Register default modules
  void registerModules(OneApplication app) {
    // Register project management module
    registerModule(ProjectManagementModule());

    // Register live preview editor module
    registerModule(LivePreviewEditorModule());

    // These modules need to be updated or removed later
    // registerModule(DomainExplorerModule(app));
    // registerModule(ModelManagerModule(app));
  }

  /// Get module by ID
  AppModule? getModule(String id) {
    try {
      return _modules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all registered modules
  List<AppModule> get modules => _modules;
}

/// Base class for application modules
abstract class AppModule {
  /// Unique ID for this module
  String get id;

  /// Display name for this module
  String get name;

  /// Icon data for this module
  IconData get icon;

  /// Build the main content for this module
  Widget buildModuleContent(BuildContext context);

  /// Build any app bar actions for this module
  List<Widget> buildAppBarActions(BuildContext context) => [];

  /// Build any floating action buttons for this module
  Widget? buildFloatingActionButton(BuildContext context) => null;
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
