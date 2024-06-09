// left_sidebar_widget.dart
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
// left_sidebar_widget.dart

class LeftSidebarWidget extends StatelessWidget {
  final Entities items;
  final void Function(Entity entity)? onEntitySelected;
  final Domain? domain;
  final Model? model;

  const LeftSidebarWidget(
      {super.key,
      required this.items,
      this.onEntitySelected,
      required this.domain,
      required this.model});

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
          domain: this.domain!,
          model: model!,
        ),
      ),
    );
  }
}
