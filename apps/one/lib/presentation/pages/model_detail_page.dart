/*  */
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../widgets/layout/web/header_widget.dart';
import '../widgets/entity/entity_widget.dart';
import '../widgets/entity/entities_widget.dart';
import '../widgets/bookmarks/bookmark_manager.dart';
import '../widgets/semantic_concept_container.dart';
import '../theme/providers/theme_provider.dart';
import '../domain/domain_model_provider.dart';

/// Model detail page displaying concepts from a specific model
///
/// This page shows the detailed view of a model, including all its concepts,
/// and allows navigation to entity details.
class ModelDetailPage extends StatefulWidget {
  /// Route name for this page
  static const String routeName = '/model-detail';

  /// The domain containing the model
  final Domain domain;

  /// The model to display details for
  final Model model;

  /// Navigation path
  final List<String> path;

  /// Callback for when an entity is selected
  final void Function(Entity entity) onEntitySelected;

  /// Creates a model detail page
  const ModelDetailPage({
    super.key,
    required this.domain,
    required this.model,
    this.path = const ['Home'],
    this.onEntitySelected = _defaultEntityHandler,
  });

  static void _defaultEntityHandler(Entity entity) {
    // Default no-op handler
  }

  @override
  State<ModelDetailPage> createState() => _ModelDetailPageState();
}

class _ModelDetailPageState extends State<ModelDetailPage> {
  final ScrollController _entityListScrollController = ScrollController();

  @override
  void dispose() {
    _entityListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectivePath = [
      ...widget.path,
      widget.domain.code,
      widget.model.code,
    ];
    final bookmarkManager = Provider.of<BookmarkManager>(
      context,
      listen: false,
    );

    // Get the semantic concept type for the model
    final modelConceptType = context.conceptTypeForModel(widget.model);

    return SemanticConceptContainer(
      conceptType: modelConceptType,
      child: Scaffold(
        appBar: AppBar(
          title: HeaderWidget(
            path: effectivePath,
            onPathSegmentTapped: (index) {
              if (index == 0) {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else if (index < effectivePath.length - 1) {
                Navigator.pop(context);
              }
            },
            filters: [],
            onAddFilter: (header.FilterCriteria filter) {},
            onBookmark: () {},
          ),
        ),
        body: SemanticConceptContainer(
          conceptType: 'EntityList',
          fillHeight: true,
          scrollable: true,
          scrollController: _entityListScrollController,
          child: EntitiesWidget(
            entities: widget.model.concepts,
            onEntitySelected: (entity) {
              widget.onEntitySelected(entity);

              // Use the existing EntityDetailScreen for now
              // We'll migrate this in a future iteration
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntityDetailScreen(entity: entity),
                ),
              );
            },
            bookmarkManager: bookmarkManager,
            onBookmarkCreated: (bookmark) async {
              await bookmarkManager.addBookmark(bookmark);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bookmark added',
                      style: context.conceptTextStyle(
                        'Success',
                        role: 'message',
                      ),
                    ),
                    backgroundColor: context
                        .conceptColor('Success')
                        .withOpacity(0.2),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
