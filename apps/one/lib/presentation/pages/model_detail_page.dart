/*  */
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../widgets/layout/web/header_widget.dart';
import '../widgets/entity/entity_widget.dart';
import '../widgets/entity/entities_widget.dart';
import '../widgets/bookmarks/bookmark_manager.dart';
import '../widgets/bookmarks/bookmark_model.dart';

/// Model detail page displaying concepts from a specific model
///
/// This page shows the detailed view of a model, including all its concepts,
/// and allows navigation to entity details.
class ModelDetailPage extends StatelessWidget {
  final Domain domain;
  final Model model;
  final List<String> path;
  final void Function(Entity entity) onEntitySelected;

  const ModelDetailPage({
    super.key,
    required this.domain,
    required this.model,
    this.path = const ['Home'],
    this.onEntitySelected = _defaultEntityHandler,
  });

  static void _defaultEntityHandler(Entity entity) {
    // Default no-op handler
  }

  @override
  Widget build(BuildContext context) {
    final effectivePath = [...path, domain.code, model.code];
    final bookmarkManager = Provider.of<BookmarkManager>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: effectivePath,
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index < effectivePath.length - 1) {
              Navigator.pop(context);
            }
          },
          filters: [],
          onAddFilter: (header.FilterCriteria filter) {},
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
              builder: (context) => EntityDetailScreen(entity: entity),
            ),
          );
        },
        bookmarkManager: bookmarkManager,
        onBookmarkCreated: (bookmark) async {
          await bookmarkManager.addBookmark(bookmark);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bookmark added'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
