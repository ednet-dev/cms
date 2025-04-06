import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;
import 'package:ednet_one/presentation/widgets/entity/entities_widget.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_manager.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_model.dart';
import 'package:ednet_one/presentation/widgets/entity/entity_widget.dart';

import '../widgets/layout/web/header_widget.dart';
import '../widgets/semantic_concept_container.dart';
import '../theme/providers/theme_provider.dart';
import '../domain/domain_model_provider.dart';

/// Entity detail page for displaying entities and their details
///
/// This page shows a list of entities and allows viewing their details
/// in a master-detail layout.
class EntityDetailPage extends StatefulWidget {
  /// Route name for this page
  static const String routeName = '/entities';

  /// The entities to display
  final Entities entities;

  /// The current domain, model, and concept names for navigation context
  final String domainName;
  final String modelName;
  final String conceptName;

  /// Creates an entity detail page
  const EntityDetailPage({
    super.key,
    required this.entities,
    required this.domainName,
    required this.modelName,
    required this.conceptName,
  });

  @override
  State<EntityDetailPage> createState() => _EntityDetailPageState();
}

class _EntityDetailPageState extends State<EntityDetailPage> {
  Object? _selectedEntity; // Use Object type to handle both Entity types
  final ScrollController _entityListScrollController = ScrollController();
  final ScrollController _entityDetailScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectInitialEntity();
  }

  @override
  void dispose() {
    _entityListScrollController.dispose();
    _entityDetailScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EntityDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entities != oldWidget.entities) {
      _selectInitialEntity();
    }
  }

  void _selectInitialEntity() {
    // Select the first entity by default, if available
    if (widget.entities.isNotEmpty) {
      setState(() {
        _selectedEntity = widget.entities.first;
      });
    } else {
      setState(() {
        _selectedEntity = null;
      });
    }
  }

  void _selectEntity(dynamic entity) {
    setState(() {
      _selectedEntity = entity;
    });
  }

  void _createBookmark(Bookmark bookmark) async {
    final bookmarkManager = Provider.of<BookmarkManager>(
      context,
      listen: false,
    );
    await bookmarkManager.addBookmark(bookmark);
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bookmark added',
            style: context.conceptTextStyle('Success', role: 'message'),
          ),
          backgroundColor: context.conceptColor('Success').withOpacity(0.2),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'EntityDetailPage',
      child: Scaffold(
        appBar: AppBar(
          title: HeaderWidget(
            path: [
              'Home',
              widget.domainName,
              widget.modelName,
              widget.conceptName,
              'Entities',
            ],
            onPathSegmentTapped: (index) {
              if (index == 0) {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else if (index == 1) {
                Navigator.popUntil(context, ModalRoute.withName('/domains'));
              } else if (index == 2) {
                Navigator.pop(context, 2);
              } else if (index == 3) {
                Navigator.pop(context);
              }
            },
            filters: [],
            onAddFilter: (header.FilterCriteria filter) {},
            onBookmark: () {
              if (_selectedEntity != null) {
                final bookmark = Bookmark(
                  title: 'Entity: ${_selectedEntity.toString()}',
                  url: '/entities/${_selectedEntity.toString()}',
                  category: BookmarkCategory.entity,
                  entity: _selectedEntity,
                );
                _createBookmark(bookmark);
              }
            },
          ),
        ),
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bookmarkManager = Provider.of<BookmarkManager>(
      context,
      listen: false,
    );

    // Handle empty entities case
    if (widget.entities.isEmpty) {
      return _buildEmptyStateMessage(context);
    }

    // Split view with entities list on left and selected entity details on right
    return SemanticConceptContainer(
      conceptType: 'MasterDetailView',
      fillHeight: true,
      child: Row(
        children: [
          // Entities list (1/3 of the space)
          Expanded(
            flex: 1,
            child: SemanticConceptContainer(
              conceptType: 'EntityList',
              fillHeight: true,
              scrollable: true,
              scrollController: _entityListScrollController,
              child: EntitiesWidget(
                entities: widget.entities,
                onEntitySelected: _selectEntity,
                bookmarkManager: bookmarkManager,
                onBookmarkCreated: (bookmark) => _createBookmark(bookmark),
              ),
            ),
          ),

          // Entity details (2/3 of the space)
          Expanded(
            flex: 2,
            child: SemanticConceptContainer(
              conceptType: 'EntityDetail',
              fillHeight: true,
              scrollable: true,
              scrollController: _entityDetailScrollController,
              child:
                  _selectedEntity != null
                      ? _buildEntityContent(_selectedEntity as dynamic)
                      : _buildNoEntitySelectedMessage(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityContent(dynamic entity) {
    try {
      return EntityWidget(
        entity: entity,
        onEntitySelected: _selectEntity,
        onBookmark: (title, url) {
          final bookmark = Bookmark(
            title: title,
            url: url,
            category: BookmarkCategory.entity,
            entity: entity,
          );
          _createBookmark(bookmark);
        },
      );
    } catch (e) {
      // If there's an error rendering the entity widget, show an error message
      return SemanticConceptContainer(
        conceptType: 'Error',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  context.conceptIcon('Error'),
                  color: context.conceptColor('Error'),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  "Entity Display Error",
                  style: context.conceptTextStyle('Error', role: 'title'),
                ),
                const SizedBox(height: 8),
                Text(
                  "Could not display this entity: ${e.toString().split("\n").first}",
                  style: context.conceptTextStyle('Error', role: 'description'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildEmptyStateMessage(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'EmptyState',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: context.conceptColor('EmptyState'),
            ),
            const SizedBox(height: 16),
            Text(
              'No Entities Available',
              style: context.conceptTextStyle('EmptyState', role: 'title'),
            ),
            const SizedBox(height: 8),
            Text(
              'This concept does not have any entities yet',
              style: context.conceptTextStyle(
                'EmptyState',
                role: 'description',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoEntitySelectedMessage(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'Prompt',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app_outlined,
              size: 64,
              color: context.conceptColor('Prompt'),
            ),
            const SizedBox(height: 16),
            Text(
              'No Entity Selected',
              style: context.conceptTextStyle('Prompt', role: 'title'),
            ),
            const SizedBox(height: 8),
            Text(
              'Select an entity from the list to view details',
              style: context.conceptTextStyle('Prompt', role: 'description'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
