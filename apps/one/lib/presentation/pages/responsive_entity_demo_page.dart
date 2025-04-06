import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import '../widgets/entity/responsive_entity_container.dart';
import '../widgets/layout/responsive_semantic_wrapper.dart';

/// A demonstration page for showcasing responsive entity display
class ResponsiveEntityDemoPage extends StatefulWidget {
  /// The entity to display
  final ednet.Entity entity;

  /// Constructor for ResponsiveEntityDemoPage
  const ResponsiveEntityDemoPage({super.key, required this.entity});

  @override
  State<ResponsiveEntityDemoPage> createState() =>
      _ResponsiveEntityDemoPageState();
}

class _ResponsiveEntityDemoPageState extends State<ResponsiveEntityDemoPage> {
  ScreenSizeCategory _overrideScreenSize = ScreenSizeCategory.desktop;
  bool _useOverride = false;

  @override
  Widget build(BuildContext context) {
    final screenCategory =
        _useOverride
            ? _overrideScreenSize
            : ResponsiveSemanticWrapper.getScreenCategory(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.entity.concept.code} Details'),
        actions: [
          // Screen size override controls
          IconButton(
            icon: Icon(
              _useOverride ? Icons.screen_lock_rotation : Icons.screen_rotation,
            ),
            onPressed: () {
              setState(() {
                _useOverride = !_useOverride;
              });
            },
            tooltip: _useOverride ? 'Using size override' : 'Using actual size',
          ),
          if (_useOverride)
            PopupMenuButton<ScreenSizeCategory>(
              tooltip: 'Override screen size',
              icon: Icon(_getIconForScreenSize(_overrideScreenSize)),
              onSelected: (ScreenSizeCategory category) {
                setState(() {
                  _overrideScreenSize = category;
                });
              },
              itemBuilder: (BuildContext context) {
                return [
                  _buildScreenSizeMenuItem(
                    ScreenSizeCategory.mobile,
                    'Mobile (<600px)',
                    Icons.smartphone,
                  ),
                  _buildScreenSizeMenuItem(
                    ScreenSizeCategory.tablet,
                    'Tablet (600-1024px)',
                    Icons.tablet,
                  ),
                  _buildScreenSizeMenuItem(
                    ScreenSizeCategory.desktop,
                    'Desktop (1024-1920px)',
                    Icons.desktop_windows,
                  ),
                  _buildScreenSizeMenuItem(
                    ScreenSizeCategory.largeDesktop,
                    'Large Desktop (1920-3840px)',
                    Icons.desktop_mac,
                  ),
                  _buildScreenSizeMenuItem(
                    ScreenSizeCategory.ultraWide,
                    'Ultra Wide (3840px+)',
                    Icons.tv,
                  ),
                ];
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Current screen size indicator
          if (_useOverride)
            Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    _getIconForScreenSize(_overrideScreenSize),
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Simulating ${_getScreenSizeName(_overrideScreenSize)} display',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Screen size simulator (only when using override)
          if (_useOverride)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    width: _getSimulatedWidth(_overrideScreenSize),
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildEntityDisplay(),
                  ),
                ),
              ),
            )
          else
            // Regular display using actual screen size
            Expanded(child: _buildEntityDisplay()),
        ],
      ),
    );
  }

  /// Build the entity display content
  Widget _buildEntityDisplay() {
    return ResponsiveEntityContainer(
      entity: widget.entity,
      onAttributeEdit: (attributeCode, currentValue) {
        // Show a simple snackbar for demo purposes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Edit $attributeCode (currently: $currentValue)'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onRelationshipSelected: (relatedEntity) {
        // Show a simple snackbar for demo purposes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Selected related entity: ${relatedEntity.concept.code}',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  /// Build a menu item for screen size selection
  PopupMenuItem<ScreenSizeCategory> _buildScreenSizeMenuItem(
    ScreenSizeCategory category,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem<ScreenSizeCategory>(
      value: category,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color:
                _overrideScreenSize == category
                    ? Theme.of(context).colorScheme.primary
                    : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight:
                  _overrideScreenSize == category ? FontWeight.bold : null,
              color:
                  _overrideScreenSize == category
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Get icon for screen size category
  IconData _getIconForScreenSize(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return Icons.smartphone;
      case ScreenSizeCategory.tablet:
        return Icons.tablet;
      case ScreenSizeCategory.desktop:
        return Icons.desktop_windows;
      case ScreenSizeCategory.largeDesktop:
        return Icons.desktop_mac;
      case ScreenSizeCategory.ultraWide:
        return Icons.tv;
    }
  }

  /// Get name for screen size category
  String _getScreenSizeName(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return 'Mobile';
      case ScreenSizeCategory.tablet:
        return 'Tablet';
      case ScreenSizeCategory.desktop:
        return 'Desktop';
      case ScreenSizeCategory.largeDesktop:
        return 'Large Desktop';
      case ScreenSizeCategory.ultraWide:
        return 'Ultra Wide';
    }
  }

  /// Get simulated width for screen size category
  double _getSimulatedWidth(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return 360.0;
      case ScreenSizeCategory.tablet:
        return 768.0;
      case ScreenSizeCategory.desktop:
        return 1280.0;
      case ScreenSizeCategory.largeDesktop:
        return 1920.0;
      case ScreenSizeCategory.ultraWide:
        return 2560.0; // Scaled down for display purposes
    }
  }
}
