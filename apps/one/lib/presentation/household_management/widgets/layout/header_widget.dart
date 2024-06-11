// header_widget.dart
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final List<FilterCriteria> filters;
  final void Function(FilterCriteria filter) onAddFilter;
  final VoidCallback onBookmark;

  HeaderWidget({
    required this.filters,
    required this.onAddFilter,
    required this.onBookmark,
    required List<String> path,
    required Null Function(dynamic index) onPathSegmentTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton<String>(
              hint: Text('Attribute'),
              items: ['name', 'age', 'type']
                  .map((attribute) => DropdownMenuItem<String>(
                        value: attribute,
                        child: Text(attribute),
                      ))
                  .toList(),
              onChanged: (value) {
                // Handle attribute selection
              },
            ),
            DropdownButton<String>(
              hint: Text('Operator'),
              items: ['=', '!=', '>', '<']
                  .map((operator) => DropdownMenuItem<String>(
                        value: operator,
                        child: Text(operator),
                      ))
                  .toList(),
              onChanged: (value) {
                // Handle operator selection
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: 'Value'),
                onSubmitted: (value) {
                  // Handle value input
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                onAddFilter(FilterCriteria(
                  attribute: 'name',
                  operator: '=',
                  value: 'Example',
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: onBookmark,
            ),
          ],
        ),
        Wrap(
          children: filters
              .map((filter) => Chip(
                    label: Text(
                        '${filter.attribute} ${filter.operator} ${filter.value}'),
                    onDeleted: () {
                      // Handle filter removal
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
