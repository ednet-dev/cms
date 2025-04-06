import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/widgets/entity/entities_widget.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_manager.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_model.dart';
import 'package:ednet_one/presentation/widgets/entity/entity_widget.dart';

/// A page that displays a list of entities and their details in a master-detail layout.
/// This is the modern replacement for MainContentWidget.
class EntityDetailPage extends StatefulWidget {
  final Entities entities;

  /// Constructor for EntityDetailPage
  const EntityDetailPage({super.key, required this.entities});

  @override
  State<EntityDetailPage> createState() => _EntityDetailPageState();
}

class _EntityDetailPageState extends State<EntityDetailPage> {
  Object? _selectedEntity;

  @override
  void initState() {
    super.initState();
    _selectInitialEntity();
  }

  @override
  void didUpdateWidget(EntityDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entities != oldWidget.entities) {
      _selectInitialEntity();
    }
  }

  void _selectInitialEntity() {
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark added'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final bookmarkManager = Provider.of<BookmarkManager>(
      context,
      listen: false,
    );

    if (widget.entities.isEmpty) {
      return _buildEmptyStateMessage(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.33, // 1/3 of available width
              child: EntitiesWidget(
                entities: widget.entities,
                onEntitySelected: _selectEntity,
                bookmarkManager: bookmarkManager,
                onBookmarkCreated: (bookmark) => _createBookmark(bookmark),
              ),
            ),
            Container(
              width: constraints.maxWidth * 0.67, // 2/3 of available width
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxHeight: constraints.maxHeight,
              ),
              child:
                  _selectedEntity != null
                      ? _buildEntityContent(_selectedEntity as dynamic)
                      : _buildNoEntitySelectedMessage(context),
            ),
          ],
        );
      },
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
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Entity Display Error",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Could not display this entity: ${e.toString().split("\n").first}",
                  style: Theme.of(context).textTheme.bodyMedium,
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
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 255.0 * 0.5),
          ),
          const SizedBox(height: 16),
          Text('No Entities Available', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'This concept does not have any entities yet',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoEntitySelectedMessage(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 255.0 * 0.5),
          ),
          const SizedBox(height: 16),
          Text('No Entity Selected', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Select an entity from the list to view details',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
