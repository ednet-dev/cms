// left_sidebar_widget.dart
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class LeftSidebarWidget extends StatelessWidget {
  final Entities items;
  final void Function(Entity entity) onEntitySelected;
  final Domain? domain;
  final Model? model;

  LeftSidebarWidget({
    Key? key,
    required this.items,
    required void Function(Entity entity) onEntitySelected,
    required this.domain,
    required this.model,
  })  : onEntitySelected = onEntitySelected ?? _defaultOnEntitySelected,
        super(key: key);

  static void _defaultOnEntitySelected(Entity entity) {
    print('Entity selected: ${entity.code}');
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Text('Model not provided.');
    }

    if (domain == null) {
      return Text('Domain not provided.');
    }
    return Container(
      width: 200,
      child: Center(
        child: EntitiesWidget(
          entities: this.items,
          onEntitySelected: onEntitySelected,
          bookmarkManager: BookmarkManager(),
          onBookmarkCreated: (Bookmark bookmark) {
            print('Bookmark created: ${bookmark.code}');
          },
        ),
      ),
    );
  }
}
