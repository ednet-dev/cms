import 'package:flutter/material.dart';
import 'semantic_pinning_service.dart';

/// Dialog for viewing and managing all pins for a specific model
class ModelPinManagerDialog extends StatefulWidget {
  /// The model code to manage pins for
  final String modelCode;

  /// Optional title for the dialog
  final String? title;

  /// Constructor for ModelPinManagerDialog
  const ModelPinManagerDialog({super.key, required this.modelCode, this.title});

  /// Show the dialog
  static Future<void> show(
    BuildContext context,
    String modelCode, {
    String? title,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ModelPinManagerDialog(modelCode: modelCode, title: title);
      },
    );
  }

  @override
  State<ModelPinManagerDialog> createState() => _ModelPinManagerDialogState();
}

class _ModelPinManagerDialogState extends State<ModelPinManagerDialog> {
  late SemanticPinningService _pinningService;
  Set<String> _pinnedArtifacts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pinningService = SemanticPinningService();
    _loadPinnedArtifacts();
  }

  /// Load all pinned artifacts for the model
  Future<void> _loadPinnedArtifacts() async {
    await _pinningService.initialize();

    if (mounted) {
      setState(() {
        _pinnedArtifacts = _pinningService.getPinnedArtifactsForModel(
          widget.modelCode,
        );
        _isLoading = false;
      });
    }
  }

  /// Clear all pins for the model
  Future<void> _clearAllPins() async {
    await _pinningService.clearModelPins(widget.modelCode);

    if (mounted) {
      setState(() {
        _pinnedArtifacts = {};
      });
    }
  }

  /// Unpin a specific artifact
  Future<void> _unpinArtifact(String artifactId) async {
    await _pinningService.unpinArtifact(widget.modelCode, artifactId);

    if (mounted) {
      setState(() {
        _pinnedArtifacts.remove(artifactId);
      });
    }
  }

  /// Get a display name from the artifact ID
  String _getDisplayName(String artifactId) {
    // Parse the artifact ID to get a more user-friendly name
    if (artifactId.startsWith('attribute_')) {
      final parts = artifactId.split('_');
      if (parts.length >= 2) {
        return 'Attribute: ${parts[1]}';
      }
    }

    // Default fallback
    return artifactId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = widget.title ?? 'Pinned Items for ${widget.modelCode}';

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(colorScheme),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (_pinnedArtifacts.isNotEmpty)
          TextButton(
            onPressed: () {
              _clearAllPins();
            },
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: const Text('Clear All Pins'),
          ),
      ],
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    if (_pinnedArtifacts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No pinned items for this model',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'The following items will remain visible regardless of screen size:',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _pinnedArtifacts.length,
            itemBuilder: (context, index) {
              final artifactId = _pinnedArtifacts.elementAt(index);
              return ListTile(
                title: Text(_getDisplayName(artifactId)),
                subtitle: Text(
                  artifactId,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.push_pin, size: 16),
                  tooltip: 'Unpin this item',
                  onPressed: () => _unpinArtifact(artifactId),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
