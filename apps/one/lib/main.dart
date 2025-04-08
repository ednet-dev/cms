import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/domain/services/project_service.dart';
import 'package:ednet_one/domain/services/deployment_service.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/providers/project_provider.dart';
import 'package:ednet_one/domain/entities/project_entity.dart';
import 'package:ednet_one/presentation/pages/project_management/project_management_page.dart';
import 'package:ednet_one/presentation/navigation/navigation_service.dart';
import 'package:ednet_one/presentation/theme/theme_service.dart';
import 'package:ednet_one/domain/services/model_instance_service.dart';
import 'package:ednet_one/presentation/state/providers/domain_service.dart';
import 'package:ednet_one/presentation/modules/module_registry.dart';
import 'package:ednet_one/presentation/di/bloc_providers.dart'
    as bloc_providers;
import 'package:ednet_one/presentation/layouts/providers/layout_provider.dart';
import 'package:ednet_one/presentation/domain/domain_model_provider.dart';

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
    await oneApplication.initializeApplication();

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
  try {
    // Using the createDomain method that exists in OneApplication
    final domain = oneApplication.createDomain('TestDomain');
    domain.description = 'This is a test domain';

    // Create a Model using constructor with domain
    final model = Model(domain, 'TestModel');
    model.description = 'Test model for development';
    domain.models.add(model);

    // Create a Concept using constructor with model
    final personConcept = Concept(model, 'Person');
    personConcept.description = 'Represents a person';
    model.concepts.add(personConcept);

    // Create attributes
    _createAttribute(personConcept, 'firstName', 'First name', domain);
    _createAttribute(personConcept, 'lastName', 'Last name', domain);
    _createAttribute(personConcept, 'age', 'Age in years', domain, 'int');
    _createAttribute(personConcept, 'email', 'Email address', domain, 'Email');

    // Log success
    debugPrint('Created test domain with model and concept');
    debugPrint('Model concepts count: ${model.concepts.length}');
    debugPrint('Person attributes count: ${personConcept.attributes.length}');
  } catch (e) {
    debugPrint('Error creating test domain: $e');
  }
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
  // We won't set description as it's not available in the Attribute class
  attribute.type = domain.getType(type);
  concept.attributes.add(attribute);
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

        // Provide project provider
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(projectService, oneApplication),
        ),
      ],
      child: MaterialApp(
        title: 'EDNet One',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const ProjectManagementPage(),
        routes: {
          ProjectManagementPage.routeName: (context) =>
              const ProjectManagementPage(),
        },
      ),
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
          create: (_) => ThemeProvider(),
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
