part of ednet_core_flutter;

/// A UI component for displaying and selecting layout algorithms.
///
/// This widget is used to provide a visual UI for selecting different
/// layout algorithms in the domain model visualization canvas.
///
/// This component is part of the EDNet Shell Architecture visualization system.
class LayoutAlgorithmIcon extends StatelessWidget {
  /// The icon representing this layout algorithm
  final IconData icon;

  /// The display name of this layout algorithm
  final String name;

  /// Called when this layout algorithm is selected
  final VoidCallback onTap;

  /// Whether this layout algorithm is currently active
  final bool isActive;

  /// The disclosure level to display this icon at
  final DisclosureLevel disclosureLevel;

  /// Constructor for LayoutAlgorithmIcon
  const LayoutAlgorithmIcon({
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
    this.isActive = false,
    this.disclosureLevel = DisclosureLevel.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get colors based on active state and theme
    final backgroundColor = isActive
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;

    final foregroundColor = isActive
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    // Container size based on disclosure level
    double size;
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        size = 36.0;
        break;
      case DisclosureLevel.standard:
        size = 48.0;
        break;
      case DisclosureLevel.advanced:
      case DisclosureLevel.complete:
        size = 56.0;
        break;
      default:
        size = 48.0;
    }

    return Tooltip(
      message: name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              color: foregroundColor,
              size: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
