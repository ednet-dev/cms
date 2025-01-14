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
    required void Function(dynamic index) onPathSegmentTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Row(
        //   children: [
        //     DropdownButton<String>(
        //       hint: Text('Attribute',
        //           style: TextStyle(color: colorScheme.onSurface)),
        //       dropdownColor: colorScheme.surface, // Dropdown background color
        //       items: ['name', 'age', 'type']
        //           .map((attribute) => DropdownMenuItem<String>(
        //                 value: attribute,
        //                 child: Text(attribute,
        //                     style: TextStyle(
        //                         color: colorScheme.onSurface)), // Text color
        //               ))
        //           .toList(),
        //       onChanged: (value) {
        //         // Handle attribute selection
        //       },
        //     ),
        //     DropdownButton<String>(
        //       hint: Text('Operator',
        //           style: TextStyle(color: colorScheme.onSurface)),
        //       dropdownColor: colorScheme.surface, // Dropdown background color
        //       items: ['=', '!=', '>', '<']
        //           .map((operator) => DropdownMenuItem<String>(
        //                 value: operator,
        //                 child: Text(operator,
        //                     style: TextStyle(
        //                         color: colorScheme.onSurface)), // Text color
        //               ))
        //           .toList(),
        //       onChanged: (value) {
        //         // Handle operator selection
        //       },
        //     ),
        //     Expanded(
        //       child: TextField(
        //         style: TextStyle(color: colorScheme.onSurface),
        //         // Input text color
        //         decoration: InputDecoration(
        //           hintText: 'Value',
        //           hintStyle:
        //               TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        //           // Hint text color
        //           enabledBorder: UnderlineInputBorder(
        //             borderSide: BorderSide(
        //                 color: colorScheme.secondary), // Border color
        //           ),
        //           focusedBorder: UnderlineInputBorder(
        //             borderSide: BorderSide(
        //                 color: colorScheme.secondary), // Focused border color
        //           ),
        //         ),
        //         onSubmitted: (value) {
        //           // Handle value input
        //         },
        //       ),
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.add, color: colorScheme.onSurface),
        //       onPressed: () {
        //         onAddFilter(FilterCriteria(
        //           attribute: 'name',
        //           operator: '=',
        //           value: 'Example',
        //         ));
        //       },
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.bookmark, color: colorScheme.onSurface),
        //       onPressed: onBookmark,
        //     ),
        //   ],
        // ),
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
