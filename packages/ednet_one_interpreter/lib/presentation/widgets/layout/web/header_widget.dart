import 'package:flutter/material.dart';

/// Represents a filter criteria for the domain model view.
class FilterCriteria {
  /// The field to filter on
  final String field;

  /// The operator to use (equals, contains, etc.)
  final String operator;

  /// The value to filter with
  final String value;

  /// Creates a new filter criteria.
  const FilterCriteria({
    required this.field,
    required this.operator,
    required this.value,
  });

  @override
  String toString() => '$field $operator $value';
}

/// A header widget that displays navigation breadcrumbs and provides filter controls.
///
/// This widget is used at the top of the UI to show the current navigation path
/// and allows users to filter content and create bookmarks.
class HeaderWidget extends StatelessWidget {
  /// The current navigation path segments.
  final List<String> path;

  /// Callback when a path segment is tapped.
  final Function(int) onPathSegmentTapped;

  /// The currently applied filters.
  final List<FilterCriteria> filters;

  /// Callback when a new filter is added.
  final Function(FilterCriteria) onAddFilter;

  /// Callback when the bookmark button is pressed.
  final VoidCallback onBookmark;

  /// Creates a new header widget.
  const HeaderWidget({
    Key? key,
    required this.path,
    required this.onPathSegmentTapped,
    required this.filters,
    required this.onAddFilter,
    required this.onBookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The breadcrumb trail
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < path.length; i++) ...[
                  if (i > 0) const Icon(Icons.chevron_right, size: 16),
                  InkWell(
                    onTap: () => onPathSegmentTapped(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        path[i],
                        style: TextStyle(
                          fontWeight:
                              i == path.length - 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                              i == path.length - 1
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Filter button
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filter',
          onPressed: () => _showFilterDialog(context),
        ),

        // Current filter pills
        if (filters.isNotEmpty)
          SizedBox(
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Chip(
                    label: Text(filters[index].toString()),
                    onDeleted: () {
                      // TODO: Implement filter removal
                    },
                  ),
                );
              },
            ),
          ),

        // Bookmark button
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          tooltip: 'Bookmark',
          onPressed: onBookmark,
        ),
      ],
    );
  }

  /// Shows a dialog to create a new filter.
  void _showFilterDialog(BuildContext context) {
    String field = '';
    String operator = '=';
    String value = '';

    final operators = ['=', '!=', '<', '>', '<=', '>=', 'contains'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Filter'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Field'),
                  onChanged: (val) => field = val,
                ),
                DropdownButtonFormField<String>(
                  value: operator,
                  decoration: const InputDecoration(labelText: 'Operator'),
                  items:
                      operators
                          .map(
                            (op) =>
                                DropdownMenuItem(value: op, child: Text(op)),
                          )
                          .toList(),
                  onChanged: (val) => operator = val!,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Value'),
                  onChanged: (val) => value = val,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (field.isNotEmpty && value.isNotEmpty) {
                    onAddFilter(
                      FilterCriteria(
                        field: field,
                        operator: operator,
                        value: value,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
