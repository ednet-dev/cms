import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/domain/services/model_instance_service.dart';
import 'package:ednet_one/domain/extensions/domain_model_extensions.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart' show oneApplication, persistenceService;
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';

/// A page for managing model instances
class ModelInstancePage extends StatefulWidget {
  /// Route name for navigation
  static const String routeName = '/model-instance';

  /// Constructor
  const ModelInstancePage({Key? key}) : super(key: key);

  @override
  _ModelInstancePageState createState() => _ModelInstancePageState();
}

class _ModelInstancePageState extends State<ModelInstancePage> {
  final ModelInstanceService _instanceService = ModelInstanceService(
    oneApplication,
    persistenceService,
  );

  List<ModelInstanceConfig> _configurations = [];
  ModelInstanceConfig? _selectedConfig;
  ModelInstanceResult? _lastRunResult;
  bool _isLoading = false;
  bool _isCreating = false;
  Domain? _selectedDomain;
  Model? _selectedModel;
  ServiceType _selectedServiceType = ServiceType.twitter;

  // Form controllers
  final _nameController = TextEditingController();
  final _parameterControllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _loadConfigurations();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parameterControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadConfigurations() async {
    setState(() {
      _isLoading = true;
    });

    await _instanceService.loadConfigurations();

    setState(() {
      _configurations = _instanceService.allConfigurations;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Instances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Configurations',
            onPressed: _loadConfigurations,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                children: [
                  // Configurations list
                  Container(width: 300, child: _buildConfigurationsList()),

                  // Vertical divider
                  const VerticalDivider(),

                  // Configuration details or editor
                  Expanded(
                    child:
                        _isCreating
                            ? _buildConfigurationEditor()
                            : _selectedConfig != null
                            ? _buildConfigurationDetails()
                            : const Center(
                              child: Text(
                                'Select a configuration or create a new one',
                              ),
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isCreating = true;
            _selectedConfig = null;
            _selectedDomain = null;
            _selectedModel = null;
            _nameController.clear();
            _parameterControllers.clear();
          });
        },
        tooltip: 'Create Instance Configuration',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConfigurationsList() {
    return Card(
      margin: EdgeInsets.all(context.spacingS),
      child: ListView(
        padding: EdgeInsets.all(context.spacingXs),
        children: [
          Padding(
            padding: EdgeInsets.all(context.spacingS),
            child: Text(
              'Instance Configurations',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const Divider(),
          ..._configurations.map(
            (config) => ListTile(
              title: Text(config.name),
              subtitle: Text('${config.domainCode} / ${config.modelCode}'),
              leading: _getServiceIcon(config.serviceType),
              selected: _selectedConfig?.id == config.id,
              onTap:
                  () => setState(() {
                    _selectedConfig = config;
                    _isCreating = false;
                  }),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Run Instance',
                onPressed: () => _runInstance(config),
              ),
            ),
          ),
          if (_configurations.isEmpty)
            Padding(
              padding: EdgeInsets.all(context.spacingM),
              child: Center(
                child: Text(
                  'No configurations available',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfigurationDetails() {
    final config = _selectedConfig!;

    return Card(
      margin: EdgeInsets.all(context.spacingM),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _getServiceIcon(config.serviceType),
                SizedBox(width: context.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${config.domainCode} / ${config.modelCode}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Configuration',
                  onPressed: () {
                    setState(() {
                      _isCreating = true;
                      _nameController.text = config.name;
                      _selectedServiceType = config.serviceType;

                      // Set up parameter controllers
                      _parameterControllers.clear();
                      config.parameters.forEach((key, value) {
                        _parameterControllers[key] = TextEditingController(
                          text: value,
                        );
                      });

                      // Find domain and model
                      _selectedDomain = oneApplication.groupedDomains
                          .singleWhereCode(config.domainCode);
                      if (_selectedDomain != null) {
                        _selectedModel = _selectedDomain!.models
                            .singleWhereCode(config.modelCode);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete Configuration',
                  onPressed: () => _deleteConfiguration(config),
                ),
              ],
            ),

            Divider(height: context.spacingL * 2),

            // Metadata
            Text(
              'Configuration Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.spacingM),

            _buildInfoRow('Service Type', config.serviceType.name),
            _buildInfoRow('Created', config.createdAt.toString()),
            if (config.lastRunAt != null)
              _buildInfoRow('Last Run', config.lastRunAt.toString()),

            Divider(height: context.spacingL),

            // Parameters
            Text(
              'Parameters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.spacingM),

            ...config.parameters.entries.map(
              (entry) => _buildInfoRow(
                entry.key,
                entry.value,
                sensitive: _isSensitiveParameter(entry.key),
              ),
            ),

            Divider(height: context.spacingL),

            // Run section
            Text(
              'Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.spacingM),

            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run Instance'),
              onPressed: () => _runInstance(config),
            ),

            if (_lastRunResult != null && _selectedConfig?.id == config.id)
              Padding(
                padding: EdgeInsets.only(top: context.spacingM),
                child: _buildResultView(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationEditor() {
    // Get available domains
    final domains = oneApplication.getAllDomains();

    // Get available models for selected domain
    final models = _selectedDomain?.getAllModels() ?? [];

    return Card(
      margin: EdgeInsets.all(context.spacingM),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedConfig != null
                  ? 'Edit Configuration'
                  : 'Create Configuration',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: context.spacingL),

            // Configuration name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Configuration Name',
                helperText: 'Enter a name for this configuration',
                prefixIcon: const Icon(Icons.label),
              ),
            ),

            SizedBox(height: context.spacingL),

            // Domain selection
            DropdownButtonFormField<Domain>(
              decoration: InputDecoration(
                labelText: 'Domain',
                helperText: 'Select a domain for this configuration',
                prefixIcon: const Icon(Icons.domain),
              ),
              value: _selectedDomain,
              items:
                  domains
                      .map(
                        (domain) => DropdownMenuItem(
                          value: domain,
                          child: Text(domain.code),
                        ),
                      )
                      .toList(),
              onChanged: (domain) {
                setState(() {
                  _selectedDomain = domain;
                  _selectedModel = null;
                });
              },
            ),

            SizedBox(height: context.spacingM),

            // Model selection
            DropdownButtonFormField<Model>(
              decoration: InputDecoration(
                labelText: 'Model',
                helperText: 'Select a model for this configuration',
                prefixIcon: const Icon(Icons.model_training),
              ),
              value: _selectedModel,
              items:
                  models
                      .map(
                        (model) => DropdownMenuItem(
                          value: model,
                          child: Text(model.code),
                        ),
                      )
                      .toList(),
              onChanged:
                  _selectedDomain != null
                      ? (model) {
                        setState(() {
                          _selectedModel = model;
                        });
                      }
                      : null,
            ),

            SizedBox(height: context.spacingL),

            // Service type selection
            DropdownButtonFormField<ServiceType>(
              decoration: InputDecoration(
                labelText: 'Service Type',
                helperText: 'Select the type of external service',
                prefixIcon: const Icon(Icons.cloud),
              ),
              value: _selectedServiceType,
              items:
                  ServiceType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              _getServiceIcon(type),
                              SizedBox(width: context.spacingS),
                              Text(type.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (type) {
                setState(() {
                  _selectedServiceType = type!;
                  _resetParameterFields(_selectedServiceType);
                });
              },
            ),

            SizedBox(height: context.spacingL),

            // Parameters section
            Text(
              'Service Parameters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.spacingM),

            ..._buildParameterFields(_selectedServiceType),

            SizedBox(height: context.spacingL),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isCreating = false;
                      if (_selectedConfig != null) {
                        // Reset selected config if editing
                        _selectedConfig = _configurations.firstWhere(
                          (config) => config.id == _selectedConfig!.id,
                          orElse: () => _selectedConfig!,
                        );
                      }
                    });
                  },
                  child: const Text('Cancel'),
                ),
                SizedBox(width: context.spacingM),
                ElevatedButton(
                  onPressed: _saveConfiguration,
                  child: Text(
                    _selectedConfig != null
                        ? 'Save Changes'
                        : 'Create Configuration',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final result = _lastRunResult!;

    return Card(
      color: result.success ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                ),
                SizedBox(width: context.spacingS),
                Text(
                  'Execution Result',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: context.spacingS),
            Text(result.message),
            if (result.data != null) ...[
              SizedBox(height: context.spacingM),
              Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: context.spacingXs),
              Container(
                padding: EdgeInsets.all(context.spacingS),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  result.data.toString(),
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool sensitive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(sensitive ? '••••••••••••' : value)),
        ],
      ),
    );
  }

  List<Widget> _buildParameterFields(ServiceType serviceType) {
    final parameters = _getParametersForServiceType(serviceType);

    return parameters.map((param) {
      // Create controller if not exists
      _parameterControllers[param.key] ??= TextEditingController(
        text: param.defaultValue,
      );

      return Padding(
        padding: EdgeInsets.only(bottom: context.spacingM),
        child: TextField(
          controller: _parameterControllers[param.key],
          decoration: InputDecoration(
            labelText: param.label,
            helperText: param.description,
            prefixIcon: Icon(param.icon),
          ),
          obscureText: param.sensitive,
        ),
      );
    }).toList();
  }

  void _resetParameterFields(ServiceType serviceType) {
    final parameters = _getParametersForServiceType(serviceType);

    // Clear existing parameters that aren't in the new list
    final newParamKeys = parameters.map((p) => p.key).toSet();
    _parameterControllers.keys
        .where((key) => !newParamKeys.contains(key))
        .toList()
        .forEach((key) {
          _parameterControllers[key]?.dispose();
          _parameterControllers.remove(key);
        });

    // Initialize new parameters with default values
    for (final param in parameters) {
      if (!_parameterControllers.containsKey(param.key)) {
        _parameterControllers[param.key] = TextEditingController(
          text: param.defaultValue,
        );
      }
    }
  }

  Future<void> _saveConfiguration() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration name is required')),
      );
      return;
    }

    if (_selectedDomain == null || _selectedModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Domain and model selection is required')),
      );
      return;
    }

    try {
      // Collect parameters
      final parameters = <String, String>{};
      _parameterControllers.forEach((key, controller) {
        parameters[key] = controller.text;
      });

      setState(() {
        _isLoading = true;
      });

      if (_selectedConfig != null) {
        // Update existing config
        final updatedConfig = await _instanceService.updateInstanceConfig(
          id: _selectedConfig!.id,
          name: _nameController.text,
          serviceType: _selectedServiceType,
          parameters: parameters,
        );

        setState(() {
          if (updatedConfig != null) {
            final index = _configurations.indexWhere(
              (config) => config.id == updatedConfig.id,
            );
            if (index >= 0) {
              _configurations[index] = updatedConfig;
            }
            _selectedConfig = updatedConfig;
          }
        });
      } else {
        // Create new config
        final newConfig = await _instanceService.createInstanceConfig(
          name: _nameController.text,
          domain: _selectedDomain!,
          model: _selectedModel!,
          serviceType: _selectedServiceType,
          parameters: parameters,
        );

        setState(() {
          _configurations.add(newConfig);
          _selectedConfig = newConfig;
        });
      }

      setState(() {
        _isLoading = false;
        _isCreating = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving configuration: $e')));
    }
  }

  Future<void> _deleteConfiguration(ModelInstanceConfig config) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Configuration'),
            content: Text('Are you sure you want to delete "${config.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        setState(() {
          _isLoading = true;
        });

        final deleted = await _instanceService.deleteInstanceConfig(config.id);

        setState(() {
          if (deleted) {
            _configurations.removeWhere((c) => c.id == config.id);
            if (_selectedConfig?.id == config.id) {
              _selectedConfig = null;
            }
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting configuration: $e')),
        );
      }
    }
  }

  Future<void> _runInstance(ModelInstanceConfig config) async {
    try {
      setState(() {
        _isLoading = true;
        _selectedConfig = config;
        _lastRunResult = null;
      });

      final result = await _instanceService.runInstance(config.id);

      setState(() {
        _lastRunResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error running instance: $e')));
    }
  }

  Widget _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.twitter:
        return Icon(Icons.chat, color: Colors.blue);
      case ServiceType.facebook:
        return Icon(Icons.thumb_up, color: Colors.indigo);
      case ServiceType.instagram:
        return Icon(Icons.camera_alt, color: Colors.purple);
      case ServiceType.youtube:
        return Icon(Icons.play_circle_filled, color: Colors.red);
      case ServiceType.custom:
        return Icon(Icons.settings_applications);
    }
  }

  bool _isSensitiveParameter(String key) {
    return key.toLowerCase().contains('key') ||
        key.toLowerCase().contains('secret') ||
        key.toLowerCase().contains('password') ||
        key.toLowerCase().contains('token');
  }

  List<_ServiceParameter> _getParametersForServiceType(ServiceType type) {
    switch (type) {
      case ServiceType.twitter:
        return [
          _ServiceParameter(
            key: 'api_key',
            label: 'API Key',
            description: 'Twitter API Key (Consumer Key)',
            icon: Icons.vpn_key,
            sensitive: true,
          ),
          _ServiceParameter(
            key: 'api_secret',
            label: 'API Secret',
            description: 'Twitter API Secret (Consumer Secret)',
            icon: Icons.lock,
            sensitive: true,
          ),
          _ServiceParameter(
            key: 'access_token',
            label: 'Access Token',
            description: 'Twitter API Access Token',
            icon: Icons.token,
            sensitive: true,
          ),
          _ServiceParameter(
            key: 'access_token_secret',
            label: 'Access Token Secret',
            description: 'Twitter API Access Token Secret',
            icon: Icons.security,
            sensitive: true,
          ),
        ];
      case ServiceType.facebook:
        return [
          _ServiceParameter(
            key: 'app_id',
            label: 'App ID',
            description: 'Facebook App ID',
            icon: Icons.app_registration,
          ),
          _ServiceParameter(
            key: 'app_secret',
            label: 'App Secret',
            description: 'Facebook App Secret',
            icon: Icons.lock,
            sensitive: true,
          ),
          _ServiceParameter(
            key: 'access_token',
            label: 'Access Token',
            description: 'Facebook API Access Token',
            icon: Icons.token,
            sensitive: true,
          ),
        ];
      case ServiceType.instagram:
        return [
          _ServiceParameter(
            key: 'client_id',
            label: 'Client ID',
            description: 'Instagram Client ID',
            icon: Icons.perm_identity,
          ),
          _ServiceParameter(
            key: 'client_secret',
            label: 'Client Secret',
            description: 'Instagram Client Secret',
            icon: Icons.lock,
            sensitive: true,
          ),
          _ServiceParameter(
            key: 'access_token',
            label: 'Access Token',
            description: 'Instagram API Access Token',
            icon: Icons.token,
            sensitive: true,
          ),
        ];
      case ServiceType.youtube:
        return [
          _ServiceParameter(
            key: 'api_key',
            label: 'API Key',
            description: 'YouTube API Key',
            icon: Icons.vpn_key,
            sensitive: true,
          ),
          _ServiceParameter(
            key: 'channel_id',
            label: 'Channel ID',
            description: 'YouTube Channel ID (optional)',
            icon: Icons.play_circle_outline,
            defaultValue: '',
          ),
        ];
      case ServiceType.custom:
        return [
          _ServiceParameter(
            key: 'repoType',
            label: 'Repository Type',
            description: 'Type of repository (openapi, drift)',
            icon: Icons.category,
            defaultValue: 'openapi',
          ),
          _ServiceParameter(
            key: 'url',
            label: 'Service URL',
            description: 'URL for the service API',
            icon: Icons.link,
            defaultValue: 'https://',
          ),
          _ServiceParameter(
            key: 'auth_token',
            label: 'Authentication Token',
            description: 'Token for API authentication (if needed)',
            icon: Icons.security,
            sensitive: true,
            defaultValue: '',
          ),
        ];
    }
  }
}

/// Helper class for service parameters
class _ServiceParameter {
  final String key;
  final String label;
  final String description;
  final IconData icon;
  final bool sensitive;
  final String defaultValue;

  const _ServiceParameter({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
    this.sensitive = false,
    this.defaultValue = '',
  });
}
