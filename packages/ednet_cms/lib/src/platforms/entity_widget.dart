part of ednet_cms;

// Widget for String attribute
class StringAttributeWidget extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;

  StringAttributeWidget(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
    );
  }
}

// Widget for int attribute
class IntAttributeWidget extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  IntAttributeWidget(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: value.toString()),
      keyboardType: TextInputType.number,
      onChanged: (text) => onChanged(int.tryParse(text) ?? 0),
    );
  }
}

// Widget for double attribute
class DoubleAttributeWidget extends StatelessWidget {
  final String label;
  final double value;
  final Function(double) onChanged;

  DoubleAttributeWidget(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: value.toString()),
      keyboardType: TextInputType.number,
      onChanged: (text) => onChanged(double.tryParse(text) ?? 0.0),
    );
  }
}

// Widget for bool attribute
class BoolAttributeWidget extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  BoolAttributeWidget(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// Widget for DateTime attribute
class DateTimeAttributeWidget extends StatelessWidget {
  final String label;
  final DateTime value;
  final Function(DateTime) onChanged;

  DateTimeAttributeWidget(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
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
          child: Text(value.toLocal().toString().split(' ')[0]),
        ),
      ],
    );
  }
}

class EntityWidget extends StatelessWidget {
  final Entity entity;

  EntityWidget({required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: entity.concept.attributes.map((attribute) {
          var value = entity.getAttribute(attribute.code);
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
        }).toList(),
      ),
    );
  }
}
