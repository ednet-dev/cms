part of entities_table_wc;

class EntityTable {
  late List<Attribute> nonIncrementAttributes;
  Entities entities;
  Entity? currentEntity;

  var table = querySelector('#entity-table');
  var addButton = querySelector('#add-button');
  var updateButton = querySelector('#update-button');
  var removeButton = querySelector('#remove-button');
  var cancelButton = querySelector('#cancel-button');

  EntitiesTable entitiesTable;

  EntityTable(this.entitiesTable, this.entities) {
    nonIncrementAttributes = entities.concept.nonIncrementAttributes;
    addEventHandlers();
    display();
    firstField().focus();
  }

  void addEventHandlers() {
    (addButton)?.onClick.listen(addEntity);
    updateButton?.onClick.listen(updateEntity);
    removeButton?.onClick.listen(removeEntity);
    cancelButton?.onClick.listen(cancelCommand);
  }

  void display() {
    addCaption();
    for (final attribute in nonIncrementAttributes) {
      addRow(attribute);
    }
  }

  void addCaption() {
    final tableCaption = TableCaptionElement();
    tableCaption.text = entities.concept.label;
    table?.nodes.add(tableCaption);
  }

  void addRow(Attribute attribute) {
    final row = Element.tr();

    final thElement = Element.th();
    thElement.text = attribute.label;
    row.nodes.add(thElement);

    final tdElement = Element.td();
    var element;
    if (attribute.type?.code == 'bool') {
      element = CheckboxInputElement();
    } else if (attribute.type?.code == 'Description') {
      element = TextAreaElement();
      element.classes.add('entity-table area');
    } else {
      element = InputElement();
    }
    if (attribute.required) {
      element.attributes['required'] = 'required';
    }
    if (attribute.length > 0) {
      element.attributes['size'] = attribute.length.toString();
    }
    if (attribute.type?.code == 'Email') {
      element.attributes['type'] = 'email';
    }
    tdElement.nodes.add(element);
    row.nodes.add(tdElement);

    row.id = attribute.oid.toString();
    table?.nodes.add(row);
  }

  dynamic firstField() {
    return (table as TableElement).rows[0].nodes[1].nodes[0];
  }

  dynamic rowField(TableRowElement row) {
    return row.nodes[1].nodes[0];
  }

  TableRowElement? findRow(Attribute attribute) {
    for (var i = 0; i < (table as TableElement).rows.length; i++) {
      final row = (table as TableElement).rows[i];
      if (row.id == attribute.oid.toString()) {
        return row;
      }
    }
    return null;
  }

  void setRow(var entity, Attribute attribute) {
    final dRow = findRow(attribute);
    final field = rowField(dRow!);
    final attributeValue = entity.getStringOrNullFromAttribute(attribute.code);
    if (attribute.type?.code == 'bool') {
      if (attributeValue == 'true') {
        field.checked = true;
      } else {
        field.checked = false;
      }
    } else {
      field.value = attributeValue;
    }
  }

  void emptyData() {
    for (var i = 0; i < (table as TableElement).rows.length; i++) {
      final row = (table as TableElement).rows[i];
      final field = rowField(row);
      final attribute = getAttribute(row);
      if (attribute?.type?.code == 'bool') {
        field.checked = false;
      } else {
        field.value = '';
      }
    }
  }

  Property? getAttribute(var row) {
    final oid = Oid.ts(int.parse(row.id));
    return entities.concept.attributes.singleWhereOid(oid);
  }

  void setEntity(var entity) {
    for (final attribute in nonIncrementAttributes) {
      setRow(entity, attribute);
    }
    currentEntity = entity;
  }

  void addEntity(Event e) {
    final newEntity = entities.newEntity();
    for (final attribute in nonIncrementAttributes) {
      final row = findRow(attribute);
      if (attribute.type?.code == 'bool') {
        newEntity.setAttribute(attribute.code, rowField(row!).checked);
      } else {
        final value = rowField(row!).value;
        if (value != '') {
          if (attribute.type?.validate(value)) {
            newEntity.setStringToAttribute(attribute.code, value);
          }
        }
      }
    }
    entities.add(newEntity);
    entitiesTable.display();
    entitiesTable.save();
    setEntity(newEntity);
    firstField().focus();
  }

  void updateEntity(Event e) {
    final nonIdentifierAttributes =
        currentEntity?.concept.nonIdentifierAttributes;
    if (nonIdentifierAttributes == null) {
      return;
    }

    for (final attribute in nonIdentifierAttributes) {
      if (attribute.increment == null) {
        final row = findRow(attribute);
        if (attribute.type?.code == 'bool') {
          currentEntity?.setAttribute(attribute.code, rowField(row!).checked);
        } else {
          final value = rowField(row!).value;
          if (attribute.required) {
            if (value != '') {
              if (attribute.type?.validate(value)) {
                currentEntity?.setStringToAttribute(attribute.code, value);
              }
            }
          } else {
            if (value != '') {
              if (attribute.type?.validate(value)) {
                currentEntity?.setStringToAttribute(attribute.code, value);
              }
            } else {
              currentEntity?.setStringToAttribute(attribute.code, 'N/A');
            }
          }
        }
      }
    }
    entitiesTable.display();
    entitiesTable.save();
    firstField().focus();
  }

  void removeEntity(Event e) {
    if (removeButton?.text == 'Remove') {
      removeButton?.text = 'Confirm';
    } else {
      final removed = entities.remove(currentEntity as Entity);
      assert(removed);
      entitiesTable.display();
      entitiesTable.save();
      emptyData();
      firstField().focus();
      currentEntity = null;
      removeButton?.text = 'Remove';
    }
  }

  void cancelCommand(Event e) {
    emptyData();
    firstField().focus();
    currentEntity = null;
  }
}
