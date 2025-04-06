import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';

/// A component for selecting concepts in the application
///
/// Follows the Holy Trinity architecture by using semantic concept containers
/// and applying theme styling based on concept semantics.
class ConceptSelector extends StatefulWidget {
  /// Optional callback when a concept is selected
  final Function(Concept)? onConceptSelected;

  /// Title for the concept selector
  final String title;

  /// Empty state message when no concepts are available
  final String emptyMessage;

  /// Constructor for ConceptSelector
  const ConceptSelector({
    super.key,
    this.onConceptSelected,
    this.title = 'Concepts',
    this.emptyMessage = 'No Concepts Available',
  });

  @override
  State<ConceptSelector> createState() => _ConceptSelectorState();
}

class _ConceptSelectorState extends State<ConceptSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConceptSelectionBloc, ConceptSelectionState>(
      builder: (context, conceptState) {
        final availableConcepts = conceptState.availableConcepts;

        if (availableConcepts.isEmpty) {
          return SemanticConceptContainer(
            conceptType: 'ConceptSelectorEmpty',
            child: Text(
              widget.emptyMessage,
              style: context.conceptTextStyle('Concept', role: 'empty'),
            ),
          );
        }

        // Use LayoutBuilder to make responsive decisions
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we should use a compact layout
            final bool useCompactLayout = constraints.maxWidth < 600;

            return SemanticConceptContainer(
              conceptType: 'ConceptSelector',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title
                  _buildHeader(context),

                  // Search box
                  _buildSearchBox(context, conceptState),

                  // Choose between compact dropdown or full list view
                  useCompactLayout
                      ? _buildCompactSelector(context, conceptState)
                      : _buildConceptList(context, conceptState, constraints),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Build the header section with title
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.spacingS),
      child: Text(
        widget.title,
        style: context.conceptTextStyle('ConceptSelector', role: 'title'),
      ),
    );
  }

  /// Build the search box
  Widget _buildSearchBox(
    BuildContext context,
    ConceptSelectionState conceptState,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs,
      ),
      child: _SearchBox(
        onSearch: (query) {
          if (query.trim().isEmpty) {
            // If query is empty, reset to show all concepts
            context.read<ConceptSelectionBloc>().add(
              UpdateConceptsForModelEvent(conceptState.model!),
            );
          } else {
            // Filter concepts based on the query
            final filteredConcepts = Concepts();
            for (var concept in conceptState.availableConcepts) {
              if (concept.code.toLowerCase().contains(query.toLowerCase())) {
                filteredConcepts.add(concept);
              }
            }

            // Update the state with filtered concepts
            context.read<ConceptSelectionBloc>().updateConceptsDirectly(
              filteredConcepts,
            );
          }
        },
      ),
    );
  }

  /// Build a compact dropdown selector for narrow layouts
  Widget _buildCompactSelector(
    BuildContext context,
    ConceptSelectionState conceptState,
  ) {
    return Container(
      padding: EdgeInsets.all(context.spacingXs),
      margin: EdgeInsets.symmetric(horizontal: context.spacingM),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.conceptColor('Concept', role: 'border'),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<Concept>(
        value:
            conceptState.selectedConcept ??
            conceptState.availableConcepts.first,
        underline: const SizedBox.shrink(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: context.conceptColor('Concept'),
        ),
        isExpanded: true,
        onChanged: (Concept? newValue) {
          if (newValue != null) {
            NavigationHelper.navigateToConcept(context, newValue);

            if (widget.onConceptSelected != null) {
              widget.onConceptSelected!(newValue);
            }
          }
        },
        items:
            conceptState.availableConcepts.map((Concept concept) {
              return DropdownMenuItem<Concept>(
                value: concept,
                child: Row(
                  children: [
                    Icon(
                      concept.entry ? Icons.star : Icons.category,
                      size: 16,
                      color:
                          concept.entry
                              ? Colors.amber
                              : context.conceptColor('Concept', role: 'icon'),
                    ),
                    SizedBox(width: context.spacingXs),
                    Expanded(
                      child: Text(
                        concept.code,
                        style: context.conceptTextStyle(
                          'Concept',
                          role: 'title',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Build a scrollable list of concepts for wider layouts
  Widget _buildConceptList(
    BuildContext context,
    ConceptSelectionState conceptState,
    BoxConstraints constraints,
  ) {
    // Calculate appropriate list height
    final headersHeight = 100.0; // Combined height of header and search
    final availableHeight = constraints.maxHeight;
    final listHeight =
        availableHeight > headersHeight
            ? availableHeight - headersHeight
            : 200.0;

    return Container(
      height: listHeight.clamp(100.0, 250.0),
      padding: EdgeInsets.symmetric(horizontal: context.spacingS),
      child: SemanticConceptContainer(
        conceptType: 'ConceptList',
        scrollable: true,
        scrollController: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: conceptState.availableConcepts.length,
          itemBuilder: (context, index) {
            final concept = conceptState.availableConcepts.elementAt(index);
            final isSelected = concept == conceptState.selectedConcept;

            return _ConceptListItem(
              concept: concept,
              isSelected: isSelected,
              onTap: () {
                NavigationHelper.navigateToConcept(context, concept);

                if (widget.onConceptSelected != null) {
                  widget.onConceptSelected!(concept);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

/// Internal widget for rendering a concept list item
class _ConceptListItem extends StatelessWidget {
  final Concept concept;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConceptListItem({
    required this.concept,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEntryPoint = concept.entry;

    return SemanticConceptContainer(
      conceptType: 'Concept',
      child: ListTile(
        title: Text(
          concept.code,
          style: context.conceptTextStyle(
            'Concept',
            role: isSelected ? 'selected' : 'default',
          ),
        ),
        subtitle: Text(
          isEntryPoint
              ? 'Entry Point'
              : concept.parents.isNotEmpty
              ? 'Parents: ${concept.parents.map((p) => p.code).join(", ")}'
              : 'No parents',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.conceptTextStyle('Concept', role: 'description'),
        ),
        selected: isSelected,
        selectedTileColor: context
            .conceptColor('Concept', role: 'selectedBackground')
            .withValues(alpha: 51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onTap: onTap,
        leading: Icon(
          isEntryPoint ? Icons.star : Icons.category,
          color:
              isSelected
                  ? context.conceptColor('Concept', role: 'selected')
                  : isEntryPoint
                  ? Colors.amber
                  : context.conceptColor('Concept', role: 'icon'),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: context.conceptColor('Concept', role: 'selected'),
                )
                : null,
      ),
    );
  }
}

/// Search box for filtering concepts
class _SearchBox extends StatefulWidget {
  final Function(String) onSearch;

  const _SearchBox({required this.onSearch});

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'ConceptSearch',
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search concepts...',
          prefixIcon: Icon(
            Icons.search,
            color: context.conceptColor('ConceptSearch', role: 'icon'),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: context.conceptColor('ConceptSearch', role: 'border'),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: context.spacingXs),
          isDense: true,
          filled: true,
          fillColor: context.conceptColor('ConceptSearch', role: 'background'),
        ),
        onChanged: widget.onSearch,
      ),
    );
  }
}
