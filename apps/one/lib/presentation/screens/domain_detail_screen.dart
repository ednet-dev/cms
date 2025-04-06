import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../widgets/domain/models_widget.dart';
import '../widgets/layout/web/header_widget.dart';
import '../pages/model_detail_page.dart';
import '../pages/domain_detail_page.dart';

/// @deprecated Use DomainDetailPage instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use DomainDetailPage instead')
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
    // Use DomainDetailPage instead, keeping the same interface for backward compatibility
    return DomainDetailPage(domain: domain, onModelSelected: onModelSelected);
  }
}

// Old implementation kept for reference - will be removed in future
/*
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
          onAddFilter: (header.FilterCriteria filter) {},
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
                  (context) => ModelDetailPage(
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
*/
