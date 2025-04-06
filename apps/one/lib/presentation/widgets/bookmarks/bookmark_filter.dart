import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookmark_manager.dart';
import 'bookmark_model.dart';
import '../filters/filter_criteria.dart';

/// A component for filtering bookmarks using ednet_core FilterCriteria
class BookmarkFilterButton extends StatelessWidget {
  /// Optional callback when filters are applied
  final Function(List<Bookmark>)? onFiltersApplied;

  const BookmarkFilterButton({Key? key, this.onFiltersApplied})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter bookmarks',
      onPressed: () => _showFilterDialog(context),
    );
  }

  /// Show the filter dialog
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => BookmarkFilterDialog(onFiltersApplied: onFiltersApplied),
    );
  }
}

/// Dialog for creating and applying bookmark filters
class BookmarkFilterDialog extends StatefulWidget {
  /// Optional callback when filters are applied
  final Function(List<Bookmark>)? onFiltersApplied;

  const BookmarkFilterDialog({Key? key, this.onFiltersApplied})
    : super(key: key);

  @override
  State<BookmarkFilterDialog> createState() => _BookmarkFilterDialogState();
}

class _BookmarkFilterDialogState extends State<BookmarkFilterDialog> {
  final List<FilterCriteria> _criteria = [];
  String _selectedAttribute = 'title';
  String _selectedOperator = 'contains';
  final TextEditingController _valueController = TextEditingController();

  /// Available attributes for filtering
  final Map<String, String> _attributes = {
    'title': 'Title',
    'url': 'URL',
    'description': 'Description',
    'category': 'Category',
  };

  /// Available operators for filtering
  final Map<String, String> _operators = {
    '==': 'Equals',
    '!=': 'Not Equals',
    'contains': 'Contains',
    'startsWith': 'Starts With',
    'endsWith': 'Ends With',
  };

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  /// Add a new filter criterion
  void _addCriterion() {
    if (_valueController.text.isEmpty) return;

    setState(() {
      _criteria.add(
        FilterCriteria(
          field: _selectedAttribute,
          operator: _stringToOperator(_selectedOperator),
          valueType: FilterValueType.text,
          value: _valueController.text,
        ),
      );
      _valueController.clear();
    });
  }

  /// Convert string operator to FilterOperator enum
  FilterOperator _stringToOperator(String op) {
    switch (op) {
      case '==':
        return FilterOperator.equals;
      case '!=':
        return FilterOperator.notEquals;
      case 'contains':
        return FilterOperator.contains;
      case 'startsWith':
        return FilterOperator.startsWith;
      case 'endsWith':
        return FilterOperator.endsWith;
      default:
        return FilterOperator.equals;
    }
  }

  /// Remove a criterion at the specified index
  void _removeCriterion(int index) {
    setState(() {
      _criteria.removeAt(index);
    });
  }

  /// Apply the current filters
  void _applyFilters() async {
    Navigator.of(context).pop();

    if (_criteria.isEmpty) {
      if (widget.onFiltersApplied != null) {
        final bookmarks = await context.read<BookmarkManager>().getBookmarks();
        widget.onFiltersApplied!(bookmarks);
      }
      return;
    }

    final filteredBookmarks = await context
        .read<BookmarkManager>()
        .filterBookmarks(_criteria);

    if (widget.onFiltersApplied != null) {
      widget.onFiltersApplied!(filteredBookmarks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Bookmarks'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current filters
            if (_criteria.isNotEmpty) ...[
              const Text('Current Filters:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_criteria.length, (index) {
                  final criterion = _criteria[index];
                  return Chip(
                    label: Text(
                      '${_attributes[criterion.field]} ${_operators[criterion.operator.toString()] ?? ''} ${criterion.value}',
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeCriterion(index),
                  );
                }),
              ),
              const Divider(),
            ],

            // Add new filter
            const Text('Add Filter:'),
            const SizedBox(height: 8),

            // Attribute dropdown
            DropdownButtonFormField<String>(
              value: _selectedAttribute,
              decoration: const InputDecoration(
                labelText: 'Attribute',
                border: OutlineInputBorder(),
              ),
              items:
                  _attributes.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedAttribute = value;
                  });
                }
              },
            ),
            const SizedBox(height: 8),

            // Operator dropdown
            DropdownButtonFormField<String>(
              value: _selectedOperator,
              decoration: const InputDecoration(
                labelText: 'Operator',
                border: OutlineInputBorder(),
              ),
              items:
                  _operators.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedOperator = value;
                  });
                }
              },
            ),
            const SizedBox(height: 8),

            // Value input
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
                hintText: 'Enter filter value',
              ),
            ),
            const SizedBox(height: 16),

            // Add filter button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Filter'),
                onPressed: _addCriterion,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: const Text('Apply Filters'),
        ),
      ],
    );
  }
}
