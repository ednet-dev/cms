import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/domain_block.dart';
import 'package:ednet_one/presentation/state/blocs/domain_event.dart'
    as domain_events;
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_bloc.dart';
import 'package:ednet_one/presentation/state/providers/filter_manager.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_manager.dart';

// Import the global instances from main.dart
import 'package:ednet_one/main.dart'
    show
        createDomainSelectionBloc,
        createModelSelectionBloc,
        createConceptSelectionBloc,
        createDomainBloc,
        createThemeBloc,
        entityRepository;

/// Utility class to provide all BLoCs at once
class AppBlocProviders {
  /// Returns a list of BlocProvider widgets for all application BLoCs
  static List<BlocProvider> get blocProviders => [
    BlocProvider<DomainSelectionBloc>(
      create:
          (context) =>
              createDomainSelectionBloc()
                ..add(InitializeDomainSelectionEvent()),
    ),
    BlocProvider<ModelSelectionBloc>(
      create:
          (context) =>
              createModelSelectionBloc()..add(InitializeModelSelectionEvent()),
    ),
    BlocProvider<ConceptSelectionBloc>(
      create:
          (context) =>
              createConceptSelectionBloc()
                ..add(InitializeConceptSelectionEvent()),
    ),
    BlocProvider<DomainBloc>(
      create:
          (context) =>
              createDomainBloc()..add(domain_events.InitializeDomainEvent()),
    ),
    BlocProvider<ThemeBloc>(create: (context) => createThemeBloc()),
    BlocProvider<EntityBloc>(
      create: (context) => EntityBloc(repository: entityRepository),
    ),
  ];

  /// Wraps a widget with all the necessary providers
  static Widget wrapWithProviders(Widget child) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FilterManager()),
          ChangeNotifierProvider(create: (_) => BookmarkManager()),
        ],
        child: child,
      ),
    );
  }
}
