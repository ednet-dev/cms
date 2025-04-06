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

class ModelDetailScreenScaffold extends StatelessWidget {
  final Domain domain;
  final Model model;
  final List<String> path;
  final void Function(Entity entity) onEntitySelected;

  const ModelDetailScreenScaffold({
    super.key,
    required this.domain,
    required this.model,
    required this.path,
    required this.onEntitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = Provider.of<BookmarkManager>(
      context,
      listen: false,
    );

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
