// left_sidebar_widget.dart
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class LeftSidebarWidget extends StatelessWidget {
  final Concepts entries;
  final void Function(Concept concept) onConceptSelected;

  const LeftSidebarWidget({super.key, 
    required this.entries,
    required this.onConceptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final concept = entries.elementAt(index);
          return ListTile(
            title: Text(concept.code),
            onTap: () => onConceptSelected(concept),
          );
        },
      ),
    );
  }
}
