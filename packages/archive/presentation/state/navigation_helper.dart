import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';

/// Helper class to centralize the domain/model/concept navigation logic
/// This makes the navigation behavior consistent across different parts of the app
class NavigationHelper {
  /// Navigate to a specific domain and automatically select an appropriate model and concept
  ///
  /// This method implements the complete domain->model->concept navigation chain,
  /// making navigation consistent throughout the app.
  static void navigateToDomain(BuildContext context, Domain domain) {
    debugPrint('🧭 NavigationHelper: Navigating to domain ${domain.code}');

    if (context.mounted) {
      final modelBloc = context.read<ModelSelectionBloc>();
      final conceptBloc = context.read<ConceptSelectionBloc>();
      ScaffoldMessenger.of(context);

      context.read<DomainSelectionBloc>().add(SelectDomainEvent(domain));

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!context.mounted) return;
        modelBloc.add(InitializeModelSelectionEvent());
        conceptBloc.add(InitializeConceptSelectionEvent());
        modelBloc.add(UpdateModelsForDomainEvent(domain));

        Future.delayed(const Duration(milliseconds: 300), () {
          if (!context.mounted) return;
          final modelState = modelBloc.state;
          if (modelState.availableModels.isNotEmpty) {
            Model? modelToSelect = findPreferredModel(
              modelState.availableModels,
            );
            debugPrint(
              '🧭 NavigationHelper: Auto-selecting model ${modelToSelect.code}',
            );
            navigateToModel(context, modelToSelect);
          }
        });
      });
    }
  }

  /// Navigate to a specific model and automatically select an appropriate concept
  ///
  /// This handles selection of the model and updating the concepts accordingly.
  static void navigateToModel(BuildContext context, Model model) {
    debugPrint('🧭 NavigationHelper: Navigating to model ${model.code}');

    if (context.mounted) {
      final modelBloc = context.read<ModelSelectionBloc>();
      final conceptBloc = context.read<ConceptSelectionBloc>();
      final messenger = ScaffoldMessenger.of(context);

      modelBloc.add(SelectModelEvent(model));

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!context.mounted) return;
        conceptBloc.add(InitializeConceptSelectionEvent());
        try {
          conceptBloc.add(UpdateConceptsForModelEvent(model));

          Future.delayed(const Duration(milliseconds: 300), () {
            if (!context.mounted) return;
            final conceptState = conceptBloc.state;
            if (conceptState.availableConcepts.isNotEmpty) {
              final firstConcept = conceptState.availableConcepts.first;
              debugPrint(
                '🧭 NavigationHelper: Auto-selecting concept ${firstConcept.code}',
              );
              navigateToConcept(context, firstConcept);
            }
          });
        } catch (e) {
          debugPrint(
            '🧭 NavigationHelper: Error updating concepts for model ${model.code}: $e',
          );
          messenger.showSnackBar(
            SnackBar(
              content: Text('Failed to load concepts for ${model.code}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  /// Navigate to a specific concept and load its entities
  ///
  /// This handles the selection of a concept and loads its entities if it's an entry concept.
  static void navigateToConcept(BuildContext context, Concept concept) {
    debugPrint('🧭 NavigationHelper: Navigating to concept ${concept.code}');

    if (context.mounted) {
      final conceptBloc = context.read<ConceptSelectionBloc>();
      final messenger = ScaffoldMessenger.of(context);

      conceptBloc.add(SelectConceptEvent(concept));

      Future.delayed(const Duration(milliseconds: 300), () {
        final conceptState = conceptBloc.state;
        if (concept.entry &&
            (conceptState.selectedEntities == null ||
                conceptState.selectedEntities!.isEmpty)) {
          try {
            debugPrint(
              '🧭 NavigationHelper: Refreshing entities for entry concept',
            );
            conceptBloc.add(RefreshConceptEvent(concept));
          } catch (e) {
            debugPrint('🧭 NavigationHelper: Error refreshing entities: $e');
            messenger.showSnackBar(
              SnackBar(
                content: Text('Failed to load entities for ${concept.code}'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      });
    }
  }

  /// Find a non-Application model in a list of models
  ///
  /// Returns the first non-Application model, or the first model if all are Application
  static Model findPreferredModel(Models models) {
    for (var model in models) {
      if (model.code.toLowerCase() != 'application') {
        return model;
      }
    }
    return models.first;
  }
}
