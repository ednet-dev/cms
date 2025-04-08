import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'entity_actions.dart';
import 'entity_header.dart';
import 'relationship_navigator.dart';
import '../semantic_concept_container.dart';
import '../../theme/providers/theme_provider.dart';
import '../../domain/domain_model_provider.dart';

/// A utility class for extracting entity titles from an Entity
class EntityTitleUtils {
  /// Get a display title for an entity
  static String getTitle(ednet.Entity entity) {
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

    // if have description trim to 50 characters with ...
    if (entity.getAttribute('description') != null) {
      return entity.getAttribute('description').toString().length > 50
          ? '${entity.getAttribute('description').toString().substring(0, 50)}...'
          : entity.getAttribute('description').toString();
    }

    if (entity.getAttribute('id') != null) {
      return entity.getAttribute('id').toString();
    }

    if (entity.getAttribute('code') != null) {
      return entity.getAttribute('code').toString();
    }

    try {
      return entity.concept.code;
    } catch (e) {
      return entity.concept.id.toString();
    }
  }
}

/// Enum representing entity lifecycle state
enum EntityStatus { newlyCreated, modified, deleted, stable }

/// Widget for entity details screen
class EntityDetailScreen extends StatelessWidget {
  /// The entity to display
  final ednet.Entity entity;

  /// Constructor for EntityDetailScreen
  const EntityDetailScreen({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          entity.getStringFromAttribute('name') ?? 'Entity Detail',
          style: context.conceptTextStyle('EntityDetail', role: 'title'),
        ),
        backgroundColor: context.conceptColor('Surface'),
        iconTheme: IconThemeData(
          color: context.conceptColor('Primary'),
          size: 24,
        ),
        elevation: 0,
        systemOverlayStyle:
            Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(child: EntityWidget(entity: entity)),
    );
  }
}

/// Main widget for displaying an entity with all its components
class EntityWidget extends StatelessWidget {
  /// The entity to display
  final ednet.Entity entity;

  /// Optional callback when an entity is selected
  final void Function(ednet.Entity entity)? onEntitySelected;

  /// Optional callback when the entity is deleted
  final VoidCallback? onDelete;

  /// Optional callback when the entity is saved
  final VoidCallback? onSave;

  /// Optional callback when the entity is exported
  final VoidCallback? onExport;

  /// Optional callback when a bookmark is created
  final Function(String title, String url)? onBookmark;

  /// Constructor for EntityWidget
  const EntityWidget({
    super.key,
    required this.entity,
    this.onEntitySelected,
    this.onDelete,
    this.onSave,
    this.onExport,
    this.onBookmark,
  });

  // Determine entity status for appropriate styling
  EntityStatus _determineStatus() {
    if (entity.whenRemoved != null) return EntityStatus.deleted;
    if (entity.whenSet != null) return EntityStatus.modified;
    if (entity.whenAdded != null &&
        DateTime.now().difference(entity.whenAdded!).inHours < 24) {
      return EntityStatus.newlyCreated;
    }
    return EntityStatus.stable;
  }

  // Get status color based on entity state
  Color _getStatusColor(BuildContext context, EntityStatus status) {
    switch (status) {
      case EntityStatus.newlyCreated:
        return context.conceptColor('Success');
      case EntityStatus.modified:
        return context.conceptColor('Warning');
      case EntityStatus.deleted:
        return context.conceptColor('Error');
      case EntityStatus.stable:
        return context.conceptColor('Primary');
    }
  }

  // Get icon for attribute type
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
      default:
        return Icons.text_fields;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Verify that we can access the concept (will throw if not accessible)
      entity.concept;
    } catch (e) {
      return _buildErrorDisplay(
        context,
        "Error accessing entity concept: ${e.toString().split("\n").first}",
      );
    }

    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;
    final status = _determineStatus();
    final statusColor = _getStatusColor(context, status);

    // Group attributes by semantic meaning
    final identifierAttributes = <ednet.Attribute>[];
    final requiredAttributes = <ednet.Attribute>[];
    final standardAttributes = <ednet.Attribute>[];
    final calculatedAttributes = <ednet.Attribute>[];

    try {
      for (var attribute
          in entity.concept.attributes.whereType<ednet.Attribute>()) {
        if (attribute.identifier) {
          identifierAttributes.add(attribute);
        } else if (attribute.required) {
          requiredAttributes.add(attribute);
        } else if (attribute.increment != null) {
          calculatedAttributes.add(attribute);
        } else {
          standardAttributes.add(attribute);
        }
      }
    } catch (e) {
      // Just continue if we can't access attributes
    }

    // Get the semantic concept type for the entity
    final conceptType = context.conceptTypeForEntity(entity);

    return SemanticConceptContainer(
      conceptType: conceptType,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8.0 : 16.0,
              vertical: 8.0,
            ),
            elevation: 2, // Slightly more elevation for better depth perception
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: statusColor.withOpacity(0.6), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with concept type and status indicator
                SemanticConceptContainer(
                  conceptType: 'EntityHeader',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0, // Increased for better touch target
                    ),
                    color: statusColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(
                          context.conceptIcon(conceptType),
                          size: 20,
                          color: statusColor,
                          semanticLabel: "Entity type",
                        ),
                        const SizedBox(
                          width: 12,
                        ), // Increased for better spacing
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                _getConceptCodeSafely(entity),
                                style: context.conceptTextStyle(
                                  conceptType,
                                  role: 'title',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStatusText(status),
                                  style: context.conceptTextStyle(
                                    conceptType,
                                    role: 'label',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Actions in the header for quick access
                        if (onSave != null ||
                            onExport != null ||
                            onDelete != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onSave != null)
                                IconButton(
                                  icon: const Icon(Icons.save, size: 20),
                                  tooltip: 'Save',
                                  onPressed: onSave,
                                  color: statusColor,
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                ),
                              if (onExport != null)
                                IconButton(
                                  icon: const Icon(Icons.share, size: 20),
                                  tooltip: 'Export',
                                  onPressed: onExport,
                                  color: statusColor,
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                if (status == EntityStatus.deleted)
                  SemanticConceptContainer(
                    conceptType: 'Warning',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: context.conceptColor('Error').withOpacity(0.1),
                      child: Text(
                        'This entity has been deleted ${_formatDate(entity.whenRemoved)}',
                        textAlign: TextAlign.center,
                        style: context.conceptTextStyle(
                          'Error',
                          role: 'message',
                        ),
                      ),
                    ),
                  ),

                // Lifecycle indicators
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (entity.whenAdded != null)
                        _buildLifecycleChip(
                          context,
                          'Created',
                          _formatDate(entity.whenAdded),
                          Icons.add_circle_outline,
                          context.conceptColor('Success'),
                        ),
                      if (entity.whenSet != null)
                        _buildLifecycleChip(
                          context,
                          'Modified',
                          _formatDate(entity.whenSet),
                          Icons.edit_outlined,
                          context.conceptColor('Warning'),
                        ),
                    ],
                  ),
                ),

                // Main content with scrolling
                Expanded(
                  child: SemanticConceptContainer(
                    conceptType: 'EntityContent',
                    fillHeight: true,
                    scrollable: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12.0 : 20.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Entity Header with title and metadata
                          Semantics(
                            header: true,
                            child: EntityHeader(entity: entity),
                          ),

                          const SizedBox(height: 24),

                          // Identifier attributes section if available
                          if (identifierAttributes.isNotEmpty)
                            _buildAttributeSection(
                              context,
                              'Identifiers',
                              identifierAttributes,
                              Icons.fingerprint,
                              context.conceptColor('Identifier'),
                            ),

                          // Required attributes section if available
                          if (requiredAttributes.isNotEmpty)
                            _buildAttributeSection(
                              context,
                              'Required Fields',
                              requiredAttributes,
                              Icons.star_outline,
                              context.conceptColor('Required'),
                            ),

                          // Standard attributes section
                          if (standardAttributes.isNotEmpty)
                            _buildAttributeSection(
                              context,
                              'Properties',
                              standardAttributes,
                              Icons.list_alt,
                              context.conceptColor('Attribute'),
                            ),

                          // Calculated attributes section if available
                          if (calculatedAttributes.isNotEmpty)
                            _buildAttributeSection(
                              context,
                              'Calculated Fields',
                              calculatedAttributes,
                              Icons.calculate_outlined,
                              context.conceptColor('Calculated'),
                            ),

                          // Relationship Navigator component
                          SemanticConceptContainer(
                            conceptType: 'Relationship',
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 16.0,
                                top: 8.0,
                              ),
                              child: RelationshipNavigator(
                                currentEntity: entity,
                                onEntitySelected:
                                    onEntitySelected ?? (entity) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom action bar with improved accessibility
                if (onDelete != null ||
                    onSave != null ||
                    onExport != null ||
                    onBookmark != null)
                  SemanticConceptContainer(
                    conceptType: 'Actions',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.conceptColor('Surface'),
                        border: Border(
                          top: BorderSide(
                            color: context
                                .conceptColor('Border')
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: isSmallScreen ? 8.0 : 12.0,
                      ),
                      child: EntityActions(
                        entity: entity,
                        onDelete: onDelete,
                        onSave: onSave,
                        onExport: onExport,
                        onBookmark: onBookmark,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLifecycleChip(
    BuildContext context,
    String label,
    String date,
    IconData icon,
    Color color,
  ) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3), width: 1),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      avatar: Icon(icon, size: 16, color: color),
      label: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontSize: 12,
                color: context.conceptColor('OnSurface'),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: date,
              style: TextStyle(
                fontSize: 12,
                color: context.conceptColor('OnSurface').withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format date for display
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

  // Build a section for a group of attributes
  Widget _buildAttributeSection(
    BuildContext context,
    String title,
    List<ednet.Attribute> attributes,
    IconData icon,
    Color color,
  ) {
    return SemanticConceptContainer(
      conceptType: 'AttributeSection',
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: context.conceptColor('Surface'),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: context.conceptTextStyle(
                      'AttributeSection',
                      role: 'title',
                    ),
                  ),
                ],
              ),
            ),

            // Attribute cards
            SemanticFlowContainer(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                for (var attribute in attributes)
                  _buildAttributeCard(context, attribute, color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build a card for a single attribute
  Widget _buildAttributeCard(
    BuildContext context,
    ednet.Attribute attribute,
    Color accentColor,
  ) {
    final value = entity.getAttribute(attribute.code);
    final displayValue = value != null ? value.toString() : 'Not set';
    final isSensitive = entity.concept.isAttributeSensitive(attribute.code);

    return SemanticConceptContainer(
      conceptType: 'Attribute',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 150, maxWidth: 300),
        child: Card(
          elevation: 0,
          color: context.conceptColor('SurfaceContainer'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: accentColor.withOpacity(0.2), width: 0.5),
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
                      color: accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attribute.code,
                        style: context.conceptTextStyle(
                          'Attribute',
                          role: 'name',
                        ),
                      ),
                    ),
                    if (attribute.required)
                      Icon(
                        Icons.star,
                        size: 14,
                        color: context.conceptColor('Required'),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Attribute value with better handling of different types
                isSensitive
                    ? _buildSensitiveValue(context)
                    : _buildAttributeValue(
                      context,
                      attribute,
                      value,
                      displayValue,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a representation of a sensitive value
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
            color: context.conceptColor('OnSurface').withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  // Build specialized value displays based on attribute type
  Widget _buildAttributeValue(
    BuildContext context,
    ednet.Attribute attribute,
    dynamic value,
    String displayValue,
  ) {
    // Handle null values consistently
    if (value == null) {
      return Text(
        'Not set',
        style: context.conceptTextStyle('Attribute', role: 'empty'),
      );
    }

    // Special handling for different types
    if (attribute.type?.code == 'bool') {
      // Boolean as checkbox
      return Row(
        children: [
          Icon(
            value == true ? Icons.check_box : Icons.check_box_outline_blank,
            size: 18,
            color:
                value == true ? context.conceptColor('Success') : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: context.conceptTextStyle('Attribute', role: 'value'),
          ),
        ],
      );
    } else if (attribute.type?.code == 'DateTime') {
      // Format DateTime nicely
      final dateTime = value as DateTime;
      return Text(
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
        style: context.conceptTextStyle('Attribute', role: 'datetime'),
      );
    } else if (attribute.type?.code == 'int' ||
        attribute.type?.code == 'double' ||
        attribute.type?.code == 'num') {
      // Right-align numbers
      return Text(
        displayValue,
        style: context.conceptTextStyle('Attribute', role: 'numeric'),
        textAlign: TextAlign.right,
      );
    } else if (attribute.type?.code == 'Uri') {
      // Clickable link for URI
      return Row(
        children: [
          Icon(Icons.link, size: 14, color: context.conceptColor('Link')),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayValue,
              style: context.conceptTextStyle('Attribute', role: 'link'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      // Default selectable text for other types
      return SelectableText(
        displayValue,
        style: context.conceptTextStyle('Attribute', role: 'value'),
      );
    }
  }

  /// Helper method to build an error display
  Widget _buildErrorDisplay(BuildContext context, String message) {
    return SemanticConceptContainer(
      conceptType: 'Error',
      child: Card(
        margin: const EdgeInsets.all(16),
        color: context.conceptColor('ErrorContainer'),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: context.conceptColor('Error'),
                size: 48,
                semanticLabel: "Error",
              ),
              const SizedBox(height: 16),
              Text(
                "Entity Error",
                style: context.conceptTextStyle('Error', role: 'title'),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: context.conceptTextStyle('Error', role: 'message'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "This may be caused by data model changes or initialization issues.",
                style: context.conceptTextStyle('Error', role: 'description'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.conceptColor('Primary'),
                  foregroundColor: context.conceptColor('OnPrimary'),
                  minimumSize: const Size(120, 48),
                ),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get an appropriate icon based on entity type
  IconData _getIconForEntityType(String type) {
    // Map common entity types to appropriate icons
    switch (type.toLowerCase()) {
      case 'user':
      case 'person':
      case 'customer':
      case 'employee':
        return Icons.person;
      case 'product':
      case 'item':
        return Icons.shopping_bag;
      case 'project':
      case 'task':
        return Icons.assignment;
      case 'document':
      case 'file':
        return Icons.description;
      case 'message':
      case 'comment':
        return Icons.message;
      case 'event':
      case 'meeting':
        return Icons.event;
      case 'location':
      case 'place':
        return Icons.location_on;
      case 'organization':
      case 'company':
        return Icons.business;
      case 'role':
        return Icons.assignment_ind;
      case 'status':
        return Icons.info;
      case 'theme':
        return Icons.palette;
      case 'application':
        return Icons.apps;
      default:
        return Icons.data_object;
    }
  }

  /// Helper method to safely get the concept code
  String _getConceptCodeSafely(ednet.Entity entity) {
    try {
      return entity.concept.code;
    } catch (e) {
      return "Unknown Type";
    }
  }

  // Helper method to get status text
  String _getStatusText(EntityStatus status) {
    switch (status) {
      case EntityStatus.newlyCreated:
        return 'New';
      case EntityStatus.modified:
        return 'Modified';
      case EntityStatus.deleted:
        return 'Deleted';
      case EntityStatus.stable:
        return 'Stable';
    }
  }
}
