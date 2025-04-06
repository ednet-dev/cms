import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class RightSidebarWidget extends StatelessWidget {
  final Models models;
  final void Function(Model model) onModelSelected;

  const RightSidebarWidget({super.key, 
    required this.models,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView.builder(
        itemCount: models.length,
        itemBuilder: (context, index) {
          final model = models.elementAt(index);
          return ListTile(
            title: Text(model.code),
            onTap: () => onModelSelected(model),
          );
        },
      ),
    );
  }
}
