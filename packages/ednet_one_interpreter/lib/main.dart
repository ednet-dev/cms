import 'package:flutter/material.dart';
import 'package:ednet_one_interpreter/theme.dart';

/// This main application serves as a showcase for the ednet_one_interpreter functionality.
void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatefulWidget {
  /// Creates a new MyApp instance.
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  String currentTheme = 'Default';

  @override
  Widget build(BuildContext context) {
    final themeData =
        isDarkMode
            ? themes['dark']![currentTheme]!
            : themes['light']![currentTheme]!;

    return MaterialApp(
      title: 'EDNet One Interpreter',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EDNet One Interpreter'),
          actions: [
            // Theme toggle button
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
            // Theme selector
            PopupMenuButton<String>(
              icon: const Icon(Icons.color_lens),
              onSelected: (String value) {
                setState(() {
                  currentTheme = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return themes[isDarkMode ? 'dark' : 'light']!.keys.map((
                  String theme,
                ) {
                  return PopupMenuItem<String>(
                    value: theme,
                    child: Text(theme),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Row(
          children: [
            // Left sidebar
            Expanded(
              flex: 2,
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Entry $index'),
                      leading: Icon(
                        index < 3 ? Icons.star : Icons.circle,
                        color:
                            index < 3
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
            // Main content
            Expanded(
              flex: 8,
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Domain Model Viewer',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard_customize,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Welcome to EDNet One Interpreter',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'A visualization tool for complex domain models',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Demo'),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right sidebar
            Expanded(
              flex: 2,
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Model $index'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
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
              const Text('Ready'),
              const Spacer(),
              const Text('Entities: 25'),
              const SizedBox(width: 16.0),
              const Text('Models: 8'),
              const SizedBox(width: 16.0),
              const Text('Domains: 2'),
            ],
          ),
        ),
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

  MockConcept({
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

  MockModel({required this.code, required this.concepts});

  @override
  String toString() => code;
}

class MockEntity {
  final String name;
  final Map<String, String> properties;

  MockEntity(this.name, this.properties);

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
