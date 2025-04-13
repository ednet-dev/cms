/// A simplified test version of the Flutter UI shell for EDNet Core domain modeling
library test_core_flutter;

// Imports
import 'dart:async';
import 'package:flutter/material.dart';

import '../../ednet_core_flutter.dart';

/// Basic entity
class Entity<T> {
  String? _code;

  String get code => _code ?? '';

  set code(String? value) {
    _code = value;
  }
}

/// Domain class for testing
class Domain {
  final String code;
  final Models models = Models();

  Domain(this.code);
}

/// Model class for testing
class Model {
  final Domain domain;
  final String code;
  final Concepts concepts = Concepts();

  Model(this.domain, this.code) {
    domain.models.add(this);
  }
}

/// Concept class for testing
class Concept {
  final Model model;
  final String code;
  bool entry = false;

  Concept(this.model, this.code) {
    model.concepts.add(this);
  }
}

/// Collection of models
class Models {
  final List<Model> _models = [];

  void add(Model model) {
    _models.add(model);
  }

  Model get first => _models.first;

  bool get isEmpty => _models.isEmpty;

  int get length => _models.length;
}

/// Collection of concepts
class Concepts {
  final List<Concept> _concepts = [];

  void add(Concept concept) {
    _concepts.add(concept);
  }

  bool get isEmpty => _concepts.isEmpty;

  int get length => _concepts.length;
}

/// Shell app configuration

/// Development Mode Channel message types
class DevModeMessageTypes {
  static const String devModeStatus = 'dev_mode_status';
  static const String loadSampleData = 'load_sample_data';
  static const String clearSampleData = 'clear_sample_data';
  static const String toggleDevMode = 'toggle_dev_mode';
}

/// Simple UX message for testing
class UXMessage {
  final String type;
  final Map<String, dynamic> payload;
  final String source;

  UXMessage({required this.type, required this.payload, required this.source});

  static UXMessage create({
    required String type,
    required Map<String, dynamic> payload,
    required String source,
  }) {
    return UXMessage(type: type, payload: payload, source: source);
  }
}

/// Shell app implementation for testing
class ShellApp {
  final Domain domain;
  final List<Domain> domains;
  final ShellConfiguration configuration;
  final Map<String, List<Map<String, dynamic>>> _entityStorage = {};

  ShellApp({
    required this.domain,
    this.domains = const [],
    required this.configuration,
  });

  /// Navigate to a path
  void navigateTo(String path, {String? label}) {
    // Simplified for testing
  }

  /// Load entities from a concept
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) async {
    if (_entityStorage.containsKey(conceptCode)) {
      return _entityStorage[conceptCode] ?? [];
    }

    if (configuration.features.contains('development_mode')) {
      // Return sample data in development mode
      return [
        {
          'id': 'dev-1',
          'title': 'Development Task',
          'priority': 'high',
          'status': 'in_progress',
        },
      ];
    }
    return [];
  }

  /// Save an entity
  Future<void> saveEntity(
    String conceptCode,
    Map<String, dynamic> entity,
  ) async {
    if (!_entityStorage.containsKey(conceptCode)) {
      _entityStorage[conceptCode] = [];
    }
    _entityStorage[conceptCode]!.add(entity);
  }
}

/// Development Mode Channel Adapter
class DevelopmentModeChannelAdapter {
  final ShellApp shellApp;
  final bool _isDevModeActive = false;

  bool get isDevModeActive => _isDevModeActive;

  DevelopmentModeChannelAdapter(this.shellApp);
}

/// Development Mode Control Panel Widget
class DevelopmentModeControlPanel extends StatefulWidget {
  final DevelopmentModeChannelAdapter adapter;

  const DevelopmentModeControlPanel({Key? key, required this.adapter})
      : super(key: key);

  @override
  State<DevelopmentModeControlPanel> createState() =>
      _DevelopmentModeControlPanelState();
}

class _DevelopmentModeControlPanelState
    extends State<DevelopmentModeControlPanel> {
  bool _showSampleDataTools = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.code, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Development Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                ),
                const Spacer(),
                Switch(
                  value: widget.adapter.isDevModeActive || _showSampleDataTools,
                  onChanged: (value) {
                    // Toggle dev mode for testing
                    setState(() {
                      _showSampleDataTools = value;
                      (widget.adapter as dynamic)._isDevModeActive = value;
                    });
                  },
                  activeColor: Colors.purple,
                ),
              ],
            ),
            if (widget.adapter.isDevModeActive || _showSampleDataTools) ...[
              const SizedBox(height: 16),
              const Text('Sample Data Tools'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Load Tasks'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[200],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Load Projects'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[200],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
