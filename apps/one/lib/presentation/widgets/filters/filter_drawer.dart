import 'package:flutter/material.dart';
import 'filter_criteria.dart';
import 'filter_builder.dart';
import 'filter_preset.dart';

/// A drawer that slides in from the right containing filter controls
class FilterDrawer extends StatefulWidget {
  /// The currently active filter group
  final FilterGroup? activeFilter;

  /// Called when a filter is applied
  final ValueChanged<FilterGroup> onFilterApplied;

  /// Called when a filter is saved as a preset
  final ValueChanged<FilterPreset> onFilterSaved;

  /// Called when a preset is applied
  final ValueChanged<FilterPreset> onPresetApplied;

  /// Called when a preset is deleted
  final ValueChanged<String> onPresetDeleted;

  /// Available filter presets
  final List<FilterPreset> presets;

  /// List of available fields that can be filtered
  final List<String> availableFields;

  /// Map of field names to their data types
  final Map<String, FilterValueType> fieldTypes;

  const FilterDrawer({
    super.key,
    this.activeFilter,
    required this.onFilterApplied,
    required this.onFilterSaved,
    required this.onPresetApplied,
    required this.onPresetDeleted,
    required this.presets,
    required this.availableFields,
    required this.fieldTypes,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer>
    with SingleTickerProviderStateMixin {
  late FilterGroup _currentFilter;
  late TabController _tabController;
  final TextEditingController _presetNameController = TextEditingController();
  final TextEditingController _presetDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.activeFilter ?? FilterGroup(criteria: []);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didUpdateWidget(FilterDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeFilter != oldWidget.activeFilter &&
        widget.activeFilter != null) {
      setState(() {
        _currentFilter = widget.activeFilter!;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _presetNameController.dispose();
    _presetDescriptionController.dispose();
    super.dispose();
  }

  /// Update the current filter
  void _updateFilter(FilterGroup filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  /// Apply the current filter
  void _applyFilter() {
    widget.onFilterApplied(_currentFilter);
    Navigator.of(context).pop();
  }

  /// Reset the filter to empty
  void _resetFilter() {
    setState(() {
      _currentFilter = FilterGroup(criteria: []);
    });
  }

  /// Show dialog to save the current filter as a preset
  void _showSavePresetDialog() {
    _presetNameController.clear();
    _presetDescriptionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Filter Preset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _presetNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter a name for this preset',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _presetDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Enter a description',
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                _savePreset();
                Navigator.of(context).pop();
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  /// Save the current filter as a preset
  void _savePreset() {
    if (_presetNameController.text.trim().isEmpty) {
      return;
    }

    final now = DateTime.now();
    // Generate a unique ID using timestamp and object hash
    final String presetId =
        '${now.millisecondsSinceEpoch}_${_currentFilter.hashCode}';

    final preset = FilterPreset(
      id: presetId,
      name: _presetNameController.text.trim(),
      filterGroups: [_currentFilter],
      createdAt: now,
      updatedAt: now,
      description:
          _presetDescriptionController.text.trim().isNotEmpty
              ? _presetDescriptionController.text.trim()
              : null,
    );

    widget.onFilterSaved(preset);
  }

  /// Apply a preset filter
  void _applyPreset(FilterPreset preset) {
    if (preset.filterGroups.isNotEmpty) {
      setState(() {
        _currentFilter = preset.filterGroups.first;
      });
      widget.onPresetApplied(preset);
    }
  }

  /// Delete a preset
  void _deletePreset(String presetId) {
    widget.onPresetDeleted(presetId);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Build Filter'),
                    Tab(text: 'Saved Filters'),
                  ],
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Build Filter Tab
                _buildFilterBuilderTab(),

                // Saved Filters Tab
                _buildSavedFiltersTab(),
              ],
            ),
          ),

          // Footer with action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reset button
                OutlinedButton.icon(
                  onPressed: _resetFilter,
                  icon: const Icon(Icons.clear),
                  label: const Text('Reset'),
                ),

                Row(
                  children: [
                    // Save Preset button
                    OutlinedButton.icon(
                      onPressed: _showSavePresetDialog,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                    const SizedBox(width: 8),

                    // Apply button
                    ElevatedButton.icon(
                      onPressed: _applyFilter,
                      icon: const Icon(Icons.check),
                      label: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the filter builder tab
  Widget _buildFilterBuilderTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter builder component
          Expanded(
            child: SingleChildScrollView(
              child: FilterBuilder(
                filterGroup: _currentFilter,
                onFilterGroupChanged: _updateFilter,
                availableFields: widget.availableFields,
                fieldTypes: widget.fieldTypes,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the saved filters tab
  Widget _buildSavedFiltersTab() {
    if (widget.presets.isEmpty) {
      return const Center(
        child: Text(
          'No saved filters yet. Build a filter and save it to see it here.',
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.presets.length,
      itemBuilder: (context, index) {
        final preset = widget.presets[index];
        return ListTile(
          title: Text(preset.name),
          subtitle:
              preset.description != null ? Text(preset.description!) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deletePreset(preset.id),
                tooltip: 'Delete preset',
              ),
            ],
          ),
          onTap: () => _applyPreset(preset),
        );
      },
    );
  }
}
