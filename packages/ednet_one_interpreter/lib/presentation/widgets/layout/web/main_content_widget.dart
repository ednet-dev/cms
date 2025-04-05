import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

/// A widget that displays the detailed properties and relationships of selected entities.
///
/// This widget serves as the main content area for entity viewing and editing.
class MainContentWidget extends StatefulWidget {
  /// The entities to display
  final Entities entities;

  /// Creates a new main content widget.
  const MainContentWidget({Key? key, required this.entities}) : super(key: key);

  @override
  _MainContentWidgetState createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<MainContentWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  dynamic _selectedEntity;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    if (widget.entities.isNotEmpty) {
      _selectedEntity = widget.entities.first;
    }
  }

  @override
  void didUpdateWidget(MainContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.entities != oldWidget.entities) {
      if (widget.entities.isNotEmpty) {
        _selectedEntity = widget.entities.first;
      } else {
        _selectedEntity = null;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entities.isEmpty) {
      return const Center(
        child: Text(
          'No entities selected',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: [
        if (widget.entities.length > 1) _buildEntitySelector(),
        Expanded(
          child:
              _selectedEntity == null
                  ? const Center(child: Text('No entity selected'))
                  : _buildEntityDetails(),
        ),
      ],
    );
  }

  /// Builds the entity selector dropdown.
  Widget _buildEntitySelector() {
    final entities = widget.entities.toList();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text(
              'Entity: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: DropdownButton<dynamic>(
                value: _selectedEntity,
                isExpanded: true,
                hint: const Text('Select an entity'),
                onChanged: (dynamic entity) {
                  if (entity != null) {
                    setState(() {
                      _selectedEntity = entity;
                    });
                  }
                },
                items:
                    entities.map((entity) {
                      return DropdownMenuItem<dynamic>(
                        value: entity,
                        child: Text(
                          _getEntityDisplayName(entity),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the tabbed entity details view.
  Widget _buildEntityDetails() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Entity View'),
            Tab(text: 'Attributes'),
            Tab(text: 'Relations'),
            Tab(text: 'JSON'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEntityWidget(),
              _buildAttributesTab(),
              _buildRelationshipsTab(),
              _buildJsonTab(),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a custom entity widget instead of using ednet_flow
  Widget _buildEntityWidget() {
    try {
      // Cast to Entity to ensure proper type
      final entity = _selectedEntity as Entity;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SimpleEntityWidget(
          entity: entity,
          onEntitySelected: (selectedEntity) {
            setState(() {
              _selectedEntity = selectedEntity;
            });
          },
        ),
      );
    } catch (e) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error displaying entity: ${e.toString()}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Builds the attributes tab.
  Widget _buildAttributesTab() {
    try {
      final concept = _selectedEntity.concept;
      final attributesList = concept.attributes.toList();

      return attributesList.isEmpty
          ? const Center(child: Text('No attributes'))
          : ListView.builder(
            itemCount: attributesList.length,
            itemBuilder: (context, index) {
              final attribute = attributesList[index] as Attribute;
              final value = _selectedEntity.getAttribute(attribute.code);

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: ListTile(
                  title: Text(attribute.code),
                  subtitle: Text(
                    'Type: ${attribute.type?.code ?? "Unknown"}${attribute.required ? " (Required)" : ""}',
                  ),
                  trailing: Text(
                    value?.toString() ?? 'null',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
    } catch (e) {
      return Center(child: Text('Error loading attributes: ${e.toString()}'));
    }
  }

  /// Builds a combined view of parents and children
  Widget _buildRelationshipsTab() {
    try {
      final concept = _selectedEntity.concept;
      final parentsList = concept.parents.toList();
      final childrenList = concept.children.toList();

      if (parentsList.isEmpty && childrenList.isEmpty) {
        return const Center(child: Text('No relationships defined'));
      }

      return ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          if (parentsList.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Parent Relationships',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...parentsList.map((parent) {
              final parentEntity = _selectedEntity.getParent(
                (parent as Parent).code,
              );
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: Text(parent.code),
                  subtitle: Text(
                    'Destination: ${parent.destinationConcept.code}${parent.required ? " (Required)" : ""}',
                  ),
                  trailing:
                      parentEntity == null
                          ? const Text('null')
                          : Text(_getEntityDisplayName(parentEntity)),
                  onTap:
                      parentEntity == null
                          ? null
                          : () {
                            setState(() {
                              _selectedEntity = parentEntity;
                            });
                          },
                ),
              );
            }).toList(),
            const Divider(thickness: 2),
          ],
          if (childrenList.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Child Relationships',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...childrenList.map((child) {
              final childEntities =
                  _selectedEntity.getChild((child as Child).code) as Entities?;
              final childCount = childEntities?.length ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: Text(child.code),
                  subtitle: Text(
                    'Destination: ${child.destinationConcept.code}',
                  ),
                  trailing: Text(
                    '$childCount ${childCount == 1 ? 'item' : 'items'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children:
                      childEntities == null
                          ? [const ListTile(title: Text('No children'))]
                          : childEntities.map((childEntity) {
                            return ListTile(
                              title: Text(_getEntityDisplayName(childEntity)),
                              onTap: () {
                                setState(() {
                                  _selectedEntity = childEntity;
                                  _tabController.animateTo(
                                    0,
                                  ); // Switch to entity view
                                });
                              },
                            );
                          }).toList(),
                ),
              );
            }).toList(),
          ],
        ],
      );
    } catch (e) {
      return Center(
        child: Text('Error loading relationships: ${e.toString()}'),
      );
    }
  }

  /// Builds the JSON representation tab.
  Widget _buildJsonTab() {
    try {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          _selectedEntity.toJson(),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      );
    } catch (e) {
      return Center(child: Text('Error displaying JSON: ${e.toString()}'));
    }
  }

  /// Tries to get a human-readable name for an entity
  String _getEntityDisplayName(dynamic entity) {
    try {
      if (entity == null) return 'null';

      // Try common name properties
      for (final prop in ['name', 'title', 'label', 'code', 'id']) {
        try {
          final value = entity.getAttribute(prop);
          if (value != null && value.toString().isNotEmpty) {
            return value.toString();
          }
        } catch (_) {
          // Ignore and try next property
        }
      }

      // Fall back to concept name + ID
      try {
        return '${entity.concept.code} #${entity.oid}';
      } catch (_) {
        // Last resort
        return entity.toString();
      }
    } catch (_) {
      return 'Unknown Entity';
    }
  }
}

/// A simple entity widget that shows entity details
class SimpleEntityWidget extends StatelessWidget {
  final dynamic entity;
  final Function(dynamic) onEntitySelected;

  const SimpleEntityWidget({
    Key? key,
    required this.entity,
    required this.onEntitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTitle(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // Attributes
            const Text(
              'Attributes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAttributes(),
            const SizedBox(height: 16),

            // Relations
            const Text(
              'Relationships',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildRelationshipsSummary(),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    // Try common name properties
    for (final prop in ['name', 'title', 'label', 'code', 'id']) {
      try {
        final value = entity.getAttribute(prop);
        if (value != null && value.toString().isNotEmpty) {
          return '${entity.concept.code}: ${value.toString()}';
        }
      } catch (_) {
        // Ignore and try next property
      }
    }

    return '${entity.concept.code} #${entity.oid}';
  }

  Widget _buildAttributes() {
    final attributes = entity.concept.attributes.toList();

    if (attributes.isEmpty) {
      return const Text('No attributes');
    }

    return Column(
      children:
          attributes.map((attribute) {
            final value = entity.getAttribute(attribute.code);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${attribute.code}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(child: Text(value?.toString() ?? 'null')),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildRelationshipsSummary() {
    final parents = entity.concept.parents.toList();
    final children = entity.concept.children.toList();

    if (parents.isEmpty && children.isEmpty) {
      return const Text('No relationships');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (parents.isNotEmpty) ...[
          const Text('Parents:', style: TextStyle(fontWeight: FontWeight.w500)),
          ...parents.map((parent) {
            final parentEntity = entity.getParent((parent as Parent).code);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap:
                    parentEntity != null
                        ? () => onEntitySelected(parentEntity)
                        : null,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_upward, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${parent.code} → ${parent.destinationConcept.code}',
                      style: TextStyle(
                        color: parentEntity != null ? Colors.blue : Colors.grey,
                        decoration:
                            parentEntity != null
                                ? TextDecoration.underline
                                : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
        if (children.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'Children:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          ...children.map((child) {
            final childEntities =
                entity.getChild((child as Child).code) as Entities?;
            final childCount = childEntities?.length ?? 0;

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_downward, size: 16),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${child.code} → ${child.destinationConcept.code}'),
                      Text(
                        '$childCount ${childCount == 1 ? 'item' : 'items'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      if (childEntities != null && childEntities.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...childEntities.take(3).map((childEntity) {
                                return InkWell(
                                  onTap: () => onEntitySelected(childEntity),
                                  child: Text(
                                    _getEntityName(childEntity),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                );
                              }).toList(),
                              if (childEntities.length > 3)
                                const Text(
                                  '...',
                                  style: TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  String _getEntityName(dynamic entity) {
    // Try common name properties
    for (final prop in ['name', 'title', 'label', 'code', 'id']) {
      try {
        final value = entity.getAttribute(prop);
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      } catch (_) {
        // Ignore and try next property
      }
    }

    return '${entity.concept.code} #${entity.oid}';
  }
}
