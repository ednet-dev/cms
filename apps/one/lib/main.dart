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

import 'presentation/di/bloc_providers.dart' as bloc_providers;
import 'presentation/layouts/app_shell.dart';
import 'presentation/modules/module_registry.dart';
import 'presentation/navigation/navigation_service.dart';
import 'presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'presentation/theme/theme_service.dart';
import 'presentation/state/providers/domain_service.dart';
import 'presentation/layouts/providers/layout_provider.dart';
import 'presentation/theme/providers/theme_provider.dart';
import 'presentation/pages/workspace/immersive_workspace_page.dart';
import 'presentation/pages/examples/entity_persistence_example_page.dart';
import 'presentation/pages/domain_modeler/domain_model_editor.dart';

// Application singletons
final oneApplication = OneApplication();
final navigationService = NavigationService();
final themeService = ThemeService();
final domainService = DomainService(oneApplication);
final moduleRegistry = AppModuleRegistry();
final entityRepository = EntityRepositoryImpl(oneApplication);
late final PersistenceService persistenceService;

// Bloc factories
DomainSelectionBloc createDomainSelectionBloc() =>
    DomainSelectionBloc(app: oneApplication);
ModelSelectionBloc createModelSelectionBloc() =>
    ModelSelectionBloc(app: oneApplication);
ConceptSelectionBloc createConceptSelectionBloc() =>
    ConceptSelectionBloc(app: oneApplication);
DomainBloc createDomainBloc() => DomainBloc(app: oneApplication);
ThemeBloc createThemeBloc() => ThemeBloc();

void main() async {
  debugPrint('===== Starting application initialization =====');
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Flutter binding initialized');

  try {
    debugPrint('Initializing theme service...');
    await themeService.init();
    debugPrint('Theme service initialized successfully');
  } catch (e) {
    debugPrint('❌ Theme service initialization failed: $e');
  }

  // Initialize OneApplication
  try {
    debugPrint('Initializing OneApplication...');
    final stopwatch = Stopwatch()..start();
    await oneApplication.initializeApplication();
    debugPrint(
      'OneApplication initialized in ${stopwatch.elapsedMilliseconds}ms',
    );
    debugPrint('Available domains: ${oneApplication.domains.length}');
    debugPrint('Grouped domains: ${oneApplication.groupedDomains.length}');

    // Initialize persistence service
    persistenceService = PersistenceService(oneApplication);

    // Try to load previous state
    try {
      debugPrint('Loading domain models from persistence...');
      final loaded = await persistenceService.loadAllDomainModels();
      debugPrint(
        loaded
            ? 'Successfully loaded domain models from persistence'
            : 'No domain models loaded from persistence',
      );

      // Set up auto-save
      PersistenceService.setupAutoSave(oneApplication);
      debugPrint('Auto-save scheduled for domain models');
    } catch (e) {
      debugPrint('❌ Error loading domain models: $e');
    }

    // Register modules
    moduleRegistry.registerModules(oneApplication);
    debugPrint('Registered ${moduleRegistry.modules.length} modules');

    // Force domain selection
    debugPrint('Manually triggering domain selection chain');
    _forceDomainSelection();
  } catch (e, stack) {
    debugPrint('❌ OneApplication initialization failed:');
    debugPrint('Error: $e');
    debugPrint('Stack trace: $stack');
  }

  // Debug domain initialization
  try {
    debugPrint('Checking domain initialization...');
    debugPrintDomainInfo();
  } catch (e) {
    debugPrint('❌ Domain check failed: $e');
  }

  debugPrint('Launching app...');
  runApp(AppBlocProviders.wrapWithProviders(const MyApp()));
  debugPrint('App launched');
}

/// Force domain selection to make sure UI elements show data
void _forceDomainSelection() {
  try {
    debugPrint('🔍 Manually triggering domain selection chain');

    // Log the domains available for debugging
    debugPrint('📊 Available domains: ${oneApplication.domains.length}');
    debugPrint('📊 Grouped domains: ${oneApplication.groupedDomains.length}');

    if (oneApplication.groupedDomains.isEmpty) {
      debugPrint(
        '❌ No domains available to select - check domain initialization',
      );
      return;
    }

    // Create the blocs
    final domainSelectionBloc = createDomainSelectionBloc();
    final modelSelectionBloc = createModelSelectionBloc();
    final conceptSelectionBloc = createConceptSelectionBloc();
    final domainBloc = createDomainBloc();

    // Manually initialize domains (will select first domain if available)
    domainSelectionBloc.add(InitializeDomainSelectionEvent());

    // Manually trigger model selection if domain is available
    if (oneApplication.groupedDomains.isNotEmpty) {
      final domain = oneApplication.groupedDomains.first;
      debugPrint(
        '📊 Using domain: ${domain.code} with ${domain.models.length} models',
      );

      // Select the first domain explicitly
      domainSelectionBloc.add(SelectDomainEvent(domain));

      // Update models for this domain
      modelSelectionBloc.add(UpdateModelsForDomainEvent(domain));

      // If domain has models, select first one and update concepts
      if (domain.models.isNotEmpty) {
        final model = domain.models.first;
        debugPrint(
          '📊 Using model: ${model.code} with ${model.concepts.length} concepts',
        );

        // Explicitly select the model
        modelSelectionBloc.add(SelectModelEvent(model));

        // Update concepts for this model
        conceptSelectionBloc.add(UpdateConceptsForModelEvent(model));

        // If model has concepts, select first one
        if (model.concepts.isNotEmpty) {
          final concept = model.concepts.first;
          debugPrint('📊 Using concept: ${concept.code}');
          conceptSelectionBloc.add(SelectConceptEvent(concept));
        } else {
          debugPrint('❌ No concepts available in the model ${model.code}');
        }
      } else {
        debugPrint('❌ No models available in the domain ${domain.code}');
      }
    } else {
      debugPrint('❌ No domains available after initialization');
    }

    // Also trigger on the main domain bloc to ensure UI updates
    domainBloc.add(domain_bloc_events.InitializeDomainEvent());

    if (oneApplication.groupedDomains.isNotEmpty) {
      domainBloc.add(
        domain_bloc_events.SelectDomainEvent(
          oneApplication.groupedDomains.first,
        ),
      );
    }
  } catch (e, stack) {
    debugPrint('❌ Error in _forceDomainSelection: $e');
    debugPrint('Stack trace: $stack');
  }
}

void debugPrintDomainInfo() {
  // Try to access application and domains
  try {
    // Safely access and display domains info
    debugPrint('✓ OneApplication available');

    try {
      final groupedDomains = oneApplication.groupedDomains;
      debugPrint(
        '✓ Grouped domains available: ${groupedDomains.length} domains found',
      );

      if (groupedDomains.isNotEmpty) {
        int index = 0;
        for (final domain in groupedDomains) {
          try {
            final String code = domain.code.toString();
            final modelsLength = domain.models.length;
            debugPrint('  Domain ${++index}: $code ($modelsLength models)');
          } catch (e) {
            debugPrint(
              '  Domain ${++index}: Error accessing domain properties - $e',
            );
          }
        }
      } else {
        debugPrint('  No grouped domains loaded yet');
      }
    } catch (e) {
      debugPrint('  Error accessing grouped domains: $e');
    }

    // Check initialization status - safely access property
    try {
      // Use dynamic access to check initialization status
      bool? initialized = false;
      try {
        initialized = (oneApplication as dynamic).isInitialized;
      } catch (_) {
        // Alternative check if property doesn't exist
        initialized = oneApplication.groupedDomains.isNotEmpty;
      }
      debugPrint('  App initialized: ${initialized ?? 'unknown'}');
    } catch (e) {
      debugPrint('  Cannot access initialization status: $e');
    }
  } catch (e, stack) {
    debugPrint('Error while checking domains: $e');
    debugPrint('Stack trace: $stack');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  void _checkAppState() {
    debugPrint('MyApp initialized - checking application state');
    try {
      // Verify if any domains are loaded at this point
      debugPrintDomainInfo();
    } catch (e) {
      debugPrint('Error in _checkAppState: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MaterialApp');

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
      child: MaterialApp(
        title: 'EDNet One',
        theme: context.select<ThemeBloc, ThemeData>(
          (themeBloc) => themeBloc.state.themeData,
        ),
        darkTheme: context.select<ThemeBloc, ThemeData>(
          (themeBloc) => themeBloc.state.themeData,
        ),
        themeMode: ThemeMode.system,
        navigatorKey: navigationService.navigatorKey,
        home: AppShell(
          title: 'EDNet One',
          modules: moduleRegistry.modules,
          navigationService: navigationService,
          initialModuleId:
              moduleRegistry.modules.isNotEmpty
                  ? moduleRegistry.modules.first.id
                  : null,
        ),
        routes: {
          // Add the immersive workspace page route
          ImmersiveWorkspacePage.routeName:
              (context) => ImmersiveWorkspacePage(title: 'Workspace'),
          // Add the entity persistence example page route
          EntityPersistenceExamplePage.routeName:
              (context) => EntityPersistenceExamplePage(),
          // Add the domain model editor route
          DomainModelEditor.routeName: (context) => const DomainModelEditor(),
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
