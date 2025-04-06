import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/entity/bookmark_manager.dart';
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
    Key? key,
    this.domain,
    this.model,
    this.concept,
    this.entity,
    this.segments,
    this.entityLabel,
    this.bookmarkManager,
    this.onSegmentTapped,
    this.onBookmarkCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use provided segments or create path from domain/model/concept/entity
    final breadcrumbPath =
        segments ??
        BreadcrumbSegment.createPath(
          domain: domain,
          model: model,
          concept: concept,
          entity: entity,
          entityLabel: entityLabel ?? _getEntityLabel(entity),
        );

    if (breadcrumbPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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

  /// Navigate to the selected segment
  void _handleNavigation(BuildContext context, BreadcrumbSegment segment) {
    switch (segment.type) {
      case BreadcrumbSegmentType.domain:
        if (segment.domain != null) {
          NavigationHelper.navigateToDomain(context, segment.domain!);
        }
        break;
      case BreadcrumbSegmentType.model:
        if (segment.model != null) {
          NavigationHelper.navigateToModel(context, segment.model!);
        }
        break;
      case BreadcrumbSegmentType.concept:
        if (segment.concept != null) {
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
