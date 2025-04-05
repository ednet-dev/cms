import 'package:flutter/material.dart';

/// A simplified header widget that shows breadcrumbs for navigation.
class SimpleHeaderWidget extends StatelessWidget {
  final List<String> path;

  const SimpleHeaderWidget({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ...path.asMap().entries.map((entry) {
            final isLast = entry.key == path.length - 1;
            return Row(
              children: [
                InkWell(
                  onTap: isLast ? null : () {},
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                      color:
                          isLast ? Theme.of(context).colorScheme.primary : null,
                    ),
                  ),
                ),
                if (!isLast)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.chevron_right, size: 16),
                  ),
              ],
            );
          }).toList(),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }
}

/// A simplified footer widget that shows status information.
class SimpleFooterWidget extends StatelessWidget {
  const SimpleFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          const SizedBox(width: 8.0),
          const Text('Connected'),
          const Spacer(),
          const Text('Entities: 5'),
          const SizedBox(width: 16.0),
          const Text('Models: 8'),
          const SizedBox(width: 16.0),
          const Text('Domains: 2'),
        ],
      ),
    );
  }
}

/// A simplified left sidebar that displays entries.
class SimpleLeftSidebarWidget extends StatelessWidget {
  final List<MockConcept> concepts;
  final Function(MockConcept) onConceptSelected;

  const SimpleLeftSidebarWidget({
    Key? key,
    required this.concepts,
    required this.onConceptSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: concepts.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final concept = concepts[index];
          return ListTile(
            title: Text(
              concept.code,
              style: TextStyle(
                fontWeight: concept.entry ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text('Attributes: ${concept.attributes.length}'),
            leading: Icon(
              concept.entry ? Icons.star : Icons.circle,
              color:
                  concept.entry
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
            ),
            onTap: () => onConceptSelected(concept),
          );
        },
      ),
    );
  }
}

/// A simplified right sidebar widget displaying models.
class SimpleRightSidebarWidget extends StatelessWidget {
  final List<MockModel> models;
  final Function(MockModel) onModelSelected;

  const SimpleRightSidebarWidget({
    Key? key,
    required this.models,
    required this.onModelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: models.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final model = models[index];
          return ListTile(
            title: Text(model.code),
            subtitle: Text('Concepts: ${model.concepts.length}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onModelSelected(model),
          );
        },
      ),
    );
  }
}

/// A simplified main content widget to display entities.
class SimpleMainContentWidget extends StatelessWidget {
  final MockEntities entities;

  const SimpleMainContentWidget({Key? key, required this.entities})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entities.isEmpty) {
      return const Center(child: Text('No entities selected'));
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Entities',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entities.length,
              itemBuilder: (context, index) {
                final entity = entities.toList()[index];
                return ExpansionTile(
                  title: Text(entity.name),
                  children:
                      entity.properties.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(child: Text(entry.value)),
                            ],
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Mock classes to simulate the domain model
class MockConcept {
  final String code;
  final List<String> attributes;
  final List<String> children;
  final List<String> parents;
  final bool entry;

  const MockConcept({
    required this.code,
    required this.attributes,
    required this.children,
    required this.parents,
    required this.entry,
  });

  @override
  String toString() => code;
}

class MockModel {
  final String code;
  final List<MockConcept> concepts;

  const MockModel({required this.code, required this.concepts});

  @override
  String toString() => code;
}

class MockEntity {
  final String name;
  final Map<String, String> properties;

  const MockEntity(this.name, this.properties);

  @override
  String toString() => name;
}

class MockEntities {
  final List<MockEntity> _entities = [];

  void add(MockEntity entity) {
    _entities.add(entity);
  }

  Iterable<MockEntity> get entities => _entities;

  bool get isEmpty => _entities.isEmpty;

  int get length => _entities.length;

  List<MockEntity> toList() => _entities;
}
