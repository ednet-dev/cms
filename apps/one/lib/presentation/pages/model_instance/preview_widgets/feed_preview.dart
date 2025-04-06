import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:intl/intl.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';

/// FeedPreview displays social media-like feed data with ACL mappings
class FeedPreview extends StatelessWidget {
  /// The data to display, typically from an external service
  final dynamic data;

  /// Field mappings for transforming external data to the domain model
  final List<FieldMapping> mappings;

  /// The domain that contains the model
  final Domain domain;

  /// The model to map data to
  final Model model;

  /// Constructor
  const FeedPreview({
    Key? key,
    required this.data,
    required this.mappings,
    required this.domain,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle empty data
    if (data == null) {
      return const Center(child: Text('No data to display'));
    }

    // Extract the feed items based on the service type
    List<dynamic> feedItems = _extractFeedItems(data);

    if (feedItems.isEmpty) {
      return const Center(child: Text('No feed items found'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(context.spacingM),
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        final item = feedItems[index];
        return _buildFeedItem(context, item);
      },
    );
  }

  /// Extract feed items from the service data
  List<dynamic> _extractFeedItems(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Try to find a key that contains an array of items
      for (final key in ['tweets', 'posts', 'videos', 'items']) {
        if (data.containsKey(key) && data[key] is List) {
          return data[key] as List;
        }
      }
    }

    // If we can't find a suitable list or the data is already a list
    if (data is List) {
      return data;
    }

    return [];
  }

  /// Build a feed item card
  Widget _buildFeedItem(BuildContext context, dynamic item) {
    // Apply mappings to get the field values
    final Map<String, dynamic> mappedValues = {};

    for (final mapping in mappings) {
      final value = _getValueFromPath(item, mapping.sourceField);
      if (value != null) {
        mappedValues[mapping.targetField] = _applyTransformation(
          value,
          mapping.transformation,
        );
      }
    }

    // If no mappings exist yet, use default display
    if (mappedValues.isEmpty) {
      return _buildDefaultFeedItem(context, item);
    }

    // Find the concept and construct an entity-like display
    for (final concept in model.concepts.toList()) {
      // Check if we have mappings for this concept
      final conceptMappings =
          mappedValues.keys
              .where((key) => key.startsWith('${concept.code}.'))
              .toList();

      if (conceptMappings.isNotEmpty) {
        return _buildMappedFeedItem(context, concept, mappedValues);
      }
    }

    // Fallback to default display
    return _buildDefaultFeedItem(context, item);
  }

  /// Build a feed item card using mapped values for a specific concept
  Widget _buildMappedFeedItem(
    BuildContext context,
    Concept concept,
    Map<String, dynamic> mappedValues,
  ) {
    // Extract all values for this concept
    final conceptValues = <String, dynamic>{};
    final prefix = '${concept.code}.';

    for (final entry in mappedValues.entries) {
      if (entry.key.startsWith(prefix)) {
        final attributeName = entry.key.substring(prefix.length);
        conceptValues[attributeName] = entry.value;
      }
    }

    return Card(
      margin: EdgeInsets.only(bottom: context.spacingM),
      child: Padding(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with concept type
            Row(
              children: [
                Icon(Icons.account_circle, size: 40, color: Colors.blue),
                SizedBox(width: context.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concept.code,
                        style: context.conceptTextStyle(
                          concept.code,
                          role: 'title',
                        ),
                      ),
                      if (conceptValues.containsKey('id'))
                        Text(
                          'ID: ${conceptValues['id']}',
                          style: context.conceptTextStyle(
                            concept.code,
                            role: 'subtitle',
                          ),
                        ),
                    ],
                  ),
                ),
                if (conceptValues.containsKey('created_at') ||
                    conceptValues.containsKey('timestamp') ||
                    conceptValues.containsKey('date'))
                  Text(
                    _formatTimestamp(
                      conceptValues['created_at'] ??
                          conceptValues['timestamp'] ??
                          conceptValues['date'],
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),

            SizedBox(height: context.spacingM),

            // Content
            if (conceptValues.containsKey('text') ||
                conceptValues.containsKey('message') ||
                conceptValues.containsKey('content'))
              Text(
                conceptValues['text'] ??
                    conceptValues['message'] ??
                    conceptValues['content'] ??
                    '',
                style: const TextStyle(fontSize: 16),
              ),

            // Display image if available
            if (conceptValues.containsKey('image_url') ||
                conceptValues.containsKey('media_url'))
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.spacingM),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Image.network(
                      conceptValues['image_url'] ??
                          conceptValues['media_url'] ??
                          '',
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    ),
                  ),
                ),
              ),

            // Display other attributes
            if (conceptValues.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: context.spacingM),
                child: Wrap(
                  spacing: context.spacingS,
                  runSpacing: context.spacingS,
                  children:
                      conceptValues.entries
                          .where(
                            (e) =>
                                ![
                                  'id',
                                  'text',
                                  'message',
                                  'content',
                                  'image_url',
                                  'media_url',
                                  'created_at',
                                  'timestamp',
                                  'date',
                                ].contains(e.key),
                          )
                          .map((entry) {
                            return Chip(
                              label: Text('${entry.key}: ${entry.value}'),
                              backgroundColor: Colors.grey.shade200,
                            );
                          })
                          .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build a default feed item when no mappings exist
  Widget _buildDefaultFeedItem(BuildContext context, dynamic item) {
    // Try to extract some common fields that might exist
    final String title =
        _getFirstNonNull(item, ['title', 'name', 'handle', 'username', 'id']) ??
        'Unknown';

    final String content =
        _getFirstNonNull(item, [
          'text',
          'message',
          'caption',
          'description',
          'content',
        ]) ??
        '';

    final dynamic timestamp = _getFirstNonNull(item, [
      'created_at',
      'created_time',
      'timestamp',
      'date',
    ]);

    final dynamic imageUrl = _getFirstNonNull(item, [
      'media_url',
      'image_url',
      'profile_image',
      'picture',
    ]);

    return Card(
      margin: EdgeInsets.only(bottom: context.spacingM),
      child: Padding(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.feed, size: 40),
                SizedBox(width: context.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (timestamp != null)
                  Text(
                    _formatTimestamp(timestamp),
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),

            SizedBox(height: context.spacingM),

            // Content
            if (content.isNotEmpty)
              Text(content, style: const TextStyle(fontSize: 16)),

            // Image
            if (imageUrl != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.spacingM),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Image.network(
                      imageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    ),
                  ),
                ),
              ),

            // Raw data label
            Padding(
              padding: EdgeInsets.only(top: context.spacingM),
              child: const Text(
                'Create field mappings to customize the display',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get value from a dot-separated path in a nested object
  dynamic _getValueFromPath(dynamic obj, String path) {
    if (obj == null) return null;

    final parts = path.split('.');
    dynamic current = obj;

    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else if (current is Map) {
        current = current[part];
      } else {
        return null;
      }

      if (current == null) {
        return null;
      }
    }

    return current;
  }

  /// Apply transformation to a value if specified
  dynamic _applyTransformation(dynamic value, String? transformation) {
    if (transformation == null || transformation.isEmpty) {
      return value;
    }

    switch (transformation.toLowerCase()) {
      case 'touppercase':
        return value.toString().toUpperCase();
      case 'tolowercase':
        return value.toString().toLowerCase();
      case 'toint':
      case 'parseint':
        return int.tryParse(value.toString()) ?? value;
      case 'todouble':
      case 'parsedouble':
        return double.tryParse(value.toString()) ?? value;
      case 'tobool':
      case 'parsebool':
        final str = value.toString().toLowerCase();
        return str == 'true' || str == '1' || str == 'yes';
      default:
        return value;
    }
  }

  /// Get the first non-null value from a list of possible keys
  dynamic _getFirstNonNull(dynamic obj, List<String> keys) {
    if (obj is! Map) return null;

    for (final key in keys) {
      if (obj.containsKey(key) && obj[key] != null) {
        return obj[key];
      }
    }

    return null;
  }

  /// Format a timestamp for display
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    try {
      DateTime dateTime;

      if (timestamp is int) {
        // Milliseconds since epoch
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        // ISO format string
        dateTime = DateTime.parse(timestamp);
      } else {
        return timestamp.toString();
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        return DateFormat('MMM d, yyyy').format(dateTime);
      } else if (difference.inDays > 30) {
        return DateFormat('MMM d').format(dateTime);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'just now';
      }
    } catch (e) {
      return timestamp.toString();
    }
  }
}

/// Field mapping between source and target
class FieldMapping {
  final String sourceField;
  final String targetField;
  final String? transformation;

  FieldMapping(this.sourceField, this.targetField, this.transformation);

  Map<String, dynamic> toJson() {
    return {
      'sourceField': sourceField,
      'targetField': targetField,
      'transformation': transformation,
    };
  }

  factory FieldMapping.fromJson(Map<String, dynamic> json) {
    return FieldMapping(
      json['sourceField'],
      json['targetField'],
      json['transformation'],
    );
  }
}
