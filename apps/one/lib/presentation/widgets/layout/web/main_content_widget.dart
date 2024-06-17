import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import 'layout_template.dart';

class MainContentWidget extends StatefulWidget {
  final Entities entities;

  MainContentWidget({super.key, required this.entities});

  @override
  State<MainContentWidget> createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<MainContentWidget> {
  Entity? selectedEntity;

  _handleEntitySelected(Entity entity) {
    selectedEntity = entity;
  }

  @override
  void initState() {
    super.initState();
    selectedEntity?.setAttribute('meniDosadno', 'Meni dosadno');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutTemplate(
        header: Text('Filters of its children?'),
        // list all entities with title
        leftSidebar: SingleChildScrollView(
          child: Column(
            children: widget.entities.map((entity) {
              return ListTile(
                title: Text(entity.id.toString()),
                onTap: () => _handleEntitySelected(entity as Entity),
              );
            }).toList(),
          ),
        ),
        mainContent: Center(
          child: Text(selectedEntity?.getAttribute('meniDosadno') ??
              'Select an entity'),
        ),
        footer: Text('actions'),
        rightSidebar: Text('Entity navigation?'));
  }
}
