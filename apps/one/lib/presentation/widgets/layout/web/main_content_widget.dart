import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/entity/entity_widget.dart';
import 'package:flutter/material.dart';

import 'layout_template.dart';

class MainContentWidget extends StatefulWidget {
  final Entities entities;

  const MainContentWidget({super.key, required this.entities});

  @override
  State<MainContentWidget> createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<MainContentWidget> {
  Entity? selectedEntity;

  _handleEntitySelected(Entity entity) {
    setState(() {
      selectedEntity = entity;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedEntity = widget.entities.first as Entity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutTemplate(
      header: Text('Filters of its children?'),
      // list all entities with title
      leftSidebar: Column(
        children:
            widget.entities.toList().map((entity) {
              return ListTile(
                title: Text(EntityTitleUtils.getTitle(entity as Entity)),
                onTap: () => _handleEntitySelected(entity),
              );
            }).toList(),
      ),
      mainContent: Center(
        child:
            selectedEntity != null
                ? EntityWidget(entity: selectedEntity as Entity)
                : Text('Select an entity'),
      ),
      footer: Text('actions'),
      rightSidebar: Text('Entity navigation?'),
    );
  }
}
