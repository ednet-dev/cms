part of ednet_core_flutter;

/// Development Mode Channel message types
class DevModeMessageTypes {
  static const String devModeStatus = 'dev_mode_status';
  static const String loadSampleData = 'load_sample_data';
  static const String clearSampleData = 'clear_sample_data';
  static const String toggleDevMode = 'toggle_dev_mode';
}

/// Development Mode Channel Adapter that connects the persistence layer with the UX messaging system
class DevelopmentModeChannelAdapter {
  /// The shell app instance
  final ShellApp shellApp;

  /// The channel for dev mode messages
  final UXChannel _channel;

  /// Whether dev mode is currently active
  bool _isDevModeActive = false;

  /// Get whether dev mode is currently active
  bool get isDevModeActive => _isDevModeActive;

  /// Constructor
  DevelopmentModeChannelAdapter(this.shellApp)
      : _channel = UXChannel('dev_mode_channel', name: 'Development Mode') {
    _initializeChannel();
  }

  /// Manually toggle dev mode - added for testing support
  void toggleDevMode() {
    _isDevModeActive = !_isDevModeActive;
    _updatePersistenceMode();
    _broadcastStatus();
  }

  /// Manually load sample data for a concept - added for testing support
  Future<void> loadSampleData(String conceptCode) async {
    if (!_isDevModeActive) {
      _isDevModeActive = true;
      _updatePersistenceMode();
      _broadcastStatus();
    }

    final data = await _getSampleDataForConcept(conceptCode);
    for (final entity in data) {
      await shellApp._persistence.saveEntity(conceptCode, entity);
    }
  }

  /// Initialize the channel and register message handlers
  void _initializeChannel() {
    // Register message handlers
    _channel.onUXMessageType(
        DevModeMessageTypes.toggleDevMode, _handleToggleDevMode);
    _channel.onUXMessageType(
        DevModeMessageTypes.loadSampleData, _handleLoadSampleData);
    _channel.onUXMessageType(
        DevModeMessageTypes.clearSampleData, _handleClearSampleData);

    // Broadcast initial status
    _broadcastStatus();
  }

  /// Handle toggling dev mode on/off
  void _handleToggleDevMode(UXMessage message) {
    _isDevModeActive = !_isDevModeActive;

    // Update persistence to use development repositories if enabled
    _updatePersistenceMode();

    // Broadcast the updated status
    _broadcastStatus();
  }

  /// Handle request to load sample data
  void _handleLoadSampleData(UXMessage message) async {
    // Only process if dev mode is active
    if (!_isDevModeActive) return;

    // Extract concept code from the message
    final conceptCode = message.payload['conceptCode'] as String?;
    if (conceptCode == null) return;

    try {
      // Get sample data for the concept
      final data = await _getSampleDataForConcept(conceptCode);

      // Save the sample data
      for (final entity in data) {
        await shellApp._persistence.saveEntity(conceptCode, entity);
      }

      // Send success message
      _channel.sendUXMessage(UXMessage.create(
        type: 'sample_data_loaded',
        payload: {
          'conceptCode': conceptCode,
          'count': data.length,
        },
        source: 'dev_mode_adapter',
      ));
    } catch (e) {
      // Send error message
      _channel.sendUXMessage(UXMessage.create(
        type: 'sample_data_error',
        payload: {
          'conceptCode': conceptCode,
          'error': e.toString(),
        },
        source: 'dev_mode_adapter',
      ));
    }
  }

  /// Handle request to clear sample data
  void _handleClearSampleData(UXMessage message) {
    // Only process if dev mode is active
    if (!_isDevModeActive) return;

    // Extract concept code from the message
    final conceptCode = message.payload['conceptCode'] as String?;
    if (conceptCode == null) return;

    // Clear data (implementation would depend on repository details)

    // Send success message
    _channel.sendUXMessage(UXMessage.create(
      type: 'sample_data_cleared',
      payload: {
        'conceptCode': conceptCode,
      },
      source: 'dev_mode_adapter',
    ));
  }

  /// Update the persistence mode based on dev mode setting
  void _updatePersistenceMode() {
    // Real implementation would swap repository adapters
  }

  /// Broadcast the current dev mode status
  void _broadcastStatus() {
    _channel.sendUXMessage(UXMessage.create(
      type: DevModeMessageTypes.devModeStatus,
      payload: {
        'active': _isDevModeActive,
        'timestamp': DateTime.now().toIso8601String(),
      },
      source: 'dev_mode_adapter',
    ));
  }

  /// Generate sample data for a specific concept
  Future<List<Map<String, dynamic>>> _getSampleDataForConcept(
      String conceptCode) async {
    final sampleData = <Map<String, dynamic>>[];

    // Handle specific concept types
    if (conceptCode == 'Task') {
      sampleData.addAll([
        {
          'id': 'task-sample-1',
          'title': 'Implement dev mode channel',
          'status': 'completed',
          'priority': 'high',
          'dueDate': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        },
        {
          'id': 'task-sample-2',
          'title': 'Test channel adapters',
          'status': 'in_progress',
          'priority': 'medium',
          'dueDate': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        },
        {
          'id': 'task-sample-3',
          'title': 'Document the implementation',
          'status': 'not_started',
          'priority': 'low',
          'dueDate': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
        },
      ]);
    } else if (conceptCode == 'Project') {
      sampleData.addAll([
        {
          'id': 'project-sample-1',
          'name': 'Channel Adapter Implementation',
          'description': 'Implement the Channel Adapter pattern for dev mode',
          'startDate':
              DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
          'endDate': DateTime.now().add(const Duration(days: 20)).toIso8601String(),
          'budget': 5000.0,
        },
        {
          'id': 'project-sample-2',
          'name': 'EDNet Core Integration',
          'description':
              'Integrate the adapter pattern with the core libraries',
          'startDate': DateTime.now().toIso8601String(),
          'endDate': DateTime.now().add(const Duration(days: 45)).toIso8601String(),
          'budget': 12000.0,
        },
      ]);
    } else if (conceptCode == 'Team') {
      sampleData.addAll([
        {
          'id': 'team-sample-1',
          'name': 'Integration Team',
        },
        {
          'id': 'team-sample-2',
          'name': 'UI Development Team',
        },
      ]);
    }

    return sampleData;
  }
}

/// Widget that provides dev mode controls in the UI
class DevelopmentModeControlPanel extends StatelessWidget {
  /// The development mode channel adapter
  final DevelopmentModeChannelAdapter adapter;

  /// Constructor
  const DevelopmentModeControlPanel({Key? key, required this.adapter})
      : super(key: key);

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
                  value: adapter.isDevModeActive,
                  onChanged: (_) => _toggleDevMode(),
                  activeColor: Colors.purple,
                ),
              ],
            ),
            if (adapter.isDevModeActive) ...[
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
                    onPressed: () => _loadSampleData('Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[200],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Load Projects'),
                    onPressed: () => _loadSampleData('Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[200],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Clear All'),
                    onPressed: _clearAllSampleData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
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

  /// Toggle development mode on/off
  void _toggleDevMode() {
    adapter._channel.sendUXMessage(UXMessage.create(
      type: DevModeMessageTypes.toggleDevMode,
      payload: {},
      source: 'dev_mode_control_panel',
    ));
  }

  /// Load sample data for a specific concept
  void _loadSampleData(String conceptCode) {
    adapter._channel.sendUXMessage(UXMessage.create(
      type: DevModeMessageTypes.loadSampleData,
      payload: {'conceptCode': conceptCode},
      source: 'dev_mode_control_panel',
    ));
  }

  /// Clear all sample data
  void _clearAllSampleData() {
    adapter._channel.sendUXMessage(UXMessage.create(
      type: DevModeMessageTypes.clearSampleData,
      payload: {},
      source: 'dev_mode_control_panel',
    ));
  }
}
