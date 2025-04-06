import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/widgets/entity/bookmark_manager.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_widget.dart';

/// Widget for the application header area
class HeaderWidget extends StatelessWidget {
  /// Active filters
  final List<FilterCriteria> filters;

  /// Callback when a filter is added
  final void Function(FilterCriteria filter) onAddFilter;

  /// Callback when bookmark is requested
  final VoidCallback onBookmark;

  /// Optional bookmark manager
  final BookmarkManager? bookmarkManager;

  /// Optional callback when a bookmark is created
  final Function(Bookmark bookmark)? onBookmarkCreated;

  /// Optional custom path segments
  final List<String>? path;

  /// Optional callback when a path segment is tapped
  final Function(int index)? onPathSegmentTapped;

  /// Constructor for HeaderWidget
  const HeaderWidget({
    Key? key,
    this.filters = const [],
    required this.onAddFilter,
    required this.onBookmark,
    this.bookmarkManager,
    this.onBookmarkCreated,
    this.path,
    this.onPathSegmentTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb navigation that uses the current state or custom path
        path != null
            ? _buildCustomBreadcrumb(context)
            : _buildBreadcrumb(context),

        // Active filters display
        if (filters.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  filters
                      .map(
                        (filter) => Chip(
                          label: Text(
                            '${filter.attribute} ${filter.operator} ${filter.value}',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          backgroundColor: colorScheme.surfaceVariant,
                          onDeleted: () {
                            // Handle filter removal
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }

  /// Build a custom breadcrumb from string path
  Widget _buildCustomBreadcrumb(BuildContext context) {
    if (path == null || path!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            for (int i = 0; i < path!.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              InkWell(
                onTap:
                    onPathSegmentTapped != null
                        ? () => onPathSegmentTapped!(i)
                        : null,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    path![i],
                    style:
                        i == path!.length - 1
                            ? theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            )
                            : theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build the breadcrumb component using the current state
  Widget _buildBreadcrumb(BuildContext context) {
    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, domainState) {
        return BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
          builder: (context, modelState) {
            return BlocBuilder<ConceptSelectionBloc, ConceptSelectionState>(
              builder: (context, conceptState) {
                return BreadcrumbWidget(
                  domain: domainState.selectedDomain,
                  model: modelState.selectedModel,
                  concept: conceptState.selectedConcept,
                  entity:
                      conceptState.selectedEntities?.isNotEmpty == true
                          ? conceptState.selectedEntities!.first
                          : null,
                  bookmarkManager: bookmarkManager,
                  onBookmarkCreated: onBookmarkCreated,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Filter criteria for entity filtering
class FilterCriteria {
  /// Attribute name to filter on
  final String attribute;

  /// Operator for comparison
  final String operator;

  /// Value to compare against
  final String value;

  /// Constructor for FilterCriteria
  const FilterCriteria({
    required this.attribute,
    required this.operator,
    required this.value,
  });
}
