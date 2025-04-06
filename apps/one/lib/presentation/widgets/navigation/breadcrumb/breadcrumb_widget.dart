import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_manager.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_model.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_item.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_separator.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_path.dart';

/// A navigable breadcrumb trail for the application
class BreadcrumbWidget extends StatelessWidget {
  /// The current domain (if any)
  final Domain? domain;

  /// The current model (if any)
  final Model? model;

  /// The current concept (if any)
  final Concept? concept;

  /// The current entity (if any)
  final dynamic entity;

  /// Optional custom path segments to display
  final List<BreadcrumbSegment>? segments;

  /// Optional custom entity label
  final String? entityLabel;

  /// BookmarkManager for saving bookmarks
  final BookmarkManager? bookmarkManager;

  /// Callback when a segment is tapped
  final Function(BreadcrumbSegment segment)? onSegmentTapped;

  /// Callback when a bookmark is created
  final Function(Bookmark bookmark)? onBookmarkCreated;

  /// Constructor for BreadcrumbWidget
  const BreadcrumbWidget({
    super.key,
    this.domain,
    this.model,
    this.concept,
    this.entity,
    this.segments,
    this.entityLabel,
    this.bookmarkManager,
    this.onSegmentTapped,
    this.onBookmarkCreated,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided segments or create path from domain/model/concept/entity
    List<BreadcrumbSegment> breadcrumbPath;

    try {
      breadcrumbPath =
          segments ??
          BreadcrumbSegment.createPath(
            domain: domain,
            model: model,
            concept: concept,
            entity: entity,
            entityLabel: entityLabel ?? _getEntityLabel(entity),
          );

      // Validate each segment to ensure it has proper references
      breadcrumbPath =
          breadcrumbPath.where((segment) {
            switch (segment.type) {
              case BreadcrumbSegmentType.model:
                return segment.model?.domain != null;
              case BreadcrumbSegmentType.concept:
                return segment.concept?.model != null;
              case BreadcrumbSegmentType.entity:
                return segment.entity != null;
              default:
                return true;
            }
          }).toList();
    } catch (e) {
      debugPrint('Error creating breadcrumb path: $e');
      breadcrumbPath = [];
    }

    if (breadcrumbPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            minHeight: 48.0,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < breadcrumbPath.length; i++) ...[
                  if (i > 0) const BreadcrumbSeparator(),
                  _buildBreadcrumbItem(
                    context,
                    breadcrumbPath[i],
                    i == breadcrumbPath.length - 1,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build an individual breadcrumb item
  Widget _buildBreadcrumbItem(
    BuildContext context,
    BreadcrumbSegment segment,
    bool isLast,
  ) {
    return BreadcrumbItem(
      label: segment.label,
      isActive: isLast,
      showBookmarkButton: isLast,
      onTap: () {
        if (onSegmentTapped != null) {
          onSegmentTapped!(segment);
        } else {
          _handleNavigation(context, segment);
        }
      },
      onBookmark:
          isLast ? () => _bookmarkCurrentLocation(context, segment) : null,
    );
  }

  /// Handle navigation with proper state management
  void _handleNavigation(BuildContext context, BreadcrumbSegment segment) {
    try {
      switch (segment.type) {
        case BreadcrumbSegmentType.domain:
          if (segment.domain != null) {
            NavigationHelper.navigateToDomain(context, segment.domain!);
          }
          break;
        case BreadcrumbSegmentType.model:
          if (segment.model != null && segment.model?.domain != null) {
            NavigationHelper.navigateToModel(context, segment.model!);
          }
          break;
        case BreadcrumbSegmentType.concept:
          if (segment.concept != null && segment.concept?.model != null) {
            NavigationHelper.navigateToConcept(context, segment.concept!);
          }
          break;
        case BreadcrumbSegmentType.entity:
          // Entity navigation is typically handled by the specific page
          break;
        case BreadcrumbSegmentType.custom:
          // Custom navigation is handled by callbacks
          break;
      }
    } catch (e) {
      debugPrint('Error navigating to segment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error navigating to ${segment.label}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Bookmark the current location
  void _bookmarkCurrentLocation(
    BuildContext context,
    BreadcrumbSegment segment,
  ) {
    // Use the getter to get the full path string
    final path = breadcrumbPath;
    final bookmark = Bookmark(
      title: '${segment.label} (${segment.type.name})',
      url: path,
      category: BookmarkCategory.general,
    );

    if (bookmarkManager != null) {
      bookmarkManager!.addBookmark(bookmark);
    }

    if (onBookmarkCreated != null) {
      onBookmarkCreated!(bookmark);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmarked: ${segment.label}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Get a label for an entity
  String? _getEntityLabel(dynamic entity) {
    if (entity == null) return null;

    try {
      // Try common attribute names for entities
      final attributeNames = [
        'name',
        'title',
        'firstName',
        'lastName',
        'label',
        'id',
        'code',
        'description',
      ];

      for (final name in attributeNames) {
        try {
          final value = entity.getAttribute(name);
          if (value != null) {
            return value.toString();
          }
        } catch (_) {
          // Ignore if attribute doesn't exist
        }
      }

      // Fall back to toString if no known attributes
      return entity.toString();
    } catch (e) {
      debugPrint('Error getting entity label: $e');
      return 'Entity';
    }
  }

  /// Generate a URL-like path string for the current location
  String get breadcrumbPath {
    final pathSegments =
        segments ??
        BreadcrumbSegment.createPath(
          domain: domain,
          model: model,
          concept: concept,
          entity: entity,
          entityLabel: entityLabel ?? _getEntityLabel(entity),
        );

    return pathSegments.map((s) => s.label).join(' > ');
  }
}
