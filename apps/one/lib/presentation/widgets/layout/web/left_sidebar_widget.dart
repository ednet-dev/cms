// left_sidebar_widget.dart
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class LeftSidebarWidget extends StatelessWidget {
  final Entities entries;
  final void Function(Entity entity) onEntitySelected;

  LeftSidebarWidget({
    required this.entries,
    required this.onEntitySelected,
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
            onTap: () => onEntitySelected(entity as Entity),
          );
        },
      ),
    );
  }
}
