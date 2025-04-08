import 'package:flutter/material.dart';
import '../../theme/providers/theme_provider.dart';
import '../../theme/extensions/theme_spacing.dart';

/// A visually enhanced card with modern styling, animations, and color accents
class EnhancedCard extends StatefulWidget {
  /// The content of the card
  final Widget child;

  /// Optional accent color for the card
  final Color? accentColor;

  /// Optional header widget displayed at the top of the card
  final Widget? header;

  /// Optional footer widget displayed at the bottom of the card
  final Widget? footer;

  /// Optional badge text to display in the top-right corner
  final String? badgeText;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Optional icon to display in the top-left
  final IconData? leadingIcon;

  /// Controls the card elevation
  final double elevation;

  /// Optional concept type to use for theming
  final String? conceptType;

  /// Optional role within the concept for more specific styling
  final String? role;

  /// Border radius of the card
  final double borderRadius;

  /// Controls if the card should have hover animation
  final bool enableHoverEffect;

  /// Indicates if this card represents an aggregate root
  final bool isAggregateRoot;

  /// Indicates if this card represents a domain concept
  final bool isConcept;

  /// Optional importance level (0-1) to control visual prominence
  final double importance;

  /// Creates an enhanced card with modern styling
  const EnhancedCard({
    super.key,
    required this.child,
    this.accentColor,
    this.header,
    this.footer,
    this.badgeText,
    this.onTap,
    this.leadingIcon,
    this.elevation = 2.0,
    this.conceptType,
    this.role,
    this.borderRadius = 12.0,
    this.enableHoverEffect = true,
    this.isAggregateRoot = false,
    this.isConcept = false,
    this.importance = 0.5,
  });

  @override
  State<EnhancedCard> createState() => _EnhancedCardState();
}

class _EnhancedCardState extends State<EnhancedCard>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 4.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on theme and props
    final Color baseColor = Theme.of(context).cardColor;
    Color accent =
        widget.accentColor ??
        (widget.conceptType != null
            ? context.conceptColor(widget.conceptType!, role: widget.role)
            : Theme.of(context).colorScheme.primary);

    // Special handling for aggregate roots and concepts
    if (widget.isAggregateRoot) {
      accent = context.conceptColor('AggregateRoot');
    } else if (widget.isConcept) {
      accent = context.conceptColor('Concept');
    }

    // Adjust opacity based on importance
    final borderOpacity = _isHovering ? 0.8 : (0.3 + (widget.importance * 0.5));

    // Build the card with animations
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableHoverEffect ? _scaleAnimation.value : 1.0,
          child: MouseRegion(
            onEnter: (_) {
              if (widget.enableHoverEffect) {
                setState(() => _isHovering = true);
                _animationController.forward();
              }
            },
            onExit: (_) {
              if (widget.enableHoverEffect) {
                setState(() => _isHovering = false);
                _animationController.reverse();
              }
            },
            child: GestureDetector(
              onTap: widget.onTap,
              child: Card(
                elevation:
                    widget.enableHoverEffect
                        ? _elevationAnimation.value
                        : widget.elevation,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  side: BorderSide(
                    color:
                        _isHovering
                            ? accent
                            : accent.withOpacity(
                              widget.isAggregateRoot || widget.isConcept
                                  ? borderOpacity
                                  : 0.0,
                            ),
                    width: widget.isAggregateRoot ? 2.0 : 1.0,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: _buildGradient(baseColor, accent),
                    boxShadow:
                        _isHovering
                            ? [
                              BoxShadow(
                                color: accent.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Special indicator for aggregate roots
                      if (widget.isAggregateRoot)
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(widget.borderRadius - 1),
                              topRight: Radius.circular(
                                widget.borderRadius - 1,
                              ),
                            ),
                          ),
                        ),

                      // Build header if provided
                      if (widget.header != null ||
                          widget.leadingIcon != null ||
                          widget.badgeText != null)
                        _buildHeader(context, accent),

                      // Main content
                      Padding(
                        padding: EdgeInsets.all(context.spacingM),
                        child: widget.child,
                      ),

                      // Build footer if provided
                      if (widget.footer != null) _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Gradient? _buildGradient(Color baseColor, Color accent) {
    if (!_isHovering) {
      return null;
    }

    if (widget.isAggregateRoot) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [accent.withOpacity(0.08), baseColor],
        stops: const [0.0, 0.3],
      );
    }

    if (widget.isConcept) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [baseColor, accent.withOpacity(0.08), baseColor],
        stops: const [0.0, 0.5, 1.0],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor, accent.withOpacity(0.05)],
    );
  }

  Widget _buildHeader(BuildContext context, Color accentColor) {
    // Special styles for aggregate roots and concepts
    final bool isSpecial = widget.isAggregateRoot || widget.isConcept;

    return Container(
      decoration: BoxDecoration(
        color: isSpecial ? accentColor.withOpacity(0.05) : null,
        border: Border(
          bottom: BorderSide(
            color:
                isSpecial
                    ? accentColor.withOpacity(0.3)
                    : Theme.of(context).dividerColor.withOpacity(0.5),
            width: isSpecial ? 1.5 : 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingM,
        vertical: context.spacingS,
      ),
      child: Row(
        children: [
          if (widget.leadingIcon != null) ...[
            Icon(
              widget.leadingIcon,
              color: accentColor,
              size: isSpecial ? 22 : 20,
            ),
            SizedBox(width: context.spacingS),
          ],
          if (widget.header != null) Expanded(child: widget.header!),
          if (widget.badgeText != null) _buildBadge(context, accentColor),

          // Special indicator for aggregate roots and concepts
          if (isSpecial && widget.badgeText == null)
            _buildSpecialIndicator(context, accentColor),
        ],
      ),
    );
  }

  Widget _buildSpecialIndicator(BuildContext context, Color accentColor) {
    final String label =
        widget.isAggregateRoot ? '@aggregate-root' : '@concept';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs / 2,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isAggregateRoot ? Icons.account_tree : Icons.category,
            size: 12,
            color: accentColor,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, Color accentColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs / 2,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        widget.badgeText!,
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isSpecial = widget.isAggregateRoot || widget.isConcept;
    final accent =
        widget.accentColor ??
        (widget.conceptType != null
            ? context.conceptColor(widget.conceptType!, role: widget.role)
            : Theme.of(context).colorScheme.primary);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingM,
        vertical: context.spacingS,
      ),
      decoration: BoxDecoration(
        color:
            isSpecial
                ? accent.withOpacity(0.03)
                : Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color:
                isSpecial
                    ? accent.withOpacity(0.3)
                    : Theme.of(context).dividerColor.withOpacity(0.5),
            width: isSpecial ? 1.5 : 1,
          ),
        ),
      ),
      child: widget.footer!,
    );
  }
}
