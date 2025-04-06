import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/widgets/entity/entities_widget.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_manager.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_model.dart';
import 'package:ednet_one/presentation/widgets/entity/entity_widget.dart';

/// Widget for displaying the main content of the application
class MainContentWidget extends StatefulWidget {
  /// The entities to display
  final Entities entities;

  /// Constructor for MainContentWidget
  const MainContentWidget({super.key, required this.entities});

  @override
  State<MainContentWidget> createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<MainContentWidget> {
  Object? _selectedEntity; // Use Object type to handle both Entity types

  @override
  void initState() {
    super.initState();
    _selectInitialEntity();
  }

  @override
  void didUpdateWidget(MainContentWidget oldWidget) {
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

    // Handle empty entities case
    if (widget.entities.isEmpty) {
      return _buildEmptyStateMessage(context);
    }

    // Split view with entities list on left and selected entity details on right
    return Row(
      children: [
        // Entities list (1/3 of the space)
        Expanded(
          flex: 1,
          child: EntitiesWidget(
            entities: widget.entities,
            onEntitySelected: _selectEntity,
            bookmarkManager: bookmarkManager,
            onBookmarkCreated: (bookmark) => _createBookmark(bookmark),
          ),
        ),

        // Entity details (2/3 of the space)
        Expanded(
          flex: 2,
          child:
              _selectedEntity != null
                  ? _buildEntityContent(_selectedEntity as dynamic)
                  : _buildNoEntitySelectedMessage(context),
        ),
      ],
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
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
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
            color: theme.colorScheme.primary.withOpacity(0.5),
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
            color: theme.colorScheme.primary.withOpacity(0.5),
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
