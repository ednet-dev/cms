// left_sidebar_widget.dart
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import '../../../pages/concepts_page.dart';

/// @deprecated Use ConceptsPage or ConceptsListWidget instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use ConceptsPage or ConceptsListWidget instead')
class LeftSidebarWidget extends StatelessWidget {
  final Concepts entries;
  final void Function(Concept concept) onConceptSelected;

  const LeftSidebarWidget({
    super.key,
    required this.entries,
    required this.onConceptSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Delegate to the new implementation while maintaining the same interface
    return SizedBox(
      width: 200,
      child: ConceptsListWidget(
        concepts: entries,
        onConceptSelected: onConceptSelected,
      ),
    );
  }
}
