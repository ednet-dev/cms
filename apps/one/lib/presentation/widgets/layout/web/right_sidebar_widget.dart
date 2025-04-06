import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import '../../../pages/models_page.dart';

/// @deprecated Use ModelsPage or ModelsListWidget instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use ModelsPage or ModelsListWidget instead')
class RightSidebarWidget extends StatelessWidget {
  final Models models;
  final void Function(Model model) onModelSelected;

  const RightSidebarWidget({
    super.key,
    required this.models,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Delegate to the new implementation while maintaining the same interface
    return SizedBox(
      width: 200,
      child: ModelsListWidget(models: models, onModelSelected: onModelSelected),
    );
  }
}
