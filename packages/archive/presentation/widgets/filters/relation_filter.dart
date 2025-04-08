import 'package:flutter/material.dart';
import 'filter_criteria.dart';

/// A specialized filter component for entity relationships
class RelationFilter extends StatefulWidget {
  /// The current filter criterion
  final FilterCriteria criterion;

  /// Available relationships to filter on
  final List<String> availableRelations;

  /// Callback when the filter criterion changes
  final ValueChanged<FilterCriteria> onFilterChanged;

  /// Optional callback to open an entity selection dialog
  final VoidCallback? onSelectEntity;

  const RelationFilter({
    super.key,
    required this.criterion,
    required this.availableRelations,
    required this.onFilterChanged,
    this.onSelectEntity,
  });

  @override
  State<RelationFilter> createState() => _RelationFilterState();
}

class _RelationFilterState extends State<RelationFilter> {
  late FilterCriteria _criterion;

  @override
  void initState() {
    super.initState();
    _criterion = widget.criterion;
  }

  @override
  void didUpdateWidget(RelationFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.criterion != widget.criterion) {
      _criterion = widget.criterion;
    }
  }

  /// Update the relation selection
  void _updateRelation(String? relation) {
    if (relation != null) {
      final newCriterion = _criterion.copyWith(
        field: relation,
        valueType: FilterValueType.relation,
        value: null,
      );

      _updateFilter(newCriterion);
    }
  }

  /// Update the operator selection
  void _updateOperator(FilterOperator? operator) {
    if (operator != null) {
      final newCriterion = _criterion.copyWith(
        operator: operator,
        value:
            (operator == FilterOperator.isNull ||
                    operator == FilterOperator.isNotNull)
                ? null
                : _criterion.value,
      );

      _updateFilter(newCriterion);
    }
  }

  /// Update the entity ID or list of IDs
  void _updateEntities(dynamic value) {
    final newCriterion = _criterion.copyWith(value: value);
    _updateFilter(newCriterion);
  }

  /// Update the filter and notify parent
  void _updateFilter(FilterCriteria criterion) {
    setState(() {
      _criterion = criterion;
    });
    widget.onFilterChanged(criterion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Relation selector
        DropdownButtonFormField<String>(
          value: _criterion.field,
          decoration: const InputDecoration(
            labelText: 'Relationship',
            border: OutlineInputBorder(),
          ),
          items:
              widget.availableRelations.map((relation) {
                return DropdownMenuItem<String>(
                  value: relation,
                  child: Text(relation),
                );
              }).toList(),
          onChanged: _updateRelation,
        ),
        const SizedBox(height: 16),

        // Operator selector
        DropdownButtonFormField<FilterOperator>(
          value: _criterion.operator,
          decoration: const InputDecoration(
            labelText: 'Condition',
            border: OutlineInputBorder(),
          ),
          items:
              [
                FilterOperator.isIn,
                FilterOperator.notIn,
                FilterOperator.isNull,
                FilterOperator.isNotNull,
              ].map((operator) {
                return DropdownMenuItem<FilterOperator>(
                  value: operator,
                  child: Text(_getOperatorLabel(operator)),
                );
              }).toList(),
          onChanged: _updateOperator,
        ),
        const SizedBox(height: 16),

        // Entity selector
        if (_criterion.operator != FilterOperator.isNull &&
            _criterion.operator != FilterOperator.isNotNull)
          _buildEntitySelector(),
      ],
    );
  }

  /// Build entity selector input
  Widget _buildEntitySelector() {
    // For isIn and notIn, we need to support multiple entity selection
    if (_criterion.operator == FilterOperator.isIn ||
        _criterion.operator == FilterOperator.notIn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display selected entities
          _buildSelectedEntitiesList(),

          const SizedBox(height: 8),

          // Button to select entities
          OutlinedButton.icon(
            onPressed: widget.onSelectEntity,
            icon: const Icon(Icons.add),
            label: const Text('Select Entities'),
          ),
        ],
      );
    }

    // For a single entity selection
    return TextFormField(
      initialValue: _criterion.value?.toString() ?? '',
      decoration: InputDecoration(
        labelText: 'Entity ID',
        border: const OutlineInputBorder(),
        hintText: 'Select an entity',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: widget.onSelectEntity,
        ),
      ),
      readOnly: true,
      onTap: widget.onSelectEntity,
    );
  }

  /// Build a list of selected entities with remove option
  Widget _buildSelectedEntitiesList() {
    final List<String> selectedEntities =
        _criterion.value is List
            ? List<String>.from(_criterion.value as List)
            : _criterion.value != null
            ? [_criterion.value.toString()]
            : [];

    if (selectedEntities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No entities selected'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selected Entities:'),
        const SizedBox(height: 8),
        ...selectedEntities.map((entity) => _buildEntityChip(entity)),
      ],
    );
  }

  /// Build a chip for a selected entity with remove option
  Widget _buildEntityChip(String entityId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Chip(
        label: Text(entityId),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          final List<String> updatedEntities =
              _criterion.value is List
                  ? List<String>.from(_criterion.value as List)
                  : _criterion.value != null
                  ? [_criterion.value.toString()]
                  : [];

          updatedEntities.remove(entityId);
          _updateEntities(updatedEntities);
        },
      ),
    );
  }

  /// Get a human-readable label for relationship operators
  String _getOperatorLabel(FilterOperator operator) {
    switch (operator) {
      case FilterOperator.isIn:
        return 'relates to';
      case FilterOperator.notIn:
        return 'does not relate to';
      case FilterOperator.isNull:
        return 'has no relation';
      case FilterOperator.isNotNull:
        return 'has any relation';
      default:
        return operator.toString();
    }
  }
}
