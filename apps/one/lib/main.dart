import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
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

import 'presentation/di/bloc_providers.dart';
import 'presentation/navigation/navigation_service.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'presentation/state/blocs/theme_bloc/theme_state.dart';
import 'presentation/theme/theme_service.dart';
import 'presentation/state/providers/domain_service.dart';

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
  print('===== Starting application initialization =====');
  WidgetsFlutterBinding.ensureInitialized();
  print('Flutter binding initialized');

  try {
    print('Initializing theme service...');
    await themeService.init();
    print('Theme service initialized successfully');
  } catch (e) {
    print('❌ Theme service initialization failed: $e');
  }

  // Initialize OneApplication
  try {
    print('Initializing OneApplication...');
    final stopwatch = Stopwatch()..start();
    await oneApplication.initializeApplication();
    print('OneApplication initialized in ${stopwatch.elapsedMilliseconds}ms');
    print('Available domains: ${oneApplication.domains.length}');
    print('Grouped domains: ${oneApplication.groupedDomains.length}');

    // Force domain selection
    print('Manually triggering domain selection chain');
    _forceDomainSelection();
  } catch (e, stack) {
    print('❌ OneApplication initialization failed:');
    print('Error: $e');
    print('Stack trace: $stack');
  }

  // Debug domain initialization
  try {
    print('Checking domain initialization...');
    debugPrintDomainInfo();
  } catch (e) {
    print('❌ Domain check failed: $e');
  }

  print('Launching app...');
  runApp(MyApp());
  print('App launched');
}

/// Force domain selection to make sure UI elements show data
void _forceDomainSelection() {
  try {
    print('🔍 Manually triggering domain selection chain');

    // Log the domains available for debugging
    print('📊 Available domains: ${oneApplication.domains.length}');
    print('📊 Grouped domains: ${oneApplication.groupedDomains.length}');

    if (oneApplication.groupedDomains.isEmpty) {
      print('❌ No domains available to select - check domain initialization');
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
      print(
        '📊 Using domain: ${domain.code} with ${domain.models.length} models',
      );

      // Select the first domain explicitly
      domainSelectionBloc.add(SelectDomainEvent(domain));

      // Update models for this domain
      modelSelectionBloc.add(UpdateModelsForDomainEvent(domain));

      // If domain has models, select first one and update concepts
      if (domain.models.isNotEmpty) {
        final model = domain.models.first;
        print(
          '📊 Using model: ${model.code} with ${model.concepts.length} concepts',
        );

        // Explicitly select the model
        modelSelectionBloc.add(SelectModelEvent(model));

        // Update concepts for this model
        conceptSelectionBloc.add(UpdateConceptsForModelEvent(model));

        // If model has concepts, select first one
        if (model.concepts.isNotEmpty) {
          final concept = model.concepts.first;
          print('📊 Using concept: ${concept.code}');
          conceptSelectionBloc.add(SelectConceptEvent(concept));
        } else {
          print('❌ No concepts available in the model ${model.code}');
        }
      } else {
        print('❌ No models available in the domain ${domain.code}');
      }
    } else {
      print('❌ No domains available after initialization');
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

    // Clean up the blocs to avoid memory leaks
    domainSelectionBloc.close();
    modelSelectionBloc.close();
    conceptSelectionBloc.close();
    domainBloc.close();
  } catch (e, stack) {
    print('❌ Error in _forceDomainSelection: $e');
    print('Stack trace: $stack');
  }
}

void debugPrintDomainInfo() {
  // Try to access application and domains
  try {
    // Safely access and display domains info
    print('✓ OneApplication available');

    try {
      final groupedDomains = oneApplication.groupedDomains;
      print(
        '✓ Grouped domains available: ${groupedDomains.length} domains found',
      );

      if (groupedDomains.isNotEmpty) {
        int index = 0;
        for (final domain in groupedDomains) {
          try {
            final String code = domain.code.toString();
            final modelsLength = domain.models.length;
            print('  Domain ${++index}: $code ($modelsLength models)');
          } catch (e) {
            print(
              '  Domain ${++index}: Error accessing domain properties - $e',
            );
          }
        }
      } else {
        print('  No grouped domains loaded yet');
      }
    } catch (e) {
      print('  Error accessing grouped domains: $e');
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
      print('  App initialized: ${initialized ?? 'unknown'}');
    } catch (e) {
      print('  Cannot access initialization status: $e');
    }
  } catch (e, stack) {
    print('Error while checking domains: $e');
    print('Stack trace: $stack');
  }
}

class MyApp extends StatefulWidget {
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
    print('MyApp initialized - checking application state');
    try {
      // Verify if any domains are loaded at this point
      debugPrintDomainInfo();
    } catch (e) {
      print('Error in _checkAppState: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building MaterialApp');

    return AppBlocProviders.wrapWithProviders(
      BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          print('ThemeBloc state updated: ${themeState.runtimeType}');
          return MaterialApp(
            title: 'EDNet One',
            theme: themeState.themeData,
            navigatorKey: navigationService.navigatorKey,
            home: HomePage(title: 'EDNet One'),
          );
        },
      ),
    );
  }
}
