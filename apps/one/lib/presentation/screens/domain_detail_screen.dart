import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/domain/entity_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/layout/web/header_widget.dart';

class DomainDetailScreen extends StatelessWidget {
  final Domain domain;
  final List<String> path;
  final void Function(Model model) onModelSelected;

  DomainDetailScreen({
    super.key,
    required this.domain,
    required this.onModelSelected,
  }) : path = ['Home', domain.code];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: path,
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index == 1) {
              Navigator.pop(context);
            }
          },
          filters: [],
          onAddFilter: (FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: ModelsWidget(
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
                    // path: path + [model.code],
                    // onEntitySelected: (entity) {
                    //   // Handle entity selection
                    // },
                  ),
            ),
          );
        },
      ),
    );
  }
}
