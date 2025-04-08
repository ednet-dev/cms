import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A showcase component for demonstrating the ResponsiveSemanticWrapper
class SemanticShowcase extends StatefulWidget {
  /// Constructor
  const SemanticShowcase({Key? key}) : super(key: key);

  @override
  State<SemanticShowcase> createState() => _SemanticShowcaseState();
}

class _SemanticShowcaseState extends State<SemanticShowcase> {
  DisclosureLevel _currentLevel = DisclosureLevel.basic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semantic Components Showcase'),
        actions: [
          // Disclosure level selector
          PopupMenuButton<DisclosureLevel>(
            icon: const Icon(Icons.visibility),
            tooltip: 'Change disclosure level',
            onSelected: (level) {
              setState(() {
                _currentLevel = level;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DisclosureLevel.minimal,
                child: Text('Minimal'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.basic,
                child: Text('Basic'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.intermediate,
                child: Text('Intermediate'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.advanced,
                child: Text('Advanced'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.complete,
                child: Text('Complete'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current disclosure level
            Text(
              'Current Disclosure Level: ${_currentLevel.toString().split('.').last}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Showcase different disclosure levels
            _buildDisclosureLevelDemo(context),
            const SizedBox(height: 32),

            // Showcase semantic pinning
            _buildSemanticPinningDemo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclosureLevelDemo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disclosure Level Demo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Components with different disclosure levels
            _buildDisclosureComponent(
              DisclosureLevel.minimal,
              Colors.grey.shade100,
              'Minimal information (always visible)',
            ),

            _buildDisclosureComponent(
              DisclosureLevel.basic,
              Colors.blue.shade100,
              'Basic information for regular users',
            ),

            _buildDisclosureComponent(
              DisclosureLevel.intermediate,
              Colors.green.shade100,
              'Intermediate details for power users',
            ),

            _buildDisclosureComponent(
              DisclosureLevel.advanced,
              Colors.orange.shade100,
              'Advanced information for administrators',
            ),

            _buildDisclosureComponent(
              DisclosureLevel.complete,
              Colors.red.shade100,
              'Complete technical details for developers',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclosureComponent(
    DisclosureLevel level,
    Color backgroundColor,
    String content,
  ) {
    final String artifactId = 'demo_${level.toString().split('.').last}';

    // Simple responsive wrapper without using currentDisclosureLevel
    // This will be visible based on whether its disclosure level is less than or
    // equal to the current disclosure level
    if (level.index <= _currentLevel.index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('[$level] $content'),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSemanticPinningDemo(BuildContext context) {
    // Define some items that can be pinned
    const pinnableItems = [
      'Project Overview',
      'Task List',
      'Team Members',
      'Project Timeline',
      'Budget Report',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semantic Pinning Demo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Pinned items display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pinned Items:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // This would normally use StreamBuilder to show real-time pins
                  const Text('(Tap items below to pin/unpin)'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // List of items that can be pinned
            ...pinnableItems.map((item) => ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.push_pin),
                    onPressed: () {
                      final id = item.toLowerCase().replaceAll(' ', '_');
                      // In a real app, this would actually pin/unpin
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pinned: $item'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
