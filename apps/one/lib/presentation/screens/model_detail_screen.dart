
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_cms/ednet_cms.dart';

import '../widgets/layout/web/header_widget.dart';

class ModelDetailScreen extends StatelessWidget {
  final Domain domain;
  final Model model;
  final List<String> path;
  final void Function(Entity entity) onEntitySelected;

  ModelDetailScreen({
    required this.domain,
    required this.model,
    required this.path,
    required this.onEntitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: path,
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index == 1) {
              Navigator.popUntil(context, ModalRoute.withName('/domain'));
            } else if (index == 2) {
              Navigator.pop(context);
            }
          },
          filters: [],
          onAddFilter: (FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: EntitiesWidget(
        entities: model.concepts,
        onEntitySelected: (entity) {
          onEntitySelected(entity);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityDetailScreen(
                entity: entity,
              ),
            ),
          );
        },
        bookmarkManager: BookmarkManager(),
        onBookmarkCreated: (Bookmark bookmark) {},
      ),
    );
  }
}
