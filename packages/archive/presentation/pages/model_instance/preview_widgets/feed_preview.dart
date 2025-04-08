import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:intl/intl.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:provider/provider.dart';

/// Represents a field mapping for the ACL layer
class FieldMapping {
  /// The field name in the source data
  final String sourceField;

  /// The field name in the target model
  final String targetField;

  /// Optional transformation expression
  final String? transformation;

  /// Constructor
  const FieldMapping({
    required this.sourceField,
    required this.targetField,
    this.transformation,
  });
}

/// FeedPreview displays social media-like feed data with ACL mappings
class FeedPreview extends StatelessWidget {
  /// The data to display, typically from an external service
  final List<Map<String, dynamic>> data;

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
    if (data.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        final mappedValues = _mapDataToModel(item);

        return _buildFeedItem(context, item, mappedValues);
      },
    );
  }

  /// Maps external data to model fields using the field mappings
  Map<String, dynamic> _mapDataToModel(Map<String, dynamic> item) {
    final result = <String, dynamic>{};

    for (final mapping in mappings) {
      if (item.containsKey(mapping.sourceField)) {
        var value = item[mapping.sourceField];

        // Apply transformation if specified
        if (mapping.transformation != null &&
            mapping.transformation!.isNotEmpty) {
          // For now just do simple transformations
          if (mapping.transformation == 'toUpperCase' && value is String) {
            value = value.toUpperCase();
          } else if (mapping.transformation == 'toLowerCase' &&
              value is String) {
            value = value.toLowerCase();
          } else if (mapping.transformation == 'toString') {
            value = value.toString();
          }
        }

        result[mapping.targetField] = value;
      }
    }

    return result;
  }

  /// Builds a feed item widget
  Widget _buildFeedItem(
    BuildContext context,
    Map<String, dynamic> originalData,
    Map<String, dynamic> mappedValues,
  ) {
    // Check if we're dealing with Twitter or Facebook data
    final isFacebook = originalData.containsKey('message');

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
                CircleAvatar(
                  backgroundColor: Provider.of<ThemeProvider>(
                    context,
                  ).conceptColor('Social'),
                  child: Text(
                    isFacebook
                        ? (originalData['author'] as String).isNotEmpty
                            ? (originalData['author'] as String)[0]
                                .toUpperCase()
                            : '?'
                        : (originalData['user_handle'] as String).isNotEmpty
                        ? (originalData['user_handle'] as String)[1]
                            .toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: context.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFacebook
                            ? originalData['author'] ?? ''
                            : originalData['user_name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isFacebook
                            ? originalData['profile_pic'] ?? ''
                            : originalData['user_handle'] ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDateTime(
                    isFacebook
                        ? originalData['posted_time'] ?? ''
                        : originalData['timestamp'] ?? '',
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            SizedBox(height: context.spacingM),

            // Content
            Text(
              isFacebook
                  ? originalData['message'] ?? ''
                  : originalData['content'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),

            SizedBox(height: context.spacingM),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  Icons.favorite_border,
                  isFacebook
                      ? '${originalData['reactions'] ?? 0}'
                      : '${originalData['likes'] ?? 0}',
                ),
                _buildActionButton(
                  context,
                  Icons.repeat,
                  isFacebook
                      ? '${originalData['shares'] ?? 0}'
                      : '${originalData['retweets'] ?? 0}',
                ),
                _buildActionButton(
                  context,
                  Icons.comment,
                  isFacebook ? '${originalData['comments'] ?? 0}' : '0',
                ),
              ],
            ),

            Divider(height: context.spacingL),

            // Mapped data section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mapped to Domain Model:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ThemeProvider>(
                      context,
                    ).conceptColor('MappedValue'),
                  ),
                ),
                SizedBox(height: context.spacingS),
                ...mappedValues.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            '${entry.value}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String count) {
    return Row(
      children: [Icon(icon, size: 16), SizedBox(width: 4), Text(count)],
    );
  }

  String _formatDateTime(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final formatter = DateFormat.MMMd().add_jm();
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }
}
