import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

/// Widget for displaying entries in a sidebar
///
/// This component renders a scrollable list of entries (typically concepts or entities)
/// in a fixed-width sidebar container.
class SidebarEntriesWidget extends StatelessWidget {
  /// The entries to display in the sidebar
  final dynamic entries;

  /// Optional callback for when an entry is selected
  final Function(dynamic entity)? onEntrySelected;

  const SidebarEntriesWidget({
    super.key,
    required this.entries,
    this.onEntrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entity = entries.elementAt(index);
          return ListTile(
            title: Text(entity.code),
            onTap: () {
              if (onEntrySelected != null) {
                onEntrySelected!(entity);
              }
            },
          );
        },
      ),
    );
  }
}
