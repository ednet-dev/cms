import 'package:flutter/material.dart';
import '../../theme/providers/theme_provider.dart';
import '../../theme/extensions/theme_spacing.dart';
import '../semantic_concept_container.dart';

/// Represents a single item in the breadcrumb trail
class BreadcrumbItem {
  /// The display text for this breadcrumb
  final String label;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Whether this is the current/active breadcrumb
  final bool current;

  /// Callback when this breadcrumb is tapped
  final VoidCallback? onTap;

  /// Optional subtitle for providing additional context
  final String? subtitle;

  /// Creates a breadcrumb item
  BreadcrumbItem({
    required this.label,
    this.icon,
    this.current = false,
    this.onTap,
    this.subtitle,
  });
}

/// A horizontal bar showing breadcrumb navigation
class BreadcrumbBar extends StatelessWidget {
  /// The items to display in the breadcrumb
  final List<BreadcrumbItem> items;

  /// Optional padding around the breadcrumb bar
  final EdgeInsetsGeometry? padding;

  /// Whether to show separator lines between items
  final bool showSeparatorLines;

  /// Optional title to display before the breadcrumbs
  final String? title;

  /// Creates a breadcrumb navigation bar
  const BreadcrumbBar({
    super.key,
    required this.items,
    this.padding,
    this.showSeparatorLines = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SemanticConceptContainer(
      conceptType: 'Breadcrumb',
      child: Container(
        padding: padding ?? EdgeInsets.all(context.spacingS),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.5),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: context.spacingS,
                  bottom: context.spacingXs,
                ),
                child: Text(
                  title!,
                  style: context.conceptTextStyle('Breadcrumb', role: 'title'),
                ),
              ),
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _buildBreadcrumbItems(context)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(BuildContext context) {
    final List<Widget> result = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // Add the breadcrumb item
      result.add(_BreadcrumbItemWidget(item: item));

      // Add separator if not the last item
      if (i < items.length - 1) {
        if (showSeparatorLines) {
          result.add(
            Container(
              height: 24,
              margin: EdgeInsets.symmetric(horizontal: context.spacingXs),
              child: Row(
                children: [
                  Container(
                    width: 1,
                    color: context
                        .conceptColor('Breadcrumb', role: 'separator')
                        .withOpacity(0.2),
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacingXs / 2,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: context.conceptColor(
                      'Breadcrumb',
                      role: 'separator',
                    ),
                  ),
                  Container(
                    width: 1,
                    color: context
                        .conceptColor('Breadcrumb', role: 'separator')
                        .withOpacity(0.2),
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacingXs / 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          result.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacingXs),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: context.conceptColor('Breadcrumb', role: 'separator'),
              ),
            ),
          );
        }
      }
    }

    return result;
  }
}

/// Widget representing a single breadcrumb item
class _BreadcrumbItemWidget extends StatefulWidget {
  final BreadcrumbItem item;

  const _BreadcrumbItemWidget({required this.item});

  @override
  State<_BreadcrumbItemWidget> createState() => _BreadcrumbItemWidgetState();
}

class _BreadcrumbItemWidgetState extends State<_BreadcrumbItemWidget>
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
    final theme = Theme.of(context);

    // Style based on current/hover states
    final textStyle =
        widget.item.current
            ? context
                .conceptTextStyle('Breadcrumb', role: 'current')
                ?.copyWith(fontWeight: FontWeight.bold)
            : context
                .conceptTextStyle('Breadcrumb')
                ?.copyWith(
                  color:
                      _isHovering
                          ? theme.colorScheme.primary
                          : theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                );

    final color =
        widget.item.current
            ? context.conceptColor('Breadcrumb', role: 'current')
            : _isHovering
            ? theme.colorScheme.primary
            : context.conceptColor('Breadcrumb').withOpacity(0.7);

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.item.icon != null) ...[
              Icon(
                widget.item.icon,
                size: widget.item.current ? 18 : 16,
                color: color,
              ),
              SizedBox(width: context.spacingXs),
            ],
            Text(widget.item.label, style: textStyle),
          ],
        ),
        if (widget.item.subtitle != null) ...[
          SizedBox(height: 2),
          Text(
            widget.item.subtitle!,
            style: context
                .conceptTextStyle('Breadcrumb', role: 'subtitle')
                ?.copyWith(fontSize: 11, color: color.withOpacity(0.7)),
          ),
        ],
      ],
    );

    // Visual indicator for current item
    if (widget.item.current) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: context.spacingXs / 2,
              horizontal: context.spacingS,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: content,
          );
        },
      );
    }

    // If no onTap handler, just show the content
    if (widget.item.onTap == null) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.spacingXs / 2,
          horizontal: context.spacingXs,
        ),
        child: content,
      );
    }

    // Otherwise wrap in an interactive button for navigation
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isHovering ? _scaleAnimation.value : 1.0,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovering = true);
              _animationController.forward();
            },
            onExit: (_) {
              setState(() => _isHovering = false);
              _animationController.reverse();
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.item.onTap,
                borderRadius: BorderRadius.circular(context.spacingXs),
                splashColor: theme.colorScheme.primary.withOpacity(0.1),
                highlightColor: theme.colorScheme.primary.withOpacity(0.05),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: context.spacingXs / 2,
                    horizontal: context.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isHovering
                            ? theme.colorScheme.primary.withOpacity(0.05)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _isHovering
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: content,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
