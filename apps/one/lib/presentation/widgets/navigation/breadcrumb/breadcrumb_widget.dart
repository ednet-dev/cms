import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_manager.dart';
import 'package:ednet_one/presentation/widgets/bookmarks/bookmark_model.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_item.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_separator.dart';
import 'package:ednet_one/presentation/widgets/navigation/breadcrumb/breadcrumb_path.dart';
import 'dart:async';

/// A navigable breadcrumb trail for the application
class BreadcrumbWidget extends StatefulWidget {
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
  State<BreadcrumbWidget> createState() => _BreadcrumbWidgetState();
}

class _BreadcrumbWidgetState extends State<BreadcrumbWidget> {
  final ScrollController _scrollController = ScrollController();
  List<BreadcrumbSegment> _breadcrumbPath = [];
  bool _isInitialized = false;
  bool _isUpdating = false;
  Timer? _updateDebouncer;

  @override
  void initState() {
    super.initState();
    _scheduleUpdate();
  }

  @override
  void didUpdateWidget(BreadcrumbWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isUpdating && _shouldUpdatePath(oldWidget)) {
      _scheduleUpdate();
    }
  }

  @override
  void dispose() {
    _updateDebouncer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  bool _shouldUpdatePath(BreadcrumbWidget oldWidget) {
    return oldWidget.domain != widget.domain ||
        oldWidget.model != widget.model ||
        oldWidget.concept != widget.concept ||
        oldWidget.entity != widget.entity ||
        oldWidget.segments != widget.segments ||
        oldWidget.entityLabel != widget.entityLabel;
  }

  void _scheduleUpdate() {
    _updateDebouncer?.cancel();
    _updateDebouncer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) {
        _isUpdating = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateBreadcrumbPath();
            _isUpdating = false;
          }
        });
      }
    });
  }

  void _updateBreadcrumbPath() {
    if (!mounted) return;

    try {
      final newPath =
          widget.segments ??
          BreadcrumbSegment.createPath(
            domain: widget.domain,
            model: widget.model,
            concept: widget.concept,
            entity: widget.entity,
            entityLabel: widget.entityLabel ?? _getEntityLabel(widget.entity),
          );

      if (!mounted) return;

      final validatedPath =
          newPath.where((segment) {
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

      setState(() {
        _breadcrumbPath = validatedPath;
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error updating breadcrumb path: $e');
      if (!mounted) return;
      setState(() {
        _breadcrumbPath = [];
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SizedBox(
        height: 48.0,
        child: Center(
          child: Container(
            width: double.infinity,
            height: 48.0,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    }

    if (_breadcrumbPath.isEmpty) {
      return SizedBox(
        height: 48.0,
        child: Center(
          child: Container(
            width: double.infinity,
            height: 48.0,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    }

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            height: 48.0,
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
              minHeight: 48.0,
            ),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                physics: const NeverScrollableScrollPhysics(),
                dragDevices: const {},
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: MouseRegion(
                  cursor: SystemMouseCursors.basic,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _breadcrumbPath.length; i++) ...[
                          if (i > 0) const BreadcrumbSeparator(),
                          _buildBreadcrumbItem(
                            context,
                            _breadcrumbPath[i],
                            i == _breadcrumbPath.length - 1,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBreadcrumbItem(
    BuildContext context,
    BreadcrumbSegment segment,
    bool isLast,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: BreadcrumbItem(
        label: segment.label,
        isActive: isLast,
        showBookmarkButton: isLast && widget.bookmarkManager != null,
        onTap: () {
          if (!_isUpdating) {
            if (widget.onSegmentTapped != null) {
              widget.onSegmentTapped!(segment);
            } else {
              _handleNavigation(context, segment);
            }
          }
        },
        onBookmark:
            isLast && widget.bookmarkManager != null
                ? () => _bookmarkCurrentLocation(context, segment)
                : null,
      ),
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
    final path = _breadcrumbPath.map((s) => s.label).join(' > ');
    final bookmark = Bookmark(
      title: '${segment.label} (${segment.type.name})',
      url: path,
      category: BookmarkCategory.general,
    );

    if (widget.bookmarkManager != null) {
      widget.bookmarkManager!.addBookmark(bookmark);
    }

    if (widget.onBookmarkCreated != null) {
      widget.onBookmarkCreated!(bookmark);
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
    final pathSegments = _breadcrumbPath;
    return pathSegments.map((s) => s.label).join(' > ');
  }
}
