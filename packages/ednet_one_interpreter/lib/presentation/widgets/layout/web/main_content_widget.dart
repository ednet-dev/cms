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
      return const Center(child: Text('No entities selected'));
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
            const Text('Entity: '),
            const SizedBox(width: 8.0),
            DropdownButton<dynamic>(
              value: _selectedEntity,
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
                      child: Text(entity.code),
                    );
                  }).toList(),
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
            Tab(text: 'Attributes'),
            Tab(text: 'Parents'),
            Tab(text: 'Children'),
            Tab(text: 'JSON'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAttributesTab(),
              _buildParentsTab(),
              _buildChildrenTab(),
              _buildJsonTab(),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the attributes tab.
  Widget _buildAttributesTab() {
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
                trailing: Text(value?.toString() ?? 'null'),
              ),
            );
          },
        );
  }

  /// Builds the parents tab.
  Widget _buildParentsTab() {
    final concept = _selectedEntity.concept;
    final parentsList = concept.parents.toList();

    return parentsList.isEmpty
        ? const Center(child: Text('No parent relationships'))
        : ListView.builder(
          itemCount: parentsList.length,
          itemBuilder: (context, index) {
            final parent = parentsList[index] as Parent;
            final parentEntity = _selectedEntity.getParent(parent.code);

            return Card(
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: ListTile(
                title: Text(parent.code),
                subtitle: Text(
                  'Destination: ${parent.destinationConcept.code}${parent.required ? " (Required)" : ""}',
                ),
                trailing:
                    parentEntity == null
                        ? const Text('null')
                        : Text(parentEntity.code),
              ),
            );
          },
        );
  }

  /// Builds the children tab.
  Widget _buildChildrenTab() {
    final concept = _selectedEntity.concept;
    final childrenList = concept.children.toList();

    return childrenList.isEmpty
        ? const Center(child: Text('No child relationships'))
        : ListView.builder(
          itemCount: childrenList.length,
          itemBuilder: (context, index) {
            final child = childrenList[index] as Child;
            final childEntities =
                _selectedEntity.getChild(child.code) as Entities?;

            return Card(
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: ListTile(
                title: Text(child.code),
                subtitle: Text('Destination: ${child.destinationConcept.code}'),
                trailing:
                    childEntities == null
                        ? const Text('0')
                        : Text(childEntities.length.toString()),
                onTap: () {
                  if (childEntities != null && childEntities.isNotEmpty) {
                    // TODO: Navigate to child entities (implement shift layout)
                  }
                },
              ),
            );
          },
        );
  }

  /// Builds the JSON representation tab.
  Widget _buildJsonTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: SelectableText(
        _selectedEntity.toJson(),
        style: const TextStyle(fontFamily: 'monospace'),
      ),
    );
  }
}
