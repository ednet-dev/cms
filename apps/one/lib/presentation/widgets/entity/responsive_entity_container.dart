import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import '../layout/responsive_semantic_wrapper.dart';
import 'adaptive_attribute_display.dart';

/// A responsive container for displaying entity details
class ResponsiveEntityContainer extends StatelessWidget {
  /// The entity to display
  final ednet.Entity entity;

  /// Optional callback when an attribute is edited
  final Function(String attributeCode, dynamic newValue)? onAttributeEdit;

  /// Optional callback when a relationship is selected
  final Function(ednet.Entity relatedEntity)? onRelationshipSelected;

  /// Constructor for ResponsiveEntityContainer
  const ResponsiveEntityContainer({
    super.key,
    required this.entity,
    this.onAttributeEdit,
    this.onRelationshipSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenCategory = ResponsiveSemanticWrapper.getScreenCategory(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Group attributes by semantic priority
    final attributesByPriority = _groupAttributesByPriority();

    // Determine layout based on screen size
    if (screenCategory == ScreenSizeCategory.mobile) {
      return _buildMobileLayout(context, attributesByPriority);
    } else if (screenCategory == ScreenSizeCategory.tablet) {
      return _buildTabletLayout(context, attributesByPriority);
    } else {
      return _buildDesktopLayout(context, attributesByPriority, screenCategory);
    }
  }

  /// Group all attributes by their semantic priority
  Map<SemanticPriority, List<ednet.Attribute>> _groupAttributesByPriority() {
    final result = <SemanticPriority, List<ednet.Attribute>>{};

    // Initialize empty lists for each priority
    for (final priority in SemanticPriority.values) {
      result[priority] = [];
    }

    // Group attributes by priority
    try {
      for (var attribute
          in entity.concept.attributes.whereType<ednet.Attribute>()) {
        final priority = attribute.semanticPriority;
        result[priority]!.add(attribute);
      }
    } catch (e) {
      debugPrint('Error grouping attributes: $e');
    }

    return result;
  }

  /// Build a compact mobile layout
  Widget _buildMobileLayout(
    BuildContext context,
    Map<SemanticPriority, List<ednet.Attribute>> attributesByPriority,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entity header
          _buildEntityHeader(context, compact: true),

          // Only critical and important attributes for mobile
          if (attributesByPriority[SemanticPriority.critical]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Key Identifiers',
              attributesByPriority[SemanticPriority.critical]!,
              colorScheme.primary,
              Icons.key,
            ),

          if (attributesByPriority[SemanticPriority.important]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Required Information',
              attributesByPriority[SemanticPriority.important]!,
              colorScheme.secondary,
              Icons.star,
            ),

          // Display a message about hidden attributes
          if (attributesByPriority[SemanticPriority.standard]!.isNotEmpty ||
              attributesByPriority[SemanticPriority.auxiliary]!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Additional details available on larger screens',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  /// Build a balanced tablet layout
  Widget _buildTabletLayout(
    BuildContext context,
    Map<SemanticPriority, List<ednet.Attribute>> attributesByPriority,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entity header
          _buildEntityHeader(context),

          // Critical, important and standard attributes for tablet
          if (attributesByPriority[SemanticPriority.critical]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Identifiers',
              attributesByPriority[SemanticPriority.critical]!,
              colorScheme.primary,
              Icons.key,
            ),

          if (attributesByPriority[SemanticPriority.important]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Required Fields',
              attributesByPriority[SemanticPriority.important]!,
              colorScheme.secondary,
              Icons.star,
            ),

          if (attributesByPriority[SemanticPriority.standard]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Standard Properties',
              attributesByPriority[SemanticPriority.standard]!,
              colorScheme.tertiary,
              Icons.list_alt,
            ),

          // Display a message about hidden attributes
          if (attributesByPriority[SemanticPriority.auxiliary]!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Additional details available on larger screens',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  /// Build a comprehensive desktop layout
  Widget _buildDesktopLayout(
    BuildContext context,
    Map<SemanticPriority, List<ednet.Attribute>> attributesByPriority,
    ScreenSizeCategory screenCategory,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUltraWide = screenCategory == ScreenSizeCategory.ultraWide;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entity header
          _buildEntityHeader(context, enhanced: isUltraWide),

          // Desktop shows all attributes except supplementary
          if (attributesByPriority[SemanticPriority.critical]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Identifiers',
              attributesByPriority[SemanticPriority.critical]!,
              colorScheme.primary,
              Icons.key,
            ),

          if (attributesByPriority[SemanticPriority.important]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Required Fields',
              attributesByPriority[SemanticPriority.important]!,
              colorScheme.secondary,
              Icons.star,
            ),

          if (attributesByPriority[SemanticPriority.standard]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Standard Properties',
              attributesByPriority[SemanticPriority.standard]!,
              colorScheme.tertiary,
              Icons.list_alt,
            ),

          if (attributesByPriority[SemanticPriority.auxiliary]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Additional Information',
              attributesByPriority[SemanticPriority.auxiliary]!,
              colorScheme.error,
              Icons.info_outline,
            ),

          // Show supplementary content only on ultrawide screens
          if (isUltraWide &&
              attributesByPriority[SemanticPriority.supplementary]!.isNotEmpty)
            _buildAttributesSection(
              context,
              'Extended Details',
              attributesByPriority[SemanticPriority.supplementary]!,
              colorScheme.surfaceTint,
              Icons.extension,
            ),

          // Rich relationships visualization for desktops
          _buildRelationshipsPanel(context, isEnhanced: isUltraWide),
        ],
      ),
    );
  }

  /// Build the entity header with title and metadata
  Widget _buildEntityHeader(
    BuildContext context, {
    bool compact = false,
    bool enhanced = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract title from entity properties
    final title = _getEntityTitle();
    final conceptName = entity.concept.code;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: compact ? 12.0 : 20.0,
      ),
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Concept type and code
          Row(
            children: [
              Icon(
                Icons.label_outline,
                size: compact ? 16 : 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                conceptName,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              if (!compact && entity.code.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  '(${entity.code})',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: compact ? 4.0 : 8.0),
            child: Text(
              title,
              style:
                  compact
                      ? theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                      : theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
            ),
          ),

          // Timestamps for non-compact mode
          if (!compact)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                if (entity.whenAdded != null)
                  _buildTimestampChip(
                    context,
                    'Created',
                    _formatDate(entity.whenAdded),
                    Icons.add_circle_outline,
                    Colors.green,
                  ),
                if (entity.whenSet != null)
                  _buildTimestampChip(
                    context,
                    'Modified',
                    _formatDate(entity.whenSet),
                    Icons.edit_outlined,
                    Colors.amber,
                  ),
                if (entity.whenRemoved != null)
                  _buildTimestampChip(
                    context,
                    'Removed',
                    _formatDate(entity.whenRemoved),
                    Icons.delete_outline,
                    Colors.red,
                  ),
              ],
            ),

          // Enhanced metadata in ultrawide mode
          if (enhanced) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text('Technical Metadata', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: [
                _buildMetadataItem(
                  context,
                  'OID',
                  entity.oid.toString(),
                  Icons.fingerprint,
                ),
                _buildMetadataItem(
                  context,
                  'Concept',
                  conceptName,
                  Icons.category,
                ),
                _buildMetadataItem(
                  context,
                  'Model',
                  entity.concept.model.code,
                  Icons.view_module,
                ),
                _buildMetadataItem(
                  context,
                  'Domain',
                  entity.concept.model.domain.code,
                  Icons.domain,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build a section of grouped attributes
  Widget _buildAttributesSection(
    BuildContext context,
    String title,
    List<ednet.Attribute> attributes,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenCategory = ResponsiveSemanticWrapper.getScreenCategory(context);
    final isDesktop = screenCategory.index >= ScreenSizeCategory.desktop.index;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Section content with responsive layout
          if (isDesktop)
            // Desktop uses a grid layout
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  attributes.map((attribute) {
                    return SizedBox(
                      width: 300,
                      child: AdaptiveAttributeDisplay(
                        entity: entity,
                        attribute: attribute,
                        accentColor: color,
                        onEdit: onAttributeEdit,
                      ),
                    );
                  }).toList(),
            )
          else
            // Mobile/tablet uses a column layout
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  attributes.map((attribute) {
                    return AdaptiveAttributeDisplay(
                      entity: entity,
                      attribute: attribute,
                      accentColor: color,
                      onEdit: onAttributeEdit,
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  /// Build the relationships visualization panel
  Widget _buildRelationshipsPanel(
    BuildContext context, {
    bool isEnhanced = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Basic placeholder for now - would be expanded with actual relationship data
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 255.0 * 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.connect_without_contact,
                size: 20,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Relationships',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // TODO: Implement actual relationships visualization
          Center(
            child:
                isEnhanced
                    ? Text(
                      'Enhanced relationship visualization would appear here',
                      style: theme.textTheme.bodyMedium,
                    )
                    : Text(
                      'Relationship visualization would appear here',
                      style: theme.textTheme.bodyMedium,
                    ),
          ),
        ],
      ),
    );
  }

  /// Build a timestamp chip for compact display
  Widget _buildTimestampChip(
    BuildContext context,
    String label,
    String date,
    IconData icon,
    Color color,
  ) {
    return Chip(
      backgroundColor: color.withValues(alpha: 255.0 * 0.1),
      side: BorderSide(color: color.withValues(alpha: 255.0 * 0.3), width: 1),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      avatar: Icon(icon, size: 16, color: color),
      label: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: date,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 255.0 * 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a metadata item for enhanced mode
  Widget _buildMetadataItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 255.0 * 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Extract a title from entity properties
  String _getEntityTitle() {
    try {
      if (entity.getAttribute('firstName') != null) {
        if (entity.getAttribute('lastName') != null) {
          return '${entity.getAttribute('firstName')} ${entity.getAttribute('lastName')}';
        }
        return entity.getAttribute('firstName').toString();
      }

      if (entity.getAttribute('name') != null) {
        return entity.getAttribute('name').toString();
      }

      if (entity.getAttribute('title') != null) {
        return entity.getAttribute('title').toString();
      }

      if (entity.getAttribute('description') != null) {
        final description = entity.getAttribute('description').toString();
        return description.length > 50
            ? '${description.substring(0, 50)}...'
            : description;
      }

      if (entity.getAttribute('id') != null) {
        return entity.getAttribute('id').toString();
      }

      if (entity.code.isNotEmpty) {
        return entity.code;
      }

      return entity.concept.code;
    } catch (e) {
      return entity.concept.code;
    }
  }

  /// Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
