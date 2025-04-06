import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import '../layout/responsive_semantic_wrapper.dart';

/// An adaptive attribute display component that adjusts based on screen size
class AdaptiveAttributeDisplay extends StatelessWidget {
  /// The entity containing the attribute
  final ednet.Entity entity;

  /// The attribute to display
  final ednet.Attribute attribute;

  /// Optional accent color for styling
  final Color? accentColor;

  /// Optional callback when attribute is edited
  final Function(String attributeCode, dynamic newValue)? onEdit;

  /// Constructor for AdaptiveAttributeDisplay
  const AdaptiveAttributeDisplay({
    super.key,
    required this.entity,
    required this.attribute,
    this.accentColor,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenCategory = ResponsiveSemanticWrapper.getScreenCategory(context);
    final priority = attribute.semanticPriority;
    final color = accentColor ?? colorScheme.primary;

    // Get attribute value
    final value = entity.getAttribute(attribute.code);
    final isSensitive = entity.concept.isAttributeSensitive(attribute.code);

    // Create a unique artifact ID based on entity and attribute
    final String artifactId = "attribute_${attribute.code}_${entity.oid}";
    final String modelCode = entity.concept.model.code;

    // Wrap the appropriate display widget based on screen size in a ResponsiveSemanticWrapper
    // to enable pinning functionality
    return ResponsiveSemanticWrapper(
      artifactId: artifactId,
      modelCode: modelCode,
      priority: priority,
      compactChild: _buildMinimalAttribute(context, value, isSensitive, color),
      child: _determineDisplayWidget(
        context,
        screenCategory,
        value,
        isSensitive,
        color,
      ),
    );
  }

  /// Determine which display widget to use based on screen size
  Widget _determineDisplayWidget(
    BuildContext context,
    ScreenSizeCategory screenCategory,
    dynamic value,
    bool isSensitive,
    Color color,
  ) {
    // For ultrawide displays, show maximally rich content
    if (screenCategory == ScreenSizeCategory.ultraWide) {
      return _buildRichAttributeCard(context, value, isSensitive, color);
    }

    // For desktop/large desktop, use regular cards
    if (screenCategory == ScreenSizeCategory.desktop ||
        screenCategory == ScreenSizeCategory.largeDesktop) {
      return _buildAttributeCard(context, value, isSensitive, color);
    }

    // For tablet, use more compact display
    if (screenCategory == ScreenSizeCategory.tablet) {
      return _buildCompactAttribute(context, value, isSensitive, color);
    }

    // For mobile, use minimal display
    return _buildMinimalAttribute(context, value, isSensitive, color);
  }

  /// Rich attribute display for very large screens
  Widget _buildRichAttributeCard(
    BuildContext context,
    dynamic value,
    bool isSensitive,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 255.0 * 0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with attribute metadata
            Row(
              children: [
                Icon(
                  _getIconForAttributeType(attribute.type?.code),
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attribute.code,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                if (attribute.required == true)
                  Tooltip(
                    message: 'Required',
                    child: Icon(Icons.star, size: 18, color: Colors.amber),
                  ),
                if (attribute.sensitive == true)
                  Tooltip(
                    message: 'Sensitive',
                    child: Icon(Icons.lock, size: 18, color: Colors.red),
                  ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Type information
            if (attribute.type != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.data_object,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Type: ${attribute.type!.code}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

            // Value display
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.text_fields,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Value:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      isSensitive
                          ? _buildSensitiveValue(context)
                          : _buildAttributeValue(context, value),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Edit button if onEdit is provided
            if (onEdit != null && attribute.update == true)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: Icon(Icons.edit, size: 16),
                  label: Text('Edit'),
                  onPressed: () => _handleEdit(context),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Standard attribute card for desktop
  Widget _buildAttributeCard(
    BuildContext context,
    dynamic value,
    bool isSensitive,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 255.0 * 0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attribute name
            Row(
              children: [
                Icon(
                  _getIconForAttributeType(attribute.type?.code),
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attribute.code,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (attribute.required == true)
                  Icon(Icons.star, size: 14, color: Colors.amber),
              ],
            ),

            const SizedBox(height: 8),

            // Attribute value
            isSensitive
                ? _buildSensitiveValue(context)
                : _buildAttributeValue(context, value),

            // Edit button if onEdit is provided
            if (onEdit != null && attribute.update == true)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.edit, size: 14),
                  onPressed: () => _handleEdit(context),
                  tooltip: 'Edit',
                  color: colorScheme.primary,
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Compact attribute display for tablet
  Widget _buildCompactAttribute(
    BuildContext context,
    dynamic value,
    bool isSensitive,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
        color: colorScheme.surface,
      ),
      child: Row(
        children: [
          // Attribute name
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  _getIconForAttributeType(attribute.type?.code),
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attribute.code,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Attribute value
          Expanded(
            flex: 3,
            child:
                isSensitive
                    ? _buildSensitiveValue(context)
                    : _buildAttributeValue(context, value),
          ),

          // Edit button if onEdit is provided
          if (onEdit != null && attribute.update == true)
            IconButton(
              icon: Icon(Icons.edit, size: 14),
              onPressed: () => _handleEdit(context),
              tooltip: 'Edit',
              color: colorScheme.primary,
              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }

  /// Minimal attribute display for mobile
  Widget _buildMinimalAttribute(
    BuildContext context,
    dynamic value,
    bool isSensitive,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Only display the value on very constrained layouts
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '${attribute.code}:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child:
                isSensitive
                    ? _buildSensitiveValue(context)
                    : _buildAttributeValue(context, value, isCompact: true),
          ),
          if (onEdit != null && attribute.update == true)
            IconButton(
              icon: Icon(Icons.edit, size: 14),
              onPressed: () => _handleEdit(context),
              tooltip: 'Edit',
              color: colorScheme.primary,
              constraints: BoxConstraints(minWidth: 24, minHeight: 24),
            ),
        ],
      ),
    );
  }

  /// Display for sensitive values
  Widget _buildSensitiveValue(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.lock_outline, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '••••••••',
          style: TextStyle(
            letterSpacing: 2,
            fontFamily: 'monospace',
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 255.0 * 0.6),
          ),
        ),
      ],
    );
  }

  /// Display attribute value based on type
  Widget _buildAttributeValue(
    BuildContext context,
    dynamic value, {
    bool isCompact = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    // Handle null values
    if (value == null) {
      return Text(
        'Not set',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface.withValues(alpha: 255.0 * 0.5),
        ),
      );
    }

    // Special handling for different types
    if (attribute.type?.code == 'bool') {
      // Boolean as checkbox
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value == true ? Icons.check_box : Icons.check_box_outline_blank,
            size: 18,
            color: value == true ? Colors.green : Colors.grey,
          ),
          if (!isCompact) ...[
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      );
    } else if (attribute.type?.code == 'DateTime') {
      // Format DateTime nicely
      final dateTime = value as DateTime;
      if (isCompact) {
        return Text(
          '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}-${dateTime.year}',
          style: TextStyle(color: colorScheme.onSurface),
        );
      }
      return Text(
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
        style: TextStyle(color: colorScheme.onSurface),
      );
    } else if (attribute.type?.code == 'int' ||
        attribute.type?.code == 'double' ||
        attribute.type?.code == 'num') {
      // Right-align numbers
      return Text(
        value.toString(),
        style: TextStyle(fontFamily: 'monospace', color: colorScheme.onSurface),
        textAlign: TextAlign.right,
      );
    } else if (attribute.type?.code == 'Uri') {
      // Clickable link for URI
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link, size: 14, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isCompact ? "Link" : value.toString(),
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      // Default selectable text for other types
      return SelectableText(
        value.toString(),
        style: TextStyle(color: colorScheme.onSurface),
      );
    }
  }

  /// Get icon for attribute type
  IconData _getIconForAttributeType(String? type) {
    if (type == null) return Icons.text_fields;

    switch (type.toLowerCase()) {
      case 'datetime':
        return Icons.calendar_today;
      case 'bool':
        return Icons.check_circle_outline;
      case 'int':
      case 'double':
      case 'num':
        return Icons.numbers;
      case 'uri':
        return Icons.link;
      case 'email':
        return Icons.email;
      case 'telephone':
        return Icons.phone;
      case 'name':
        return Icons.person;
      case 'description':
        return Icons.description;
      case 'money':
        return Icons.attach_money;
      default:
        return Icons.text_fields;
    }
  }

  /// Handle editing the attribute
  void _handleEdit(BuildContext context) {
    if (onEdit == null) return;

    // Get current value
    final value = entity.getAttribute(attribute.code);

    // TODO: Implement attribute editing dialog
    onEdit!(attribute.code, value);
  }
}
