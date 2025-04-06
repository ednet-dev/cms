import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:ednet_one/presentation/theme/theme_components/list_item_card.dart';
import 'package:ednet_one/presentation/theme/theme_components/custom_colors.dart';

/// Widget for displaying a list of models
class ModelsWidget extends StatelessWidget {
  /// The models to display
  final Models models;

  /// Callback when a model is selected
  final void Function(Model model) onModelSelected;

  /// Optional title for the models section
  final String? title;

  /// Constructor for ModelsWidget
  const ModelsWidget({
    super.key,
    required this.models,
    required this.onModelSelected,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section if provided
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.view_module_rounded,
                  color: colorScheme.modelColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.modelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${models.length})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

        // Models list using the ListItemCard component
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models.elementAt(index);

              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ListItemCard(
                  title: model.code,
                  subtitle: model.description,
                  icon: Icons.model_training,
                  onTap: () => onModelSelected(model),
                  infoText:
                      model.concepts.isNotEmpty
                          ? '${model.concepts.length} concepts'
                          : null,
                  infoIcon: Icons.topic_outlined,
                  iconBackgroundColor: colorScheme.modelColor.withOpacity(0.2),
                  iconColor: colorScheme.modelColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
