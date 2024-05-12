part of ednet_cms;

class EntityWidget<E extends Entity<E>> extends StatelessWidget {
  final E entity;

  EntityWidget({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entity.concept.label ?? 'Entity')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...buildAttributeWidgets(entity, context),
            const Divider(),
            ...buildRelationshipWidgets(entity),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAttributeWidgets(E entity, BuildContext context) {
    return entity.concept.attributes.map<Widget>((attribute) {
      Widget field;
      switch (attribute.type) {
        case 'DateTime':
          field = TextFormField(
            initialValue:
                entity.getAttribute<DateTime>(attribute.code)?.toString(),
            decoration: InputDecoration(labelText: attribute.label),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: entity.getAttribute<DateTime>(attribute.code) ??
                    DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) entity.setAttribute(attribute.code, picked);
            },
          );
          break;
        case 'bool':
          field = Switch(
            value: entity.getAttribute<bool>(attribute.code) ?? false,
            onChanged: (bool value) {
              entity.setAttribute(attribute.code, value);
            },
          );
          break;
        case 'int':
        case 'double':
        case 'String':
        default:
          field = TextFormField(
            initialValue: entity.getAttribute<String>(attribute.code),
            decoration: InputDecoration(labelText: attribute.label),
            onChanged: (value) => entity.setAttribute(attribute.code, value),
          );
          break;
      }
      return ListTile(
          title: Text(attribute.label ?? attribute.code), subtitle: field);
    }).toList();
  }

  List<Widget> buildRelationshipWidgets(E entity) {
    List<Widget> widgets = [];
    for (Parent parent in entity.concept.parents as List<Parent>) {
      widgets.add(ExpansionTile(
        title: Text('Parent: ${parent.label ?? parent.code}'),
        children: <Widget>[
          Text(entity.getParent(parent.code ?? '')?.toString() ?? 'None'),
        ],
      ));
    }
    for (Child child in entity.concept.children as List<Child>) {
      widgets.add(ExpansionTile(
        title: Text('Child: ${child.label ?? child.code}'),
        children: <Widget>[
          Text(entity.getChild(child.code)?.toString() ?? 'None'),
        ],
      ));
    }
    return widgets;
  }
}
