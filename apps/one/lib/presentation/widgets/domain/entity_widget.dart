// ignore_for_file: prefer_single_quotes
import 'dart:convert';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StringAttributeWidget extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;

  const StringAttributeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        controller: TextEditingController(text: value),
        onChanged: onChanged,
      ),
    );
  }
}

class IntAttributeWidget extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  const IntAttributeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        controller: TextEditingController(text: value.toString()),
        keyboardType: TextInputType.number,
        onChanged: (text) => onChanged(int.tryParse(text) ?? 0),
      ),
    );
  }
}

class DoubleAttributeWidget extends StatelessWidget {
  final String label;
  final double value;
  final Function(double) onChanged;

  const DoubleAttributeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        controller: TextEditingController(text: value.toString()),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (text) => onChanged(double.tryParse(text) ?? 0.0),
      ),
    );
  }
}

class BoolAttributeWidget extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const BoolAttributeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}

class DateTimeAttributeWidget extends StatelessWidget {
  final String label;
  final DateTime value;
  final Function(DateTime) onChanged;

  const DateTimeAttributeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != value) onChanged(picked);
            },
            child: Text(
              value.toLocal().toString().split(' ')[0],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

String getTitle(Entity entity) {
  if (entity.getAttribute('firstName') != null) {
    if (entity.getAttribute('lastName') != null) {
      return '${entity.getAttribute('firstName')} ${entity.getAttribute('lastName')}';
    }
    return entity.getAttribute('firstName').toString();
  }

  if (entity.getAttribute('name') != null) {
    return entity.getAttribute('name').toString();
  }

  if (entity.getAttribute('title') != null) {
    return entity.getAttribute('title').toString();
  }

  // if have description trim to 50 characters with ...
  if (entity.getAttribute('description') != null) {
    return entity.getAttribute('description').toString().length > 50
        ? '${entity.getAttribute('description').toString().substring(0, 50)}...'
        : entity.getAttribute('description').toString();
  }

  if (entity.getAttribute('id') != null) {
    return entity.getAttribute('id').toString();
  }

  if (entity.getAttribute('code') != null) {
    return entity.getAttribute('code').toString();
  }

  try {
    return entity.concept.code;
  } catch (e) {
    return entity.concept.id.toString();
  }
}

// Widget for entity details screen
class EntityDetailScreen extends StatelessWidget {
  final Entity entity;

  const EntityDetailScreen({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entity.getStringFromAttribute('name') ?? 'Entity Detail'),
      ),
      body: EntityWidget(entity: entity),
    );
  }
}

class EntityWidget extends StatelessWidget {
  final Entity entity;
  final void Function(Entity entity)? onEntitySelected;

  const EntityWidget({super.key, required this.entity, this.onEntitySelected});

  @override
  Widget build(BuildContext context) {
    try {
      // access concept
      entity.concept;
    } catch (e) {
      return const Center(
        child: Text(
          "*** concept is not set ***\nSee also: https://flutter.dev/docs/testing/errors",
          style: TextStyle(color: Colors.yellow, fontSize: 16),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...entity.concept.attributes.map((attribute) {
              final value = entity.getAttribute(attribute.code);
              return _buildAttributeWidget(
                attribute as Attribute,
                value,
                context,
              );
            }),
            ...entity.concept.parents.map((parent) {
              final parentEntity = entity.getParent(parent.code) as Entity;
              return ListTile(
                title: Text(getTitle(parentEntity)),
                onTap: () {
                  if (onEntitySelected != null) {
                    onEntitySelected!(parentEntity);
                  }
                },
              );
            }),
            ...entity.concept.children.map((child) {
              final childEntities = entity.getChild(child.code) as Entities?;
              return childEntities != null
                  ? ExpansionTile(
                    title: Text(
                      child.codeFirstLetterUpper,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    children:
                        childEntities.map((childEntity) {
                          return ListTile(
                            title: Text(
                              getTitle(childEntity as Entity),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onTap: () {
                              if (onEntitySelected != null) {
                                onEntitySelected!(childEntity);
                              }
                            },
                          );
                        }).toList(),
                  )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeWidget(
    Attribute attribute,
    value,
    BuildContext context,
  ) {
    switch (attribute.type?.code) {
      case 'String':
        return StringAttributeWidget(
          label: attribute.code,
          value: value as String,
          onChanged: (newValue) {
            entity.setAttribute(attribute.code, newValue);
          },
        );
      case 'int':
        return IntAttributeWidget(
          label: attribute.code,
          value: value as int,
          onChanged: (newValue) {
            entity.setAttribute(attribute.code, newValue);
          },
        );
      case 'double':
        return DoubleAttributeWidget(
          label: attribute.code,
          value: value as double,
          onChanged: (newValue) {
            entity.setAttribute(attribute.code, newValue);
          },
        );
      case 'bool':
        return BoolAttributeWidget(
          label: attribute.code,
          value: value as bool,
          onChanged: (newValue) {
            entity.setAttribute(attribute.code, newValue);
          },
        );
      case 'DateTime':
        return DateTimeAttributeWidget(
          label: attribute.code,
          value: value as DateTime,
          onChanged: (newValue) {
            entity.setAttribute(attribute.code, newValue);
          },
        );
      default:
        return Container();
    }
  }
}

class EntitiesWidget extends StatefulWidget {
  final Entities entities;
  final void Function(Entity entity) onEntitySelected;
  final BookmarkManager bookmarkManager;

  const EntitiesWidget({
    super.key,
    required this.entities,
    required this.onEntitySelected,
    required this.bookmarkManager,
    required void Function(Bookmark bookmark) onBookmarkCreated,
  });

  @override
  _EntitiesWidgetState createState() => _EntitiesWidgetState();
}

class _EntitiesWidgetState extends State<EntitiesWidget> {
  final List<FilterCriteria> _filters = [];
  List<Entity> _filteredEntities = [];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _applyFilters();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEntities();
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredEntities =
          widget.entities.where((entity) {
                for (final filter in _filters) {
                  if (!_matchesFilter(entity as Entity, filter)) {
                    return false;
                  }
                }
                return true;
              }).toList()
              as List<Entity>;
    });
  }

  bool _matchesFilter(Entity entity, FilterCriteria filter) {
    // Check if entity matches all criteria in the filter
    // for (final criterion in filter.criteria) {
    //   final attributeValue =
    //       entity.getAttribute(criterion.attribute)?.getValue();

    //   // Use string-based comparison for backward compatibility
    //   // and to avoid importing ComparisonOperator directly
    //   final op = criterion.operator.toString().split('.').last;

    //   switch (op) {
    //     case 'equals':
    //       if (attributeValue != criterion.value) return false;
    //       break;
    //     case 'notEquals':
    //       if (attributeValue == criterion.value) return false;
    //       break;
    //     case 'greaterThan':
    //       if (attributeValue is! Comparable ||
    //           attributeValue.compareTo(criterion.value) <= 0) {
    //         return false;
    //       }
    //       break;
    //     case 'lessThan':
    //       if (attributeValue is! Comparable ||
    //           attributeValue.compareTo(criterion.value) >= 0) {
    //         return false;
    //       }
    //       break;
    //     case 'greaterThanOrEquals':
    //       if (attributeValue is! Comparable ||
    //           attributeValue.compareTo(criterion.value) < 0) {
    //         return false;
    //       }
    //       break;
    //     case 'lessThanOrEquals':
    //       if (attributeValue is! Comparable ||
    //           attributeValue.compareTo(criterion.value) > 0) {
    //         return false;
    //       }
    //       break;
    //     case 'contains':
    //       if (attributeValue is! String ||
    //           !attributeValue.contains(criterion.value)) {
    //         return false;
    //       }
    //       break;
    //     case 'startsWith':
    //       if (attributeValue is! String ||
    //           !attributeValue.startsWith(criterion.value)) {
    //         return false;
    //       }
    //       break;
    //     case 'endsWith':
    //       if (attributeValue is! String ||
    //           !attributeValue.endsWith(criterion.value)) {
    //         return false;
    //       }
    //       break;
    //     case 'in_':
    //       if (criterion.value is! List ||
    //           !criterion.value.contains(attributeValue)) {
    //         return false;
    //       }
    //       break;
    //     case 'notIn':
    //       if (criterion.value is! List ||
    //           criterion.value.contains(attributeValue)) {
    //         return false;
    //       }
    //       break;
    //     case 'isNull':
    //       if (attributeValue != null) return false;
    //       break;
    //     case 'isNotNull':
    //       if (attributeValue == null) return false;
    //       break;
    //     default:
    //       return false;
    //   }
    // }

    // If all criteria passed, the entity matches the filter
    return true;
  }

  void _loadMoreEntities() {
    // Implement logic to load more entities if available
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredEntities.length,
      itemBuilder: (context, index) {
        final entity = _filteredEntities[index];
        return ListTile(
          title: Text(
            entity.getStringFromAttribute('name') ?? 'Unnamed Entity',
          ),
          onTap: () {
            widget.onEntitySelected(entity);
          },
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final Domains domains;

  const DashboardScreen({super.key, required this.domains});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: domains.length,
        itemBuilder: (context, index) {
          final domain = domains.elementAt(index);
          return DomainTile(domain: domain);
        },
      ),
    );
  }
}

class DomainTile extends StatelessWidget {
  final Domain domain;

  const DomainTile({super.key, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DomainDetailScreen(domain: domain),
            ),
          );
        },
        child: Column(
          children: [
            const Icon(Icons.domain, size: 100),
            Text(domain.code, style: const TextStyle(fontSize: 24)),
            Text(domain.description),
          ],
        ),
      ),
    );
  }
}

class DomainDetailScreen extends StatelessWidget {
  final Domain domain;

  const DomainDetailScreen({super.key, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(domain.code)),
      body: ListView.builder(
        itemCount: domain.models.length,
        itemBuilder: (context, index) {
          final model = domain.models.elementAt(index);
          return ModelTile(model: model, domain: domain);
        },
      ),
    );
  }
}

class ModelTile extends StatelessWidget {
  final Model model;
  final Domain domain;

  const ModelTile({super.key, required this.model, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ModelDetailScreen(domain: domain, model: model),
            ),
          );
        },
        child: Column(
          children: [
            const Icon(Icons.model_training, size: 100),
            Text(model.code, style: const TextStyle(fontSize: 24)),
            Text(model.description ?? ''),
          ],
        ),
      ),
    );
  }
}

class ModelDetailScreen extends StatelessWidget {
  final Domain domain;
  final Model model;

  const ModelDetailScreen({
    super.key,
    required this.domain,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model.code)),
      body: ListView.builder(
        itemCount: model.entryConcepts.length,
        itemBuilder: (context, index) {
          final concept = model.entryConcepts[index];
          return AggregateTile(concept: concept, model: model, domain: domain);
        },
      ),
    );
  }
}

class AggregateTile extends StatelessWidget {
  final Concept concept;
  final Model model;
  final Domain domain;

  const AggregateTile({
    super.key,
    required this.concept,
    required this.model,
    required this.domain,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AggregateDetailScreen(
                    domain: domain,
                    model: model,
                    concept: concept,
                  ),
            ),
          );
        },
        child: Column(
          children: [
            const Icon(Icons.adjust, size: 100),
            Text(concept.code, style: const TextStyle(fontSize: 24)),
            Text(concept.entry.toString()),
          ],
        ),
      ),
    );
  }
}

class AggregateDetailScreen extends StatelessWidget {
  final Domain domain;
  final Model model;
  final Concept concept;

  const AggregateDetailScreen({
    super.key,
    required this.domain,
    required this.model,
    required this.concept,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(concept.code)),
      body: ListView.builder(
        itemCount: concept.attributes.length,
        itemBuilder: (context, index) {
          final attribute = concept.attributes.elementAt(index);
          return AttributeTile(
            attribute: attribute as Attribute,
            concept: concept,
            model: model,
          );
        },
      ),
    );
  }
}

class AttributeTile extends StatelessWidget {
  final Attribute attribute;
  final Concept concept;
  final Model model;

  const AttributeTile({
    super.key,
    required this.attribute,
    required this.concept,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AttributeDetailScreen(
                    model: model,
                    concept: concept,
                    attribute: attribute,
                  ),
            ),
          );
        },
        child: Column(
          children: [
            const Icon(Icons.adjust, size: 100),
            Text(attribute.code, style: const TextStyle(fontSize: 24)),
            Text(attribute.getStringFromAttribute(attribute.code).toString()),
          ],
        ),
      ),
    );
  }
}

class AttributeDetailScreen extends StatelessWidget {
  final Model model;
  final Concept concept;
  final Attribute attribute;

  const AttributeDetailScreen({
    super.key,
    required this.model,
    required this.concept,
    required this.attribute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(attribute.code)),
      body: ListView(
        children: [
          Text('Attribute: ${attribute.code}'),
          Text('Type: ${attribute.type?.code}'),
          Text('Length: ${attribute.length}'),
          Text('Required: ${attribute.required}'),
          Text('Identifier: ${attribute.identifier}'),
          Text('Derive: ${attribute.derive}'),
        ],
      ),
    );
  }
}

class BookmarkManager {
  static const String _bookmarkKey = 'bookmarks';
  Future<List<Bookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings = prefs.getStringList(_bookmarkKey);
    if (bookmarkStrings == null) return [];

    return bookmarkStrings.map((bookmarkJson) {
      final bookmark = Map<String, dynamic>.from(json.decode(bookmarkJson));
      return Bookmark(url: bookmark['url'], title: bookmark['title']);
    }).toList();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.add(bookmark);
    await prefs.setStringList(
      _bookmarkKey,
      bookmarks
          .map(
            (bookmark) =>
                json.encode({'url': bookmark.url, 'title': bookmark.title}),
          )
          .toList(),
    );
  }

  Future<void> removeBookmark(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((bookmark) => bookmark.url == url);
    await prefs.setStringList(
      _bookmarkKey,
      bookmarks
          .map(
            (bookmark) =>
                json.encode({'url': bookmark.url, 'title': bookmark.title}),
          )
          .toList(),
    );
  }
}

class ModelsWidget extends StatelessWidget {
  final Models models;
  final void Function(Model model) onModelSelected;

  const ModelsWidget({
    super.key,
    required this.models,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models.elementAt(index);
        return ListTile(
          title: Text(model.code),
          onTap: () => onModelSelected(model),
        );
      },
    );
  }
}

class Bookmark extends Entity<Bookmark> {
  String? title;
  String url;

  Bookmark({this.title, required this.url});

  @override
  String toString() {
    return title ?? 'Unnamed Bookmark: $url';
  }
}
