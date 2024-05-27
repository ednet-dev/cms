// main_content_widget.dart
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class MainContentWidget extends StatelessWidget {
  final Entity entity;
  final void Function(Entity entity)? onEntitySelected;

  const MainContentWidget(
      {super.key, required this.entity, this.onEntitySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: EntityWidget(
          entity: entity,
          onEntitySelected: onEntitySelected,
        ),
      ),
    );
  }
}
