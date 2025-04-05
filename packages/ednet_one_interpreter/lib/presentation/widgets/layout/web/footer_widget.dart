import 'package:flutter/material.dart';

/// A footer widget that displays at the bottom of the application.
///
/// This widget provides status information, navigation links, and other
/// utility functions.
class FooterWidget extends StatelessWidget {
  /// Creates a new footer widget.
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text('Connected'),

          const Spacer(),

          // Version info
          const Text('EDNet One Interpreter v0.1.0'),

          const Spacer(),

          // Help button
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20.0),
            tooltip: 'Help',
            onPressed: () => _showHelpDialog(context),
          ),

          // Settings button
          IconButton(
            icon: const Icon(Icons.settings, size: 20.0),
            tooltip: 'Settings',
            onPressed: () {
              // TODO: Implement settings dialog
            },
          ),
        ],
      ),
    );
  }

  /// Shows the help dialog.
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('EDNet One Interpreter Help'),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Navigation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Use the sidebars to select domains, models, and concepts. '
                    'The main area displays details of the selected entity.',
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Visualization',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'The domain visualization tab shows a graphical representation '
                    'of your domain model with concepts and relationships.',
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Keyboard Shortcuts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text('Ctrl+Z: Undo'),
                  Text('Ctrl+Y: Redo'),
                  Text('Ctrl+F: Search'),
                  Text('Ctrl+S: Save'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
