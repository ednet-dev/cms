import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/providers/filter_manager.dart';
import 'filter_criteria.dart';
import 'filter_drawer.dart';

/// A button that opens the filter drawer when tapped
class FilterButton extends StatelessWidget {
  /// List of available fields that can be filtered
  final List<String> availableFields;

  /// Map of field names to their data types
  final Map<String, FilterValueType> fieldTypes;

  /// Custom filter apply callback
  final Function(FilterGroup)? onFilterApplied;

  /// Badge showing number of active filters
  final bool showBadge;

  /// Button tooltip text
  final String tooltip;

  /// Button icon
  final IconData icon;

  const FilterButton({
    super.key,
    required this.availableFields,
    required this.fieldTypes,
    this.onFilterApplied,
    this.showBadge = true,
    this.tooltip = 'Filter',
    this.icon = Icons.filter_alt,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterManager>(
      builder: (context, filterManager, child) {
        final activeFilter = filterManager.activeFilter;
        final hasActiveFilters =
            activeFilter != null && activeFilter.hasActiveCriteria;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(icon),
              tooltip: tooltip,
              onPressed: () => _openFilterDrawer(context, filterManager),
            ),
            if (showBadge && hasActiveFilters)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    activeFilter!.activeCriteria.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Open the filter drawer
  void _openFilterDrawer(BuildContext context, FilterManager filterManager) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: FilterDrawer(
            activeFilter: filterManager.activeFilter,
            onFilterApplied: (filter) {
              if (onFilterApplied != null) {
                onFilterApplied!(filter);
              } else {
                filterManager.setActiveFilter(filter);
              }
            },
            onFilterSaved: filterManager.addPreset,
            onPresetApplied: filterManager.applyPreset,
            onPresetDeleted: filterManager.deletePreset,
            presets: filterManager.presets,
            availableFields: availableFields,
            fieldTypes: fieldTypes,
          ),
        );
      },
    );
  }
}
