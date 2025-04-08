part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A button that opens a filter drawer when tapped
///
/// This component is part of the Shell Architecture UX Component Filters,
/// following the Message Filter enterprise integration pattern.
class FilterButton extends StatelessWidget with ProgressiveDisclosure {
  /// The currently active filter
  final FilterGroup? activeFilter;

  /// Callback when filter button is pressed
  final VoidCallback onPressed;

  /// Optional custom style for the filter button
  final FilterButtonStyle? style;

  /// Badge count to display on the button (active criteria count)
  final int? badgeCount;

  /// The disclosure level for this component
  @override
  final DisclosureLevel disclosureLevel;

  /// Constructor
  const FilterButton({
    super.key,
    this.activeFilter,
    required this.onPressed,
    this.style,
    this.badgeCount,
    this.disclosureLevel = DisclosureLevel.basic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? FilterButtonStyle.fromTheme(theme);

    // Determine if there's an active filter with criteria
    final hasActiveFilter =
        activeFilter != null && activeFilter!.hasActiveCriteria;

    // Get the badge count
    final effectiveBadgeCount = badgeCount ??
        (hasActiveFilter ? activeFilter!.activeCriteria.length : null);

    return IconButton(
      onPressed: onPressed,
      tooltip: hasActiveFilter
          ? 'Edit filters (${effectiveBadgeCount} active)'
          : 'Add filters',
      icon: Badge(
        isLabelVisible: effectiveBadgeCount != null && effectiveBadgeCount > 0,
        label:
            effectiveBadgeCount != null ? Text('$effectiveBadgeCount') : null,
        backgroundColor: effectiveStyle.badgeColor,
        child: Icon(
          hasActiveFilter
              ? effectiveStyle.activeFilterIcon
              : effectiveStyle.inactiveFilterIcon,
          color: hasActiveFilter
              ? effectiveStyle.activeColor
              : effectiveStyle.inactiveColor,
        ),
      ),
    );
  }
}

/// Style configuration for filter button
class FilterButtonStyle {
  /// Color for active filter
  final Color activeColor;

  /// Color for inactive filter
  final Color inactiveColor;

  /// Color for the badge
  final Color badgeColor;

  /// Icon for active filter
  final IconData activeFilterIcon;

  /// Icon for inactive filter
  final IconData inactiveFilterIcon;

  /// Constructor
  const FilterButtonStyle({
    required this.activeColor,
    required this.inactiveColor,
    required this.badgeColor,
    required this.activeFilterIcon,
    required this.inactiveFilterIcon,
  });

  /// Create a button style from theme
  factory FilterButtonStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return FilterButtonStyle(
      activeColor: colorScheme.primary,
      inactiveColor: colorScheme.onSurfaceVariant,
      badgeColor: colorScheme.primary,
      activeFilterIcon: Icons.filter_list_alt,
      inactiveFilterIcon: Icons.filter_list,
    );
  }
}
