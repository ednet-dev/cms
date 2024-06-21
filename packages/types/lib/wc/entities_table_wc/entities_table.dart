part of entities_table_wc;

class EntitiesTable {
  late Entities entities;
  late List<Attribute> essentialAttributes;

  var table = querySelector('#entities-table');

  var context;

  EntitiesTable(this.context, this.entities) {
    essentialAttributes = entities.concept.essentialAttributes;
    final incrementAttributes = entities.concept.incrementAttributes;
    var idIncrementAttribute = false;
    for (final attribute in incrementAttributes) {
      if (attribute.identifier) {
        idIncrementAttribute = true;
        break;
      }
    }
    if (idIncrementAttribute) {
      display(sort: false);
    } else {
      display();
    }
    addEventHandlers();
  }

  void addEventHandlers() {
    final identifierAttributes = entities.concept.identifierAttributes;
    for (final attribute in identifierAttributes) {
      final hRow = table!.nodes[1] as TableRowElement;
      for (final thElement in hRow.nodes as List<TableCellElement>) {
        if (thElement.text == attribute.code) {
          thElement.onClick.listen((Event e) {
            entities.sort((e1, e2) {
              final v1 = e1.getAttribute(attribute.code);
              final v2 = e2.getAttribute(attribute.code);
              return v1.compareTo(v2);
            });
            display(sort: false);
          });
        }
      }
    }
  }

  void display({sort = true}) {
    removeRows();
    addCaption();
    addHeaderRow();
    if (sort) {
      entities.sort();
    }
    for (final entity in entities) {
      addDataRow(entity as Entity);
    }
  }

  void removeRows() {
    table?.nodes.clear();
  }

  void addCaption() {
    final tableCaption = TableCaptionElement();
    tableCaption.text = entities.concept.labels;
    table?.nodes.add(tableCaption);
  }

  void addHeaderRow() {
    final hRow = Element.tr() as TableRowElement;
    for (final attribute in essentialAttributes) {
      final thElement = Element.th() as TableCellElement;
      thElement.text = attribute.label;
      hRow.nodes.add(thElement);
    }
    table?.nodes.add(hRow);
  }

  void addDataRow(Entity entity) {
    final dRow = Element.tr() as TableRowElement;

    for (final attribute in essentialAttributes) {
      final tdElement = Element.td() as TableCellElement;
      final value = entity.getAttribute(attribute.code);
      if (value != null) {
        tdElement.text = entity.getAttribute(attribute.code).toString();
      }
      dRow.nodes.add(tdElement);
    }

    dRow.id = entity.oid.toString();
    dRow.onClick.listen(selectEntity);
    table?.nodes.add(dRow);
  }

  void selectEntity(Event e) {
    final dRow = (e.target as TableCellElement).parent;
    final idn = int.parse(dRow!.id);
    final entity = entities.singleWhereOid(Oid.ts(idn));
    context.entityTable.setEntity(entity);
  }

  void save() {
    context.save();
  }
}
