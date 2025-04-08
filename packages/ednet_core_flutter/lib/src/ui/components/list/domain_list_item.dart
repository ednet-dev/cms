part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A domain-aware list item with semantic styling and progressive disclosure
/// that integrates with the EDNet Shell Architecture to visualize domain entities in list contexts.
class DomainListItem extends StatefulWidget {
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

  /// The current disclosure level for progressive UI
  final DisclosureLevel disclosureLevel;

  /// Creates a domain-aware list item with semantic styling
  const DomainListItem({
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
    this.disclosureLevel = DisclosureLevel.standard,
  });

  /// Create a DomainListItem for a specific entity using the EDNet Core integration
  factory DomainListItem.forEntity({
    required Entity entity,
    VoidCallback? onTap,
    VoidCallback? onSecondaryAction,
    Widget? trailing,
    Widget? leading,
    String? subtitle,
    Widget? subtitleWidget,
    IconData? leadingIcon,
    IconData? secondaryActionIcon,
    Color? accentColor,
    bool enableHoverEffect = true,
    double importance = 0.5,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Determine if entity is a concept or aggregate root based on its metadata
    final isConcept = entity.concept.code.toLowerCase().contains('concept');
    final isAggregateRoot = entity.concept.entry;

    // Get concept type for proper theming
    final conceptType = entity.concept.code;

    // Generate title (entity's string representation or ID)
    final title = entity.toString();

    // Generate badge text if entity has a code
    final badgeText = entity.code.isNotEmpty ? entity.code : null;

    // Determine leading icon based on entity type
    final effectiveLeadingIcon = leadingIcon ?? _getIconForEntity(entity);

    // Generate subtitle if not provided
    final effectiveSubtitle = subtitle ?? entity.concept.code;

    return DomainListItem(
      title: title,
      subtitle: effectiveSubtitle,
      subtitleWidget: subtitleWidget,
      trailing: trailing,
      leadingIcon: effectiveLeadingIcon,
      leading: leading,
      onTap: onTap,
      accentColor: accentColor,
      conceptType: conceptType,
      enableHoverEffect: enableHoverEffect,
      badgeText: badgeText,
      secondaryActionIcon: secondaryActionIcon,
      onSecondaryAction: onSecondaryAction,
      isAggregateRoot: isAggregateRoot,
      isConcept: isConcept,
      importance: importance,
      disclosureLevel: disclosureLevel,
    );
  }

  /// Get appropriate icon for entity type
  static IconData _getIconForEntity(Entity entity) {
    final conceptCode = entity.concept.code.toLowerCase();

    // Icon selection based on common entity types
    if (conceptCode.contains('aggregate')) {
      return Icons.account_tree;
    } else if (conceptCode.contains('concept')) {
      return Icons.category;
    } else if (conceptCode.contains('attribute')) {
      return Icons.label;
    } else if (conceptCode.contains('relationship')) {
      return Icons.link;
    } else if (conceptCode.contains('model')) {
      return Icons.view_module;
    } else if (conceptCode.contains('domain')) {
      return Icons.domain;
    } else if (conceptCode.contains('project')) {
      return Icons.work;
    } else if (conceptCode.contains('deployment')) {
      return Icons.cloud_upload;
    } else if (conceptCode.contains('environment')) {
      return Icons.public;
    }

    // Default icon
    return Icons.circle;
  }

  @override
  State<DomainListItem> createState() => _DomainListItemState();
}

class _DomainListItemState extends State<DomainListItem>
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
    final accent = _getAccentColor(context);
    final isSpecial = widget.isAggregateRoot || widget.isConcept;

    // Adjust opacity based on importance and hover state
    final borderOpacity = _isHovering ? 0.8 : (0.3 + (widget.importance * 0.5));

    // Determine if we should show concept indicators based on disclosure level
    final showConceptIndicators =
        widget.disclosureLevel.index >= DisclosureLevel.detailed.index;

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
                color: _isHovering
                    ? Theme.of(context).cardColor
                    : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovering
                      ? accent.withOpacity(0.8)
                      : (isSpecial && showConceptIndicators
                          ? accent.withOpacity(borderOpacity)
                          : Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.3)),
                  width: widget.isAggregateRoot && showConceptIndicators
                      ? 2.0
                      : 1.0,
                ),
                boxShadow: _isHovering
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
                        // Special indicator for aggregate roots (only shown at detailed+ levels)
                        if (widget.isAggregateRoot &&
                            showConceptIndicators) ...[
                          Container(
                            width: 4,
                            height: widget.subtitleWidget != null ||
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
                                isSpecial && showConceptIndicators ? 10 : 8,
                              ),
                              border: isSpecial && showConceptIndicators
                                  ? Border.all(
                                      color: accent.withOpacity(0.3),
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              widget.leadingIcon,
                              color: accent,
                              size:
                                  isSpecial && showConceptIndicators ? 22 : 20,
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
                                      style: _getTitleStyle(context),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (widget.badgeText != null)
                                    _buildBadge(context, accent),

                                  // Special tag for concepts (only at detailed+ levels)
                                  if (widget.isConcept &&
                                      widget.badgeText == null &&
                                      showConceptIndicators)
                                    _buildConceptTag(context, accent),
                                ],
                              ),

                              // Subtitle
                              if (widget.subtitleWidget != null) ...[
                                SizedBox(height: context.spacingXs / 2),
                                widget.subtitleWidget!,
                              ] else if (widget.subtitle != null &&
                                  widget.disclosureLevel.index >=
                                      DisclosureLevel.basic.index) ...[
                                SizedBox(height: context.spacingXs / 2),
                                Text(
                                  widget.subtitle!,
                                  style: _getSubtitleStyle(context),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Trailing section - secondary action only shown on hover or for special items at intermediate+ levels
                        if (widget.secondaryActionIcon != null &&
                            (_isHovering ||
                                (isSpecial &&
                                    widget.disclosureLevel.index >=
                                        DisclosureLevel
                                            .intermediate.index))) ...[
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

  /// Get the appropriate accent color based on concept type and semantic colors
  Color _getAccentColor(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<SemanticColorsExtension>();

    // Use provided accent color if available
    if (widget.accentColor != null) {
      return widget.accentColor!;
    }

    // Use semantic color based on concept type if available
    if (widget.conceptType != null && semanticColors != null) {
      // Use appropriate semantic color based on concept type
      if (widget.conceptType!.toLowerCase().contains('aggregate')) {
        return semanticColors.entity.withOpacity(0.8);
      } else if (widget.conceptType!.toLowerCase().contains('concept')) {
        return semanticColors.concept;
      } else {
        return semanticColors.entity;
      }
    }

    // Special colors for aggregate roots and concepts
    if (widget.isAggregateRoot && semanticColors != null) {
      return semanticColors.entity.withOpacity(0.8); // For aggregate roots
    }

    if (widget.isConcept && semanticColors != null) {
      return semanticColors.concept;
    }

    // Default to primary color
    return theme.colorScheme.primary;
  }

  /// Get appropriate title text style based on concept type and disclosure level
  TextStyle? _getTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isSpecial = widget.isAggregateRoot || widget.isConcept;
    final accent = _getAccentColor(context);

    // Try to get concept-specific text style if available
    if (widget.conceptType != null) {
      final contextExtension = theme.extension<SemanticColorsExtension>();
      if (contextExtension != null) {
        // This would normally use context.conceptTextStyle but we're adapting it
        return theme.textTheme.titleMedium?.copyWith(
          color: accent,
          fontWeight: isSpecial ? FontWeight.bold : FontWeight.w600,
        );
      }
    }

    // Default title style
    return theme.textTheme.titleMedium?.copyWith(
      fontWeight: isSpecial ? FontWeight.bold : FontWeight.w600,
      color: isSpecial ? accent : null,
    );
  }

  /// Get appropriate subtitle text style based on concept type and disclosure level
  TextStyle? _getSubtitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isSpecial = widget.isAggregateRoot || widget.isConcept;

    // Try to get concept-specific text style if available
    if (widget.conceptType != null) {
      final contextExtension = theme.extension<SemanticColorsExtension>();
      if (contextExtension != null) {
        // This would normally use context.conceptTextStyle but we're adapting it
        return theme.textTheme.bodyMedium?.copyWith(
          color: theme.textTheme.bodySmall?.color,
          fontStyle: isSpecial ? FontStyle.italic : null,
        );
      }
    }

    // Default subtitle style
    return theme.textTheme.bodyMedium?.copyWith(
      color: theme.textTheme.bodySmall?.color,
      fontStyle: isSpecial ? FontStyle.italic : null,
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

/// A UX adapter that uses DomainListItem for entity list rendering
class DomainListItemAdapter<T extends Entity<T>>
    extends ProgressiveUXAdapter<T> {
  /// Constructor
  DomainListItemAdapter(T entity) : super(entity);

  /// Get field descriptors from entity
  List<UXFieldDescriptor> getFieldDescriptors({
    DisclosureLevel? disclosureLevel = DisclosureLevel.basic,
  }) {
    // Create field descriptors from entity attributes
    final result = <UXFieldDescriptor>[];
    final level = disclosureLevel ?? DisclosureLevel.basic;

    for (final attribute in entity.concept.attributes) {
      // Determine field type
      final fieldType = _determineFieldType(attribute.type?.code ?? 'String');

      // Create disclosure level based on attribute properties
      var attrLevel = DisclosureLevel.basic;
      if (attribute.code.startsWith('__')) {
        attrLevel = DisclosureLevel.complete;
      } else if (attribute.code.startsWith('_')) {
        attrLevel = DisclosureLevel.advanced;
      } else if (!attribute.required) {
        attrLevel = DisclosureLevel.intermediate;
      } else {
        attrLevel = DisclosureLevel.minimal;
      }

      // Only add if appropriate for this disclosure level
      if (attrLevel.index <= level.index) {
        result.add(
          UXFieldDescriptor(
            fieldName: attribute.code,
            displayName: _formatDisplayName(attribute.code),
            fieldType: fieldType,
            required: attribute.required,
            disclosureLevel: attrLevel,
          ),
        );
      }
    }

    return result;
  }

  /// Get initial form data for entity
  Map<String, dynamic> getInitialFormData() {
    // Create a map of attribute values
    final result = <String, dynamic>{};

    for (final attribute in entity.concept.attributes) {
      final value = entity.getAttribute(attribute.code);
      if (value != null) {
        result[attribute.code] = value;
      }
    }

    return result;
  }

  /// Determine field type from attribute type
  UXFieldType _determineFieldType(String typeCode) {
    switch (typeCode.toLowerCase()) {
      case 'string':
        return UXFieldType.text;
      case 'text':
      case 'longtext':
        return UXFieldType.longText;
      case 'int':
      case 'double':
      case 'num':
      case 'number':
        return UXFieldType.number;
      case 'datetime':
      case 'date':
        return UXFieldType.date;
      case 'boolean':
      case 'bool':
        return UXFieldType.checkbox;
      default:
        return UXFieldType.text;
    }
  }

  /// Format a field name for display
  String _formatDisplayName(String code) {
    // Add spaces before capital letters and capitalize first letter
    final spaced = code
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();

    return spaced.substring(0, 1).toUpperCase() + spaced.substring(1);
  }

  @override
  Widget buildListItem(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    final level = disclosureLevel ?? DisclosureLevel.minimal;
    // Get entity details
    final subtitle = _getSubtitleForEntity(entity, level);

    return DomainListItem.forEntity(
      entity: entity,
      disclosureLevel: level,
      onTap: () {
        // Add navigation action here if needed
      },
      subtitle: subtitle,
      trailing: level.index > DisclosureLevel.minimal.index
          ? Icon(Icons.chevron_right,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.5))
          : null,
    );
  }

  @override
  Widget buildDetailView(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Using disclosure level to determine what to show
    // (Currently just showing a placeholder)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail View for ${entity.concept.code}: ${entity.code}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text('This is a placeholder for the detail view.'),
      ],
    );
  }

  @override
  Widget buildForm(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Using disclosure level to determine what fields to show
    // (Currently just showing a placeholder)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Form for ${entity.concept.code}: ${entity.code}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text('This is a placeholder for the form.'),
      ],
    );
  }

  @override
  Widget buildVisualization(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Using disclosure level to determine visualization complexity
    // (Currently just showing a placeholder)

    return Center(
      child: Text('Visualization for ${entity.concept.code}: ${entity.code}'),
    );
  }

  @override
  bool validateForm() {
    // Implement form validation logic
    return true;
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    // Implement form submission logic
    try {
      // Update entity with form data
      formData.forEach((key, value) {
        entity.setAttribute(key, value);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get appropriate subtitle text based on disclosure level
  String _getSubtitleForEntity(Entity entity, DisclosureLevel level) {
    // For minimal disclosure, no subtitle
    if (level == DisclosureLevel.minimal) {
      return '';
    }

    // For basic disclosure, show concept name
    if (level == DisclosureLevel.basic) {
      return entity.concept.code;
    }

    // For standard and above, try to get a description or create one from attributes
    if (level.index >= DisclosureLevel.standard.index) {
      // Look for a description attribute
      final dynamic description = entity.getAttribute('description') ??
          entity.getAttribute('summary') ??
          entity.getAttribute('details');

      if (description != null) {
        return description.toString();
      }

      // For more advanced disclosure, show key attributes
      if (level.index >= DisclosureLevel.intermediate.index) {
        final keyAttributes = entity.concept.attributes
            .where((attr) => attr.required && !attr.code.startsWith('_'))
            .take(2)
            .map((attr) =>
                '${attr.code}: ${entity.getAttribute(attr.code) ?? '-'}')
            .join(', ');

        if (keyAttributes.isNotEmpty) {
          return keyAttributes;
        }
      }
    }

    // Default fallback
    return entity.concept.code;
  }
}
