import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/presentation/state/blocs/domain_block.dart';
import 'package:ednet_one/presentation/state/blocs/domain_event.dart'
    as domain_bloc_events;
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_core/ednet_core.dart';
import 'domain/repositories/entity_repository.dart';
import 'domain/repositories/entity_repository_impl.dart';
import 'domain/services/persistence_service.dart';
import 'domain/services/model_instance_service.dart';
import 'domain/services/project_service.dart';
import 'domain/services/deployment_service.dart';

import 'presentation/di/bloc_providers.dart' as bloc_providers;
import 'presentation/layouts/app_shell.dart';
import 'presentation/modules/module_registry.dart';
import 'presentation/navigation/navigation_service.dart';
import 'presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'presentation/theme/theme_service.dart';
import 'presentation/state/providers/domain_service.dart';
import 'presentation/layouts/providers/layout_provider.dart';
import 'presentation/theme/providers/theme_provider.dart';
import 'presentation/app.dart';
import 'presentation/domain/domain_model_provider.dart';
import 'presentation/state/blocs/entity/entity_bloc.dart';

/// Global instance of the OneApplication
late OneApplication oneApplication;

/// Global instance of the NavigationService
late NavigationService navigationService;

/// Global instance of the ThemeService
late ThemeService themeService;

/// Global instance of the PersistenceService
late PersistenceService persistenceService;

/// Global instance of the ModelInstanceService
late ModelInstanceService modelInstanceService;

/// Global instance of the ProjectService
late ProjectService projectService;

/// Global instance of the DeploymentService
late DeploymentService deploymentService;

/// Global instance of the DomainService
late DomainService domainService;

/// Global instance of the AppModuleRegistry
late AppModuleRegistry moduleRegistry;

/// Application entry point
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the application
  await initializeApplication();

  // Run the app
  runApp(const MyApp());
}

/// Initialize the application and its services
Future<void> initializeApplication() async {
  try {
    // Create OneApplication instance
    oneApplication = OneApplication();

    // Initialize services
    navigationService = NavigationService();
    themeService = ThemeService();
    moduleRegistry = AppModuleRegistry();

    // Create a SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Create PersistenceService
    persistenceService = PersistenceService(oneApplication);

    // Create ModelInstanceService
    modelInstanceService = ModelInstanceService(persistenceService);

    // Initialize domain service
    domainService = DomainService(oneApplication);

    // Initialize project and deployment services
    projectService = ProjectService(oneApplication, persistenceService);
    deploymentService =
        DeploymentService(oneApplication, persistenceService, projectService);

    // Register modules
    moduleRegistry.registerModules(oneApplication);

    // Load configurations
    await modelInstanceService.loadConfigurations();
    await projectService.loadProjects();

    // Create and register a test domain
    _createTestDomain();

    // Set up auto-save
    PersistenceService.setupAutoSave(oneApplication);
  } catch (e) {
    debugPrint('Error initializing application: $e');
  }
}

/// Create a test domain for development
void _createTestDomain() {
  final domain = oneApplication.createDomain('TestDomain');
  domain.description = 'This is a test domain';

  final model = domain.createModel('TestModel');
  model.description = 'Test model for development';

  final personConcept = model.createConcept('Person');
  personConcept.description = 'Represents a person';

  _createAttribute(personConcept, 'firstName', 'First name', domain);
  _createAttribute(personConcept, 'lastName', 'Last name', domain);
  _createAttribute(personConcept, 'age', 'Age in years', domain, 'int');
  _createAttribute(personConcept, 'email', 'Email address', domain, 'Email');
}

/// Helper to create an attribute
void _createAttribute(
  Concept concept,
  String code,
  String description,
  Domain domain, [
  String type = 'String',
]) {
  final attribute = Attribute(concept, code);
  attribute.description = description;
  attribute.type = domain.getType(type);
}

/// MyApp widget
class MyApp extends StatefulWidget {
  /// Constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

/// MyApp state
class MyAppState extends State<MyApp> {
  /// Current theme provider
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide theme
        ChangeNotifierProvider.value(value: _themeProvider),

        // Provide domain model
        ChangeNotifierProvider(
          create: (_) => DomainModelProvider(oneApplication),
        ),

        // Provide entity bloc for the first domain's first model (for examples)
        if (oneApplication.domains.isNotEmpty &&
            oneApplication.domains.first.models.isNotEmpty)
          BlocProvider(
            create: (_) =>
                EntityBloc(repository: InMemoryRepository('example')),
          ),
      ],
      child: const App(),
    );
  }
}

class AppBlocProviders {
  static Widget wrapWithProviders(Widget child) {
    // Use the original bloc providers from the bloc_providers.dart file
    Widget wrappedWithBlocs = bloc_providers.AppBlocProviders.wrapWithProviders(
      child,
    );

    // Then add our new providers
    return MultiProvider(
      providers: [
        // Add the LayoutProvider
        ChangeNotifierProvider<LayoutProvider>(create: (_) => LayoutProvider()),
        // Add the ThemeProvider
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(themeService),
        ),
        // Add the domain model provider
        Provider<OneApplication>.value(value: oneApplication),
        // Add the navigation service
        Provider<NavigationService>.value(value: navigationService),
      ],
      child: wrappedWithBlocs,
    );
  }
}
