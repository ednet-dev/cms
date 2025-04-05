import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import 'model_detail_screen.dart';

class DomainDetailScreen extends StatelessWidget {
  final Domain domain;
  final List<String> path;
  final void Function(Model model) onModelSelected;

  const DomainDetailScreen({
    Key? key,
    required this.domain,
    required this.onModelSelected,
  }) : path = const ['Home'],
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domain: ${domain.code}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ModelsListWidget(
        models: domain.models,
        onModelSelected: (model) {
          onModelSelected(model);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ModelDetailScreen(
                    domain: domain,
                    model: model,
                    path: [...path, model.code],
                    onEntitySelected: (entity) {
                      // Handle entity selection
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EntityDetailScreen(entity: entity),
                        ),
                      );
                    },
                  ),
            ),
          );
        },
      ),
    );
  }
}

class ModelsListWidget extends StatelessWidget {
  final Iterable<Model> models;
  final Function(Model) onModelSelected;

  const ModelsListWidget({
    Key? key,
    required this.models,
    required this.onModelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modelsList = models.toList();

    return ListView.builder(
      itemCount: modelsList.length,
      itemBuilder: (context, index) {
        final model = modelsList[index];
        return ListTile(
          title: Text(model.code),
          subtitle: Text('Concepts: ${model.concepts.length}'),
          onTap: () => onModelSelected(model),
        );
      },
    );
  }
}
