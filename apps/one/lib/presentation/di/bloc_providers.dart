import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_bloc.dart';

import 'service_locator.dart';

/// Utility class to provide all BLoCs at once
class AppBlocProviders {
  /// Returns a list of BlocProvider widgets for all application BLoCs
  static List<BlocProvider> get providers => [
    BlocProvider<DomainSelectionBloc>(
      create:
          (context) =>
              sl<DomainSelectionBloc>()..add(InitializeDomainSelectionEvent()),
    ),
    BlocProvider<ModelSelectionBloc>(
      create:
          (context) =>
              sl<ModelSelectionBloc>()..add(InitializeModelSelectionEvent()),
    ),
    BlocProvider<ConceptSelectionBloc>(
      create:
          (context) =>
              sl<ConceptSelectionBloc>()
                ..add(InitializeConceptSelectionEvent()),
    ),
    BlocProvider<ThemeBloc>(create: (context) => sl<ThemeBloc>()),
  ];

  /// Wraps a widget with all the necessary BlocProviders
  static Widget wrapWithProviders(Widget child) {
    return MultiBlocProvider(providers: providers, child: child);
  }
}
