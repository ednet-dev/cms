import 'package:flutter/material.dart';
import '../widgets/layout/model_pin_manager_dialog.dart';

class ModelPage extends StatefulWidget {
  final dynamic model; // Replace with proper model type when available
  static const String routeName = '/model';

  const ModelPage({super.key, required this.model});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    return Scaffold(
      appBar: AppBar(
        title: Text(model.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin),
            tooltip: 'Manage Pinned Items',
            onPressed: () {
              ModelPinManagerDialog.show(
                context,
                model.code,
                title: 'Pinned Items for ${model.code} Model',
              );
            },
          ),
        ],
      ),
      body: Center(child: Text('Model details for ${model.code}')),
    );
  }
}
