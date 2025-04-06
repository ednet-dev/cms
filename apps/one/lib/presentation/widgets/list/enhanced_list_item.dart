import 'package:flutter/material.dart';
import '../../theme/providers/theme_provider.dart';
import '../../theme/extensions/theme_spacing.dart';

/// A visually enhanced list item with modern styling, animations, and color accents
class EnhancedListItem extends StatefulWidget {
  /// Main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional subtitle widget that takes precedence over subtitle text
  final Widget? subtitleWidget;

  /// Optional trailing widget shown at the end of the list item
  final Widget? trailing;

  /// Optional leading icon
  final IconData? leadingIcon;

  /// Optional leading widget that takes precedence over leadingIcon
  final Widget? leading;

  /// Callback when the list item is tapped
  final VoidCallback? onTap;

  /// Optional accent color for the list item
  final Color? accentColor;

  /// Optional concept type to use for theming
  final String? conceptType;

  /// Optional role within the concept for more specific styling
  final String? role;

  /// Controls if the list item should have hover animation
  final bool enableHoverEffect;

  /// Optional badge text to display at the end of the title
  final String? badgeText;

  /// Optional secondary action to display as an icon button
  final IconData? secondaryActionIcon;

  /// Callback for secondary action
  final VoidCallback? onSecondaryAction;

  /// Indicates if this item represents an aggregate root
  final bool isAggregateRoot;

  /// Indicates if this item represents a domain concept
  final bool isConcept;

  /// Optional importance level (0-1) to control visual prominence
  final double importance;

  /// Creates an enhanced list item with modern styling
  const EnhancedListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.leadingIcon,
    this.leading,
    this.onTap,
    this.accentColor,
    this.conceptType,
    this.role,
    this.enableHoverEffect = true,
    this.badgeText,
    this.secondaryActionIcon,
    this.onSecondaryAction,
    this.isAggregateRoot = false,
    this.isConcept = false,
    this.importance = 0.5,
  });

  @override
  State<EnhancedListItem> createState() => _EnhancedListItemState();
}

class _EnhancedListItemState extends State<EnhancedListItem>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.01).animate(
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
    final isSpecial = widget.isAggregateRoot || widget.isConcept;

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
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: context.spacingXs / 2,
                horizontal: context.spacingXs,
              ),
              decoration: BoxDecoration(
                color:
                    _isHovering
                        ? Theme.of(context).cardColor
                        : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      _isHovering
                          ? accent.withOpacity(0.8)
                          : (isSpecial
                              ? accent.withOpacity(borderOpacity)
                              : Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.3)),
                  width: widget.isAggregateRoot ? 2.0 : 1.0,
                ),
                boxShadow:
                    _isHovering
                        ? [
                          BoxShadow(
                            color: accent.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  splashColor: accent.withOpacity(0.1),
                  highlightColor: accent.withOpacity(0.05),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacingM,
                      vertical: context.spacingS,
                    ),
                    child: Row(
                      children: [
                        // Special indicator for aggregate roots
                        if (widget.isAggregateRoot) ...[
                          Container(
                            width: 4,
                            height:
                                widget.subtitleWidget != null ||
                                        widget.subtitle != null
                                    ? 48
                                    : 32,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: context.spacingXs),
                        ],

                        // Leading section
                        if (widget.leading != null) ...[
                          widget.leading!,
                          SizedBox(width: context.spacingM),
                        ] else if (widget.leadingIcon != null) ...[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                isSpecial ? 10 : 8,
                              ),
                              border:
                                  isSpecial
                                      ? Border.all(
                                        color: accent.withOpacity(0.3),
                                        width: 1,
                                      )
                                      : null,
                            ),
                            child: Icon(
                              widget.leadingIcon,
                              color: accent,
                              size: isSpecial ? 22 : 20,
                            ),
                          ),
                          SizedBox(width: context.spacingM),
                        ],

                        // Content section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title row with optional badge
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style:
                                          widget.conceptType != null
                                              ? context.conceptTextStyle(
                                                widget.conceptType!,
                                                role: widget.role ?? 'title',
                                              )
                                              : Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight:
                                                    isSpecial
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                                color:
                                                    isSpecial ? accent : null,
                                              ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (widget.badgeText != null)
                                    _buildBadge(context, accent),

                                  // Special tag for concepts
                                  if (widget.isConcept &&
                                      widget.badgeText == null)
                                    _buildConceptTag(context, accent),
                                ],
                              ),

                              // Subtitle
                              if (widget.subtitleWidget != null) ...[
                                SizedBox(height: context.spacingXs / 2),
                                widget.subtitleWidget!,
                              ] else if (widget.subtitle != null) ...[
                                SizedBox(height: context.spacingXs / 2),
                                Text(
                                  widget.subtitle!,
                                  style:
                                      widget.conceptType != null
                                          ? context.conceptTextStyle(
                                            widget.conceptType!,
                                            role: 'subtitle',
                                          )
                                          : Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.color,
                                            fontStyle:
                                                isSpecial
                                                    ? FontStyle.italic
                                                    : null,
                                          ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Trailing section
                        if (widget.secondaryActionIcon != null &&
                            (_isHovering || isSpecial)) ...[
                          SizedBox(width: context.spacingXs),
                          IconButton(
                            icon: Icon(widget.secondaryActionIcon),
                            color: accent,
                            onPressed: widget.onSecondaryAction,
                            tooltip: 'Secondary action',
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.all(context.spacingXs),
                            iconSize: 20,
                          ),
                          SizedBox(width: context.spacingXs),
                        ],

                        if (widget.trailing != null) ...[
                          SizedBox(width: context.spacingS),
                          widget.trailing!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(BuildContext context, Color accent) {
    return Container(
      margin: EdgeInsets.only(left: context.spacingXs),
      padding: EdgeInsets.symmetric(horizontal: context.spacingXs, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: accent.withOpacity(0.3), width: 1),
      ),
      child: Text(
        widget.badgeText!,
        style: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConceptTag(BuildContext context, Color accent) {
    return Container(
      margin: EdgeInsets.only(left: context.spacingXs),
      padding: EdgeInsets.symmetric(horizontal: context.spacingXs, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: accent.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.category, size: 10, color: accent),
          SizedBox(width: 2),
          Text(
            '@concept',
            style: TextStyle(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
