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

    // 1. Update domain selection
    context.read<DomainSelectionBloc>().add(SelectDomainEvent(domain));

    // 2. Update models for the selected domain
    final modelBloc = context.read<ModelSelectionBloc>();
    modelBloc.add(UpdateModelsForDomainEvent(domain));

    // 3. After a brief delay, select a model and update concepts
    Future.delayed(const Duration(milliseconds: 100), () {
      final modelState = modelBloc.state;
      if (modelState.availableModels.isNotEmpty) {
        // Try to find a non-Application model first
        Model? modelToSelect;
        for (var model in modelState.availableModels) {
          if (model.code.toLowerCase() != 'application') {
            modelToSelect = model;
            break;
          }
        }
        // If no alternative found, use the first model
        modelToSelect ??= modelState.availableModels.first;

        debugPrint(
          '🧭 NavigationHelper: Auto-selecting model ${modelToSelect.code}',
        );
        navigateToModel(context, modelToSelect);
      }
    });
  }

  /// Navigate to a specific model and automatically select an appropriate concept
  ///
  /// This handles selection of the model and updating the concepts accordingly.
  static void navigateToModel(BuildContext context, Model model) {
    debugPrint('🧭 NavigationHelper: Navigating to model ${model.code}');

    // 1. Update model selection
    context.read<ModelSelectionBloc>().add(SelectModelEvent(model));

    // 2. Update concepts with error handling
    try {
      final conceptBloc = context.read<ConceptSelectionBloc>();
      conceptBloc.add(UpdateConceptsForModelEvent(model));

      // 3. After a brief delay, select a concept if available
      Future.delayed(const Duration(milliseconds: 100), () {
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
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load concepts for ${model.code}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Navigate to a specific concept and load its entities
  ///
  /// This handles the selection of a concept and loads its entities if it's an entry concept.
  static void navigateToConcept(BuildContext context, Concept concept) {
    debugPrint('🧭 NavigationHelper: Navigating to concept ${concept.code}');

    // Update concept selection
    final conceptBloc = context.read<ConceptSelectionBloc>();
    conceptBloc.add(SelectConceptEvent(concept));

    // After a brief delay, check if we need to refresh entities
    Future.delayed(const Duration(milliseconds: 100), () {
      final conceptState = conceptBloc.state;

      // If no entities but concept has entry flag, try to refresh
      if ((conceptState.selectedEntities == null ||
              conceptState.selectedEntities!.isEmpty) &&
          concept.entry) {
        try {
          debugPrint(
            '🧭 NavigationHelper: Refreshing entities for entry concept',
          );
          conceptBloc.add(RefreshConceptEvent(concept));
        } catch (e) {
          debugPrint('🧭 NavigationHelper: Error refreshing entities: $e');
        }
      }
    });
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
