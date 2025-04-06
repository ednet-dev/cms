import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/repositories/entity_repository.dart';
import 'package:ednet_one/domain/repositories/entity_repository_impl.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_event.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_state.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'entity_form.dart';

/// Dialog for creating or editing an entity
class EntityDialog extends StatelessWidget {
  /// The concept for which the entity is being created/edited
  final Concept concept;

  /// The domain containing the concept
  final Domain domain;

  /// The model containing the concept
  final Model model;

  /// The entity to edit (null for create)
  final Entity<dynamic>? entity;

  /// The OneApplication instance
  final OneApplication app;

  /// Creates an entity dialog
  const EntityDialog({
    super.key,
    required this.concept,
    required this.domain,
    required this.model,
    required this.app,
    this.entity,
  });

  /// Static method to show the dialog
  static Future<bool?> show({
    required BuildContext context,
    required Concept concept,
    required Domain domain,
    required Model model,
    required OneApplication app,
    Entity<dynamic>? entity,
  }) async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => EntityDialog(
            concept: concept,
            domain: domain,
            model: model,
            app: app,
            entity: entity,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = entity == null;

    // Create repository
    final repository = EntityRepositoryImpl(app);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(0),
        child: BlocProvider(
          create: (context) {
            final bloc = EntityBloc(repository: repository);

            // If editing, prepare the form
            if (!isCreating && entity != null) {
              bloc.add(
                PrepareUpdateEntityEvent(entity: entity!, concept: concept),
              );
            } else {
              // If creating, initialize with concept
              bloc.add(PrepareCreateEntityEvent(concept: concept));
            }

            return bloc;
          },
          child: BlocListener<EntityBloc, EntityState>(
            listener: (context, state) {
              // Close the dialog when operation succeeds
              if (state.status == EntityStatus.success) {
                Navigator.of(context).pop(true);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    isCreating
                        ? 'Create ${concept.code}'
                        : 'Edit ${concept.code}',
                    style: context.conceptTextStyle('Dialog', role: 'title'),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  elevation: 0,
                ),
                body: EntityForm(
                  concept: concept,
                  domain: domain,
                  model: model,
                  isCreating: isCreating,
                  onCancel: () => Navigator.of(context).pop(false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
