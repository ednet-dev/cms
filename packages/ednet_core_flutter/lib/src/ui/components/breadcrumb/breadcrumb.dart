part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Represents a single breadcrumb item in a navigation path
class BreadcrumbItem {
  /// The label to display for this breadcrumb
  final String label;

  /// The icon to display (optional)
  final IconData? icon;

  /// The destination this breadcrumb points to
  final String destination;

  /// Additional metadata for this breadcrumb
  final Map<String, dynamic>? metadata;

  /// Whether this breadcrumb is the current active one
  final bool isActive;

  /// Creates a breadcrumb item
  const BreadcrumbItem({
    required this.label,
    required this.destination,
    this.icon,
    this.metadata,
    this.isActive = false,
  });

  /// Creates a copy of this breadcrumb item with specified properties changed
  BreadcrumbItem copyWith({
    String? label,
    IconData? icon,
    String? destination,
    Map<String, dynamic>? metadata,
    bool? isActive,
  }) {
    return BreadcrumbItem(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      destination: destination ?? this.destination,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// A breadcrumb navigation component that shows the current location in a navigation hierarchy
///
/// The Breadcrumb component adapts to the current disclosure level by showing
/// more or less detail based on the level.
class Breadcrumb extends StatelessWidget with ProgressiveDisclosure {
  /// The list of breadcrumb items to display
  final List<BreadcrumbItem> items;

  /// The separator to display between breadcrumb items
  final Widget? separator;

  /// Callback for when a breadcrumb item is tapped
  final void Function(BreadcrumbItem item)? onItemTap;

  /// Style of the breadcrumb
  final BreadcrumbStyle? style;

  /// Maximum number of items to show (will collapse others if there are more)
  final int? maxItems;

  /// The disclosure level to use for this component
  @override
  final DisclosureLevel disclosureLevel;

  /// Creates a breadcrumb navigation component
  const Breadcrumb({
    Key? key,
    required this.items,
    this.separator,
    this.onItemTap,
    this.style,
    this.maxItems,
    DisclosureLevel? disclosureLevel,
  })  : disclosureLevel = disclosureLevel ?? DisclosureLevel.standard,
        super(key: key);

  /// Gets the effective disclosure level, considering both local and theme-based settings
  DisclosureLevel getEffectiveDisclosureLevel(BuildContext context) {
    // Use the locally set disclosure level (this.disclosureLevel)
    // In a more advanced implementation, we'd look up disclosure level from theme or context
    return disclosureLevel;
  }

  @override
  Widget build(BuildContext context) {
    // Determine the effective disclosure level
    final effectiveLevel = getEffectiveDisclosureLevel(context);

    // Determine theme and styles
    final theme = Theme.of(context);
    final effectiveStyle = style ?? BreadcrumbStyle.fromTheme(theme);

    // Determine how many items to show based on disclosure level
    final effectiveMaxItems =
        _getMaxItemsForDisclosureLevel(effectiveLevel, maxItems);
    final displayItems = _getDisplayItems(items, effectiveMaxItems);

    // Build the breadcrumb based on disclosure level
    return Container(
      padding: effectiveStyle.padding,
      decoration: effectiveStyle.decoration,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildBreadcrumbItems(
            context,
            displayItems,
            effectiveStyle,
            effectiveLevel,
          ),
        ),
      ),
    );
  }

  /// Builds the list of breadcrumb item widgets
  List<Widget> _buildBreadcrumbItems(
    BuildContext context,
    List<BreadcrumbItem> displayItems,
    BreadcrumbStyle style,
    DisclosureLevel level,
  ) {
    final result = <Widget>[];
    final effectiveSeparator =
        separator ?? _getDefaultSeparator(context, style);

    for (var i = 0; i < displayItems.length; i++) {
      final item = displayItems[i];

      // Add the item
      result.add(
        _buildBreadcrumbItem(context, item, style, level),
      );

      // Add a separator if this isn't the last item
      if (i < displayItems.length - 1) {
        result.add(effectiveSeparator);
      }
    }

    return result;
  }

  /// Builds a single breadcrumb item
  Widget _buildBreadcrumbItem(
    BuildContext context,
    BreadcrumbItem item,
    BreadcrumbStyle style,
    DisclosureLevel level,
  ) {
    final isCollapsed = item.label == '...';
    final isActive = item.isActive;

    // Select the appropriate text style based on state
    TextStyle textStyle;
    if (isActive) {
      textStyle = style.activeTextStyle;
    } else if (isCollapsed) {
      textStyle = style.collapsedTextStyle;
    } else {
      textStyle = style.textStyle;
    }

    // Only show icons at higher disclosure levels
    final showIcon = item.icon != null &&
        (level.isAtLeast(DisclosureLevel.intermediate) || isActive);

    return InkWell(
      onTap: isCollapsed ? null : () => onItemTap?.call(item),
      borderRadius: style.itemBorderRadius,
      child: Container(
        padding: style.itemPadding,
        decoration:
            isActive ? style.activeItemDecoration : style.itemDecoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                item.icon,
                size: style.iconSize,
                color: isActive ? style.activeIconColor : style.iconColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              item.label,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the default separator
  Widget _getDefaultSeparator(BuildContext context, BreadcrumbStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        Icons.chevron_right,
        size: style.separatorSize,
        color: style.separatorColor,
      ),
    );
  }

  /// Gets the maximum number of items to display based on disclosure level
  int _getMaxItemsForDisclosureLevel(
      DisclosureLevel level, int? userDefinedMax) {
    // User-defined max takes precedence if specified
    if (userDefinedMax != null) {
      return userDefinedMax;
    }

    // Otherwise, determine based on disclosure level
    switch (level) {
      case DisclosureLevel.minimal:
        return 2; // Just show home + current
      case DisclosureLevel.basic:
        return 3; // Show a bit more context
      case DisclosureLevel.standard:
        return 4; // Standard number of items
      case DisclosureLevel.intermediate:
        return 5; // More context for intermediate users
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        return 10; // Show full path for advanced users
    }
  }

  /// Gets the list of items to display, collapsing items in the middle if needed
  List<BreadcrumbItem> _getDisplayItems(
      List<BreadcrumbItem> allItems, int maxItems) {
    if (allItems.length <= maxItems || maxItems >= allItems.length) {
      return allItems;
    }

    // We need to collapse some items
    final result = <BreadcrumbItem>[];

    // Always show the first item (home)
    result.add(allItems.first);

    // Add collapsed indicator
    result.add(
      const BreadcrumbItem(
        label: '...',
        destination: '',
      ),
    );

    // Calculate how many end items to show
    final endItemsToShow =
        maxItems - 2; // Subtract home and collapsed indicator

    // Add the last 'endItemsToShow' items
    result.addAll(
      allItems.skip(allItems.length - endItemsToShow).take(endItemsToShow),
    );

    return result;
  }
}

/// Defines the visual styles for the breadcrumb component
class BreadcrumbStyle {
  /// Text style for regular breadcrumb items
  final TextStyle textStyle;

  /// Text style for the active breadcrumb item
  final TextStyle activeTextStyle;

  /// Text style for the collapsed indicator
  final TextStyle collapsedTextStyle;

  /// Color for icons in regular items
  final Color iconColor;

  /// Color for icons in the active item
  final Color activeIconColor;

  /// Size for icons
  final double iconSize;

  /// Color for the separator
  final Color separatorColor;

  /// Size for the separator
  final double separatorSize;

  /// Padding for the entire breadcrumb
  final EdgeInsetsGeometry padding;

  /// Padding for individual items
  final EdgeInsetsGeometry itemPadding;

  /// Border radius for individual items
  final BorderRadius itemBorderRadius;

  /// Decoration for the entire breadcrumb
  final Decoration? decoration;

  /// Decoration for regular items
  final Decoration? itemDecoration;

  /// Decoration for the active item
  final Decoration? activeItemDecoration;

  /// Creates a breadcrumb style
  const BreadcrumbStyle({
    required this.textStyle,
    required this.activeTextStyle,
    required this.collapsedTextStyle,
    required this.iconColor,
    required this.activeIconColor,
    required this.iconSize,
    required this.separatorColor,
    required this.separatorSize,
    required this.padding,
    required this.itemPadding,
    required this.itemBorderRadius,
    this.decoration,
    this.itemDecoration,
    this.activeItemDecoration,
  });

  /// Creates a breadcrumb style from the current theme
  factory BreadcrumbStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return BreadcrumbStyle(
      textStyle: theme.textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 204), // ~0.8 opacity
      ),
      activeTextStyle: theme.textTheme.bodyMedium!.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      collapsedTextStyle: theme.textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 128), // ~0.5 opacity
      ),
      iconColor: colorScheme.onSurface.withValues(alpha: 204), // ~0.8 opacity
      activeIconColor: colorScheme.primary,
      iconSize: 16.0,
      separatorColor:
          colorScheme.onSurface.withValues(alpha: 128), // ~0.5 opacity
      separatorSize: 16.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      itemPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      itemBorderRadius: BorderRadius.circular(4.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4.0),
      ),
      itemDecoration: null,
      activeItemDecoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 26), // ~0.1 opacity
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  /// Creates a copy of this style with specified properties changed
  BreadcrumbStyle copyWith({
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
    TextStyle? collapsedTextStyle,
    Color? iconColor,
    Color? activeIconColor,
    double? iconSize,
    Color? separatorColor,
    double? separatorSize,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? itemPadding,
    BorderRadius? itemBorderRadius,
    Decoration? decoration,
    Decoration? itemDecoration,
    Decoration? activeItemDecoration,
  }) {
    return BreadcrumbStyle(
      textStyle: textStyle ?? this.textStyle,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      collapsedTextStyle: collapsedTextStyle ?? this.collapsedTextStyle,
      iconColor: iconColor ?? this.iconColor,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      iconSize: iconSize ?? this.iconSize,
      separatorColor: separatorColor ?? this.separatorColor,
      separatorSize: separatorSize ?? this.separatorSize,
      padding: padding ?? this.padding,
      itemPadding: itemPadding ?? this.itemPadding,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      decoration: decoration ?? this.decoration,
      itemDecoration: itemDecoration ?? this.itemDecoration,
      activeItemDecoration: activeItemDecoration ?? this.activeItemDecoration,
    );
  }
}
