part of ednet_cms;

class StringAttributeWidget extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;

  StringAttributeWidget({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(labelText: label)
            .applyDefaults(Theme.of(context).inputDecorationTheme),
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

  IntAttributeWidget({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(labelText: label)
            .applyDefaults(Theme.of(context).inputDecorationTheme),
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

  DoubleAttributeWidget({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(labelText: label)
            .applyDefaults(Theme.of(context).inputDecorationTheme),
        controller: TextEditingController(text: value.toString()),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: (text) => onChanged(double.tryParse(text) ?? 0.0),
      ),
    );
  }
}

class BoolAttributeWidget extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  BoolAttributeWidget({
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

  DateTimeAttributeWidget({
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
              DateTime? picked = await showDatePicker(
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
      return entity.getAttribute('firstName').toString() +
          ' ' +
          entity.getAttribute('lastName').toString();
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
        ? entity.getAttribute('description').toString().substring(0, 50) +
        '...'
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

  EntityDetailScreen({required this.entity});

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

  EntityWidget({required this.entity, this.onEntitySelected});

  @override
  Widget build(BuildContext context) {
    try {
      // access concept
      entity.concept;
      print('Concept ${entity.concept} is set for entity: ${entity}');
    } catch (e) {
      print('Error: Concept is not set for entity: ${entity}');
      return Center(
        child: Text(
          "*** concept is not set ***\nSee also: https://flutter.dev/docs/testing/errors",
          style: TextStyle(color: Colors.yellow, fontSize: 16),
        ),
      );
    }
    print('Rendering entity with concept: ${entity.concept?.code}');

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...entity.concept.attributes.map((attribute) {
              var value = entity.getAttribute(attribute.code);
              return _buildAttributeWidget(
                  attribute as Attribute, value, context);
            }).toList(),
            ...entity.concept.parents.map((parent) {
              var parentEntity = entity.getParent(parent.code) as Entity;
              return ListTile(
                title: Text(getTitle(parentEntity)),
                onTap: () {
                  if (onEntitySelected != null) {
                    onEntitySelected!(parentEntity);
                  }
                },
              );
            }).toList(),
            ...entity.concept.children.map((child) {
              var childEntities = entity.getChild(child.code) as Entities?;
              return childEntities != null
                  ? ExpansionTile(
                      title: Text(
                        child.codeFirstLetterUpper,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      children: childEntities.map((childEntity) {
                        return ListTile(
                          title: Text(
                            getTitle(childEntity as Entity),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          onTap: () {
                            if (onEntitySelected != null) {
                              onEntitySelected!(childEntity as Entity);
                            }
                          },
                        );
                      }).toList(),
                    )
                  : Container();
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeWidget(
      Attribute attribute, dynamic value, BuildContext context) {
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

  EntitiesWidget({
    required this.entities,
    required this.onEntitySelected,
    required this.bookmarkManager,
    required void Function(Bookmark bookmark) onBookmarkCreated,
  });

  @override
  _EntitiesWidgetState createState() => _EntitiesWidgetState();
}

class _EntitiesWidgetState extends State<EntitiesWidget> {
  List<FilterCriteria> _filters = [];
  List<Entity> _filteredEntities = [];

  ScrollController _scrollController = ScrollController();
  bool _isBookmarking = false;
  TextEditingController _bookmarkTitleController = TextEditingController();

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
      _filteredEntities = widget.entities.where((entity) {
        for (var filter in _filters) {
          if (!_matchesFilter(entity as Entity, filter)) {
            return false;
          }
        }
        return true;
      }).toList() as List<Entity>;
    });
  }

  bool _matchesFilter(Entity entity, FilterCriteria filter) {
    final attributeValue = entity.getAttribute(filter.attribute)?.getValue();
    switch (filter.operator) {
      case '=':
        return attributeValue == filter.value;
      case '!=':
        return attributeValue != filter.value;
      case '>':
        return attributeValue > filter.value;
      case '<':
        return attributeValue < filter.value;
      // Add more operators as needed
      default:
        return false;
    }
  }

  void _loadMoreEntities() {
    // Implement logic to load more entities if available
  }

  void _addFilter(FilterCriteria filter) {
    setState(() {
      _filters.add(filter);
      _applyFilters();
    });
  }

  void _createBookmark() async {
    setState(() {
      _isBookmarking = true;
    });
  }

  void _saveBookmark() async {
    final bookmarkTitle = _bookmarkTitleController.text;
    if (bookmarkTitle.isNotEmpty) {
      final bookmark = Bookmark(
        title: bookmarkTitle,
        url: Uri(path: '/entities', queryParameters: {
          'filters': _filters
              .map((filter) =>
                  '${filter.attribute}:${filter.operator}:${filter.value}')
              .join(','),
          'title': bookmarkTitle,
        }).toString(),
      );

      await widget.bookmarkManager.addBookmark(bookmark);
      widget.onEntitySelected(bookmark);
    }
    setState(() {
      _isBookmarking = false;
      _bookmarkTitleController.clear();
    });
  }

  void _cancelBookmark() {
    setState(() {
      _isBookmarking = false;
      _bookmarkTitleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredEntities.length,
      itemBuilder: (context, index) {
        final entity = _filteredEntities[index];
        return ListTile(
          title:
              Text(entity.getStringFromAttribute('name') ?? 'Unnamed Entity'),
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

  DashboardScreen({required this.domains});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

  DomainTile({required this.domain});

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
            Icon(Icons.domain, size: 100),
            Text(domain.code, style: TextStyle(fontSize: 24)),
            Text(domain.description),
          ],
        ),
      ),
    );
  }
}

class DomainDetailScreen extends StatelessWidget {
  final Domain domain;

  DomainDetailScreen({required this.domain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(domain.code),
      ),
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

  ModelTile({required this.model, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ModelDetailScreen(domain: domain, model: model),
            ),
          );
        },
        child: Column(
          children: [
            Icon(Icons.model_training, size: 100),
            Text(model.code, style: TextStyle(fontSize: 24)),
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

  ModelDetailScreen({required this.domain, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.code),
      ),
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

  AggregateTile(
      {required this.concept, required this.model, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AggregateDetailScreen(
                  domain: domain, model: model, concept: concept),
            ),
          );
        },
        child: Column(
          children: [
            Icon(Icons.adjust, size: 100),
            Text(concept.code, style: TextStyle(fontSize: 24)),
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

  AggregateDetailScreen(
      {required this.domain, required this.model, required this.concept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(concept.code),
      ),
      body: ListView.builder(
        itemCount: concept.attributes.length,
        itemBuilder: (context, index) {
          final attribute = concept.attributes.elementAt(index);
          return AttributeTile(
              attribute: attribute as Attribute,
              concept: concept,
              model: model);
        },
      ),
    );
  }
}

class AttributeTile extends StatelessWidget {
  final Attribute attribute;
  final Concept concept;
  final Model model;

  AttributeTile(
      {required this.attribute, required this.concept, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttributeDetailScreen(
                  model: model, concept: concept, attribute: attribute),
            ),
          );
        },
        child: Column(
          children: [
            Icon(Icons.adjust, size: 100),
            Text(attribute.code, style: TextStyle(fontSize: 24)),
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

  AttributeDetailScreen(
      {required this.model, required this.concept, required this.attribute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attribute.code),
      ),
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
    return prefs.getStringList(_bookmarkKey) == false
        ? []
        : []
            .map((bookmark) =>
                Bookmark(url: bookmark['url'], title: bookmark['title']))
            .toList();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.add(bookmark);
    await prefs.setStringList(
        _bookmarkKey, bookmarks.map((bookmark) => bookmark.toJson()).toList());
  }

  Future<void> removeBookmark(String bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.remove(bookmark);
    await prefs.setStringList(
        _bookmarkKey, bookmarks.map((bookmark) => bookmark.toJson()).toList());
  }
}

class ModelsWidget extends StatelessWidget {
  final Models models;
  final void Function(Model model) onModelSelected;

  ModelsWidget({required this.models, required this.onModelSelected});

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
