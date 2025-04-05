import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

// Simple implementation of required components
class EntityDetailScreen extends StatelessWidget {
  final Entity entity;

  const EntityDetailScreen({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entity: ${entity.code}')),
      body: Center(child: Text('Entity details for ${entity.code}')),
    );
  }
}

class ModelDetailScreen extends StatelessWidget {
  final Domain domain;
  final Model model;
  final List<String> path;
  final void Function(Entity entity) onEntitySelected;

  ModelDetailScreen({
    Key? key,
    required this.domain,
    required this.model,
    required this.path,
    required this.onEntitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model: ${model.code}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: EntitiesListWidget(
        entities: model.concepts,
        onEntitySelected: onEntitySelected,
      ),
    );
  }
}

class EntitiesListWidget extends StatelessWidget {
  final Entities entities;
  final Function(Entity) onEntitySelected;

  const EntitiesListWidget({
    Key? key,
    required this.entities,
    required this.onEntitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final dynamic entity = entities.toList()[index];
        return ListTile(
          title: Text(entity.code),
          subtitle: Text('Type: ${entity.runtimeType}'),
          onTap: () => onEntitySelected(entity),
        );
      },
    );
  }
}
