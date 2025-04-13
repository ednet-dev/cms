part of ednet_core_flutter;

/// A widget for exploring a concept and its entities
class ConceptExplorer extends StatefulWidget {
  /// The shell app
  final ShellApp shellApp;

  /// The concept to explore
  final Concept concept;

  /// Constructor
  const ConceptExplorer({
    Key? key,
    required this.shellApp,
    required this.concept,
  }) : super(key: key);

  @override
  State<ConceptExplorer> createState() => _ConceptExplorerState();
}

class _ConceptExplorerState extends State<ConceptExplorer> {
  // For generating IDs
  int _idCounter = 1000;

  /// Current disclosure level
  DisclosureLevel _disclosureLevel = DisclosureLevel.basic;

  /// Collection of entities for the current concept
  List<dynamic> _entities = [];

  /// Loading status
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use the shell's current disclosure level as the initial value
    _disclosureLevel = widget.shellApp.currentDisclosureLevel;

    // Load entities from domain if available
    _loadEntities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concept: ${widget.concept.code}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  // Build content based on entities and state
  Widget _buildContent() {
    if (_entities.isEmpty) {
      return Center(
        child: Text('No ${widget.concept.code} entities found'),
      );
    }

    return ListView.builder(
      itemCount: _entities.length,
      itemBuilder: (context, index) {
        final entity = _entities[index];
        return ListTile(
          title: Text(entity['name'] ?? 'Unnamed Entity'),
          subtitle: Text(entity['id'] ?? 'No ID'),
        );
      },
    );
  }

  /// Load entities from the domain repository
  Future<void> _loadEntities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final conceptCode = widget.concept.code;
      final entities = await widget.shellApp.loadEntities(conceptCode);

      setState(() {
        if (entities.isNotEmpty) {
          _entities = entities;
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading entities: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Generate a unique ID for entities
  String _generateId(String prefix) {
    _idCounter++;
    return '$prefix-$_idCounter';
  }

  /// Save entity form data from controllers to entity map
  Future<void> _saveEntityForm(Map<String, dynamic> entity,
      Map<String, TextEditingController> controllers) async {
    // Update entity values from controllers
    controllers.forEach((attributeName, controller) {
      if (controller.text.isNotEmpty) {
        // Convert value to the appropriate type based on the original entity value type
        final originalValue = entity[attributeName];
        if (originalValue is int) {
          entity[attributeName] = int.tryParse(controller.text) ?? 0;
        } else if (originalValue is double) {
          entity[attributeName] = double.tryParse(controller.text) ?? 0.0;
        } else if (originalValue is bool) {
          entity[attributeName] = controller.text.toLowerCase() == 'true' ||
              controller.text.toLowerCase() == 'yes';
        } else if (originalValue is DateTime) {
          entity[attributeName] =
              DateTime.tryParse(controller.text) ?? DateTime.now();
        } else {
          // String or other type
          entity[attributeName] = controller.text;
        }
      }
    });

    // Try to save to domain repository
    try {
      final conceptCode = widget.concept.code;
      final success = await widget.shellApp.saveEntity(conceptCode, entity);

      if (success) {
        // Refresh the entity list after save
        await _loadEntities();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${widget.concept.code} saved successfully')),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save ${widget.concept.code}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving entity: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
