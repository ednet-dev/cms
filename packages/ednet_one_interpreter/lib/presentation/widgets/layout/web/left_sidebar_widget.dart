import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

/// A widget that displays entry concepts in the left sidebar.
///
/// This widget shows entry concepts (roots) from a model and allows
/// the user to select them for further exploration.
class LeftSidebarWidget extends StatelessWidget {
  /// The entry concepts to display
  final Concepts entries;

  /// Callback when a concept is selected
  final Function(Concept) onConceptSelected;

  /// Creates a new left sidebar widget.
  const LeftSidebarWidget({
    Key? key,
    required this.entries,
    required this.onConceptSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            width: double.infinity,
            child: Text(
              'Entry Concepts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child:
                entries.isEmpty
                    ? const Center(child: Text('No entries'))
                    : _buildEntryList(),
          ),
        ],
      ),
    );
  }

  /// Builds the list of entry concepts.
  Widget _buildEntryList() {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final concept = entries.toList()[index];
        return _buildConceptTile(context, concept);
      },
    );
  }

  /// Builds a tile for a single concept.
  Widget _buildConceptTile(BuildContext context, Concept concept) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Text(concept.code),
        subtitle: Text(concept.label ?? 'Entry Concept'),
        leading: const Icon(Icons.data_object),
        trailing: Text(
          '${concept.attributes.length} attributes',
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () => onConceptSelected(concept),
      ),
    );
  }
}
