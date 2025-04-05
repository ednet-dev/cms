import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

/// Factory class for creating attribute widgets based on attribute type
class AttributeWidgetFactory {
  /// Creates an appropriate widget for the given attribute and value
  static Widget createAttributeWidget({
    required Attribute attribute,
    required dynamic value,
    required Function(dynamic) onValueChanged,
    required BuildContext context,
  }) {
    switch (attribute.type?.code) {
      case 'String':
        return StringAttributeWidget(
          label: attribute.code,
          value: value as String,
          onChanged: (newValue) => onValueChanged(newValue),
        );
      case 'int':
        return IntAttributeWidget(
          label: attribute.code,
          value: value as int,
          onChanged: (newValue) => onValueChanged(newValue),
        );
      case 'double':
        return DoubleAttributeWidget(
          label: attribute.code,
          value: value as double,
          onChanged: (newValue) => onValueChanged(newValue),
        );
      case 'bool':
        return BoolAttributeWidget(
          label: attribute.code,
          value: value as bool,
          onChanged: (newValue) => onValueChanged(newValue),
        );
      case 'DateTime':
        return DateTimeAttributeWidget(
          label: attribute.code,
          value: value as DateTime,
          onChanged: (newValue) => onValueChanged(newValue),
        );
      default:
        return Container();
    }
  }
}

/// Widget for displaying and editing String attributes
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

/// Widget for displaying and editing Int attributes
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

/// Widget for displaying and editing Double attributes
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

/// Widget for displaying and editing Boolean attributes
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

/// Widget for displaying and editing DateTime attributes
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
