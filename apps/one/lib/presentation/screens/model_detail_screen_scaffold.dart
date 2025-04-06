/*  */
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

import '../pages/model_detail_page.dart';

/// @deprecated Use ModelDetailPage instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use ModelDetailPage instead')
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
    // Use ModelDetailPage instead, keeping the same interface for backward compatibility
    return ModelDetailPage(
      domain: domain,
      model: model,
      path: path.length > 1 ? path.sublist(0, path.length - 2) : path,
      onEntitySelected: onEntitySelected,
    );
  }
}

// Old implementation kept for reference - will be removed in future
/*
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
*/
