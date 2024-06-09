part of ednet_cms;

// Widget for String attribute
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

// Widget for int attribute
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

// Widget for double attribute
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

// Widget for bool attribute
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

// Widget for DateTime attribute
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

// Function to get title from entity
String getTitle(Entity<dynamic> entity) {
  var name = entity.getStringFromAttribute('name');
  var title = entity.getStringFromAttribute('title');
  return name ?? title ?? 'Unnamed Entity';
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

// Widgets for rendering entity attributes
class EntityWidget extends StatelessWidget {
  final Entity entity;
  final void Function(Entity entity)? onEntitySelected;

  EntityWidget({required this.entity, this.onEntitySelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
                      children: childEntities.map((childEntity) {
                        return ListTile(
                    title: Text(
                      getTitle(childEntity),
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelMedium,
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

// Widget for Entities, updated to navigate models and domains
class EntitiesWidget extends StatelessWidget {
  final Entities entities;
  final void Function(Entity entity)? onEntitySelected;
  final Domain domain;
  final Model model;

  EntitiesWidget({
    required this.entities,
    this.onEntitySelected,
    required this.domain,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Back to Models'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: entities.length,
          itemBuilder: (context, index) {
            var entity = entities.elementAt(index);
            return ListTile(
              title: Text(getTitle(entity)),
              onTap: () {
                if (onEntitySelected != null) {
                  onEntitySelected!(entity as Entity);
                }
              },
            );
          },
        ),
      ],
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
      body: EntitiesWidget(
        entities: concept.attributes,
        domain: domain,
        model: model,
        onEntitySelected: (entity) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityDetailScreen(entity: entity),
            ),
          );
        },
      ),
    );
  }
}
