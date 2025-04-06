import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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

import 'presentation/di/bloc_providers.dart';
import 'presentation/navigation/navigation_service.dart';
import 'presentation/pages/bookmarks_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'presentation/theme/theme_service.dart';
import 'presentation/state/providers/domain_service.dart';
import 'presentation/pages/model_detail_page.dart';
import 'presentation/pages/domain_detail_page.dart';
import 'presentation/pages/graph_page.dart';
import 'presentation/pages/domains_page.dart';
import 'presentation/pages/concepts_page.dart';
import 'presentation/pages/models_page.dart';
import 'presentation/pages/entity_detail_page.dart';

// Application singletons
final oneApplication = OneApplication();
final navigationService = NavigationService();
final themeService = ThemeService();
final domainService = DomainService(oneApplication);

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

    // After initialization is complete, ensure the graph page is accessible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔍 Setting up direct graph page access for testing');

      // Add a floating action button to the main app to directly access graph page
      // This can be done in the main app's state or through a global key
      // For now, we'll just ensure the navigationService can access it
      navigationService.setDebugGraphAccess();
    });
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

    return MaterialApp(
      title: 'EDNet One',
      theme: context.select<ThemeBloc, ThemeData>(
        (themeBloc) => themeBloc.state.themeData,
      ),
      navigatorKey: navigationService.navigatorKey,
      home: HomePage(title: 'EDNet One'),
      routes: {
        BookmarksPage.routeName: (context) => const BookmarksPage(),
        // Simple route for GraphPage as it doesn't require special parameters
        GraphPage.routeName: (context) => const GraphPage(),
        // Add DomainsPage route with empty domains as a placeholder
        // The actual domains will be passed when navigating programmatically
        DomainsPage.routeName:
            (context) => DomainsPage(
              domains: oneApplication.groupedDomains,
              onDomainSelected: (domain) {
                Navigator.of(
                  context,
                ).pushNamed(DomainDetailPage.routeName, arguments: domain);
              },
            ),
        // ConceptsPage route requires model and domain context - handled in onGenerateRoute
      },
      // Use onGenerateRoute for routes that need parameters
      onGenerateRoute: (settings) {
        if (settings.name == ModelDetailPage.routeName ||
            settings.name == DomainDetailPage.routeName) {
          // These routes require parameters and should be created
          // using Navigator.push with MaterialPageRoute instead
          return null;
        }

        // Handle ConceptsPage routing with parameters
        if (settings.name == ConceptsPage.routeName) {
          // Extract the arguments as a Map
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => ConceptsPage(
                  concepts: args['concepts'] as Concepts,
                  domainName: args['domainName'] as String,
                  modelName: args['modelName'] as String,
                  onConceptSelected:
                      args['onConceptSelected'] as void Function(Concept)?,
                ),
          );
        }

        // Handle ModelsPage routing with parameters
        if (settings.name == ModelsPage.routeName) {
          // Extract the arguments as a Map
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => ModelsPage(
                  models: args['models'] as Models,
                  domainName: args['domainName'] as String,
                  onModelSelected:
                      args['onModelSelected'] as void Function(Model)?,
                ),
          );
        }

        // Handle EntityDetailPage routing with parameters
        if (settings.name == EntityDetailPage.routeName) {
          // Extract the arguments as a Map
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => EntityDetailPage(
                  entities: args['entities'] as Entities,
                  domainName: args['domainName'] as String,
                  modelName: args['modelName'] as String,
                  conceptName: args['conceptName'] as String,
                ),
          );
        }

        return null;
      },
    );
  }
}
