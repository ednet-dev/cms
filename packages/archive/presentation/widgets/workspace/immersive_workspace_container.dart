import 'package:flutter/material.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';

/// A container that can transition between a compact card view and a full immersive workspace
///
/// This component implements the fluid workspace pattern where cards representing
/// domains, models, or concepts can expand to become full application workspaces,
/// with smooth animations and transitions.
class ImmersiveWorkspaceContainer extends StatefulWidget {
  /// The title of the workspace
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// The concept type this workspace represents (Domain, Model, Concept, etc.)
  final String conceptType;

  /// Optional role within the concept type
  final String? role;

  /// The icon to display in card mode
  final IconData icon;

  /// Content to display in the collapsed card view
  final Widget cardContent;

  /// Content to display in the expanded workspace view
  final Widget workspaceContent;

  /// Callback when card is expanded to workspace
  final VoidCallback? onExpand;

  /// Callback when workspace is collapsed to card
  final VoidCallback? onCollapse;

  /// Badge text to display in the top-right of the card
  final String? badgeText;

  /// Tag value used for Hero animation
  final String heroTag;

  /// Constructor for ImmersiveWorkspaceContainer
  const ImmersiveWorkspaceContainer({
    super.key,
    required this.title,
    this.subtitle,
    required this.conceptType,
    this.role,
    required this.icon,
    required this.cardContent,
    required this.workspaceContent,
    required this.heroTag,
    this.onExpand,
    this.onCollapse,
    this.badgeText,
  });

  @override
  State<ImmersiveWorkspaceContainer> createState() =>
      _ImmersiveWorkspaceContainerState();
}

class _ImmersiveWorkspaceContainerState
    extends State<ImmersiveWorkspaceContainer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expansionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _expansionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        if (widget.onExpand != null) widget.onExpand!();
      } else {
        _animationController.reverse();
        if (widget.onCollapse != null) widget.onCollapse!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // For the collapsed card state
        if (!_isExpanded && _animationController.value == 0) {
          return _buildCard(context);
        }

        // For the fully expanded workspace state
        if (_isExpanded && _animationController.value == 1) {
          return _buildWorkspace(context);
        }

        // For the transition state
        return _buildTransition(context);
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: SemanticConceptContainer(
        conceptType: widget.conceptType,
        child: GestureDetector(
          onTap: _toggleExpansion,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: context.conceptColor(
                  widget.conceptType,
                  role: widget.role,
                ),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card header
                Container(
                  padding: EdgeInsets.all(context.spacingM),
                  decoration: BoxDecoration(
                    color: context
                        .conceptColor(
                          widget.conceptType,
                          role: 'headerBackground',
                        )
                        .withValues(alpha: 255.0 * 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: context
                            .conceptColor(widget.conceptType, role: widget.role)
                            .withValues(alpha: 255.0 * 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        color: context.conceptColor(
                          widget.conceptType,
                          role: 'icon',
                        ),
                      ),
                      SizedBox(width: context.spacingS),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: context.conceptTextStyle(
                                widget.conceptType,
                                role: 'title',
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              SizedBox(height: context.spacingXs),
                              Text(
                                widget.subtitle!,
                                style: context.conceptTextStyle(
                                  widget.conceptType,
                                  role: 'subtitle',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.badgeText != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.spacingS,
                            vertical: context.spacingXs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: context
                                .conceptColor(
                                  widget.conceptType,
                                  role: 'badgeBackground',
                                )
                                .withValues(alpha: 255.0 * 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: context
                                  .conceptColor(
                                    widget.conceptType,
                                    role: 'badge',
                                  )
                                  .withValues(alpha: 255.0 * 0.3),
                            ),
                          ),
                          child: Text(
                            widget.badgeText!,
                            style: context.conceptTextStyle(
                              widget.conceptType,
                              role: 'badge',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Card content
                Padding(
                  padding: EdgeInsets.all(context.spacingM),
                  child: widget.cardContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspace(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: SemanticConceptContainer(
        conceptType: widget.conceptType,
        child: Material(
          color: context.conceptColor(
            widget.conceptType,
            role: 'workspaceBackground',
          ),
          child: Column(
            children: [
              // Top navigation bar
              _buildTopBar(context),

              // Main workspace content
              Expanded(child: widget.workspaceContent),

              // Bottom toolbar
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: context.spacingM),
      decoration: BoxDecoration(
        color: context.conceptColor(
          widget.conceptType,
          role: 'headerBackground',
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Collapse button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Collapse',
            onPressed: _toggleExpansion,
          ),

          // Breadcrumb path
          const SizedBox(width: 8),
          Icon(
            widget.icon,
            size: 16,
            color: context.conceptColor(widget.conceptType, role: 'icon'),
          ),
          const SizedBox(width: 8),
          Text(
            widget.title,
            style: context.conceptTextStyle(widget.conceptType, role: 'title'),
          ),

          // Spacer
          const Spacer(),

          // Optional action buttons
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More Actions',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: context.spacingM),
      decoration: BoxDecoration(
        color: context.conceptColor(
          widget.conceptType,
          role: 'footerBackground',
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Ready',
            style: context.conceptTextStyle(widget.conceptType, role: 'status'),
          ),

          // Spacer
          const Spacer(),

          // Tool buttons
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: 'Save',
            iconSize: 20,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            iconSize: 20,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Info',
            iconSize: 20,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTransition(BuildContext context) {
    // Calculate interpolated values for the transition
    final contentHeight =
        MediaQuery.of(context).size.height -
        104; // 56 + 48 for top and bottom bars

    return Hero(
      tag: widget.heroTag,
      child: Material(
        color:
            _isExpanded
                ? context.conceptColor(
                  widget.conceptType,
                  role: 'workspaceBackground',
                )
                : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          12 * (1 - _animationController.value),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: Tween<double>(
            begin: 200, // Card height
            end: MediaQuery.of(context).size.height, // Full screen height
          ).evaluate(_expansionAnimation),
          width: Tween<double>(
            begin: 400, // Card width
            end: MediaQuery.of(context).size.width, // Full screen width
          ).evaluate(_expansionAnimation),
          decoration: BoxDecoration(
            border:
                _animationController.value < 0.5
                    ? Border.all(
                      color: context.conceptColor(
                        widget.conceptType,
                        role: widget.role,
                      ),
                      width: 1.5 * (1 - _animationController.value),
                    )
                    : null,
          ),
          child: Column(
            children: [
              // Top bar with animating height
              Container(
                height: Tween<double>(
                  begin: 56, // Header height in card
                  end: 56, // Height of top bar
                ).evaluate(_expansionAnimation),
                padding: EdgeInsets.all(
                  context.spacingM * (1 - _animationController.value / 2),
                ),
                decoration: BoxDecoration(
                  color: ColorTween(
                    begin: context
                        .conceptColor(
                          widget.conceptType,
                          role: 'headerBackground',
                        )
                        .withValues(alpha: 255.0 * 0.1),
                    end: context.conceptColor(
                      widget.conceptType,
                      role: 'headerBackground',
                    ),
                  ).evaluate(_expansionAnimation),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      12 * (1 - _animationController.value),
                    ),
                    topRight: Radius.circular(
                      12 * (1 - _animationController.value),
                    ),
                  ),
                  boxShadow:
                      _animationController.value > 0.5
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.1 * (_animationController.value - 0.5) * 2,
                              ),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ]
                          : null,
                ),
                child: Row(
                  children: [
                    // Icon morphs from card icon to back button
                    IconButton(
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_arrow,
                        progress: _expansionAnimation,
                      ),
                      onPressed: _toggleExpansion,
                    ),

                    SizedBox(width: context.spacingXs),

                    // Title stays the same but styling changes
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle.lerp(
                          context.conceptTextStyle(
                            widget.conceptType,
                            role: 'title',
                          ),
                          context
                              .conceptTextStyle(
                                widget.conceptType,
                                role: 'title',
                              )
                              .copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                          _animationController.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content crossfades between card and workspace
              Expanded(
                child: AnimatedCrossFade(
                  firstChild: Padding(
                    padding: EdgeInsets.all(context.spacingM),
                    child: widget.cardContent,
                  ),
                  secondChild: widget.workspaceContent,
                  crossFadeState:
                      _animationController.value < 0.5
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ),

              // Bottom bar appears during transition
              ClipRect(
                child: SizeTransition(
                  sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.5, 1.0),
                    ),
                  ),
                  child: _buildBottomBar(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
