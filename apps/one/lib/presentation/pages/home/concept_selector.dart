import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';

/// A component for selecting concepts in the application
class ConceptSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<ConceptSelectionBloc, ConceptSelectionState>(
      builder: (context, conceptState) {
        final availableConcepts = conceptState.availableConcepts;

        if (availableConcepts.isEmpty) {
          return Center(
            child: Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),

            // Search box (optional)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: _SearchBox(
                onSearch: (query) {
                  // Actually implement the search functionality
                  if (query.trim().isEmpty) {
                    // If query is empty, reset to show all concepts
                    context.read<ConceptSelectionBloc>().add(
                      UpdateConceptsForModelEvent(conceptState.model!),
                    );
                  } else {
                    // Filter concepts based on the query
                    final filteredConcepts = Concepts();
                    for (var concept in conceptState.availableConcepts) {
                      if (concept.code.toLowerCase().contains(
                        query.toLowerCase(),
                      )) {
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
            ),

            // Concepts list
            Expanded(
              child: ListView.builder(
                controller: ScrollController(),
                itemCount: availableConcepts.length,
                itemBuilder: (context, index) {
                  final concept = availableConcepts.elementAt(index);
                  final isSelected = concept == conceptState.selectedConcept;

                  return _ConceptListItem(
                    concept: concept,
                    isSelected: isSelected,
                    onTap: () {
                      // Use the centralized navigation helper
                      NavigationHelper.navigateToConcept(context, concept);

                      // Call optional callback
                      if (onConceptSelected != null) {
                        onConceptSelected!(concept);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
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

    return ListTile(
      title: Text(
        concept.code,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onTap: onTap,
      leading: Icon(
        isEntryPoint ? Icons.star : Icons.category,
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : isEntryPoint
                ? Colors.amber
                : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      trailing:
          isSelected
              ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
              : null,
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
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search concepts...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: widget.onSearch,
    );
  }
}
