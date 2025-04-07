part of ednet_core_flutter;

/// A configuration injector for EDNet domain models that enables configuration of
/// domain model interpretation and UX customization.
///
/// The [ConfigurationInjector] provides a mechanism to load and apply different
/// configuration types for domain model interpretation, ensuring that clients can
/// customize both domain behavior and UI representation while maintaining a clean
/// separation of concerns.
///
/// This pattern is inspired by dependency injection, but specifically focused on
/// configuration settings for both domain logic and UX customization.
///
/// Example usage:
/// ```dart
/// // Create an injector
/// final injector = ConfigurationInjector();
///
/// // Register global configurations
/// injector.registerConfiguration(myUxConfig, ConfigurationType.ux);
/// injector.registerConfiguration(myDataConfig, ConfigurationType.data);
///
/// // Apply configurations to shell
/// final shell = ShellApp(domain: myDomain);
/// injector.configure(shell);
/// ```
class ConfigurationInjector {
  /// Map of registered configurations by type
  final Map<ConfigurationType, List<Configuration>> _configurations = {};

  /// Register a configuration
  void registerConfiguration(Configuration config, ConfigurationType type) {
    _configurations.putIfAbsent(type, () => []).add(config);
  }

  /// Apply all registered configurations to a shell
  void configure(ShellApp shell) {
    // Apply each configuration type in order of precedence
    _applyConfigurations(ConfigurationType.domain, shell);
    _applyConfigurations(ConfigurationType.data, shell);
    _applyConfigurations(ConfigurationType.business, shell);
    _applyConfigurations(ConfigurationType.ux, shell);
    _applyConfigurations(ConfigurationType.custom, shell);
  }

  /// Apply configurations of a specific type
  void _applyConfigurations(ConfigurationType type, ShellApp shell) {
    final configs = _configurations[type] ?? [];
    for (final config in configs) {
      config.apply(shell);
    }
  }

  /// Clear all registered configurations
  void clear() {
    _configurations.clear();
  }

  /// Clear configurations of a specific type
  void clearType(ConfigurationType type) {
    _configurations.remove(type);
  }

  /// Get all configurations of a specific type
  List<Configuration> getConfigurations(ConfigurationType type) {
    return List.unmodifiable(_configurations[type] ?? []);
  }

  /// Load configurations from a YAML file
  Future<void> loadFromYaml(String yamlPath) async {
    try {
      final file = File(yamlPath);
      if (!await file.exists()) {
        throw FileSystemException('Configuration file not found', yamlPath);
      }

      final yamlContent = await file.readAsString();
      final yamlDoc = loadYaml(yamlContent) as YamlMap;

      // Process each configuration section
      for (final entry in yamlDoc.entries) {
        final key = entry.key.toString();
        final value = entry.value;

        // Match key to configuration type
        final type = _configTypeFromString(key);
        if (type != null && value is YamlMap) {
          // Create and register configuration
          final config = ConfigurationFactory.fromYaml(value, type);
          registerConfiguration(config, type);
        }
      }
    } catch (e) {
      throw ConfigurationException(
        'Failed to load configuration from YAML: $e',
      );
    }
  }

  /// Convert string to configuration type
  ConfigurationType? _configTypeFromString(String key) {
    switch (key.toLowerCase()) {
      case 'domain':
        return ConfigurationType.domain;
      case 'data':
        return ConfigurationType.data;
      case 'business':
        return ConfigurationType.business;
      case 'ux':
        return ConfigurationType.ux;
      case 'custom':
        return ConfigurationType.custom;
      default:
        return null;
    }
  }
}

/// Types of configurations
enum ConfigurationType {
  /// Domain model configuration (core domain rules)
  domain,

  /// Data access configuration
  data,

  /// Business logic configuration
  business,

  /// User interface configuration
  ux,

  /// Custom application-specific configuration
  custom,
}

/// Base class for configurations
abstract class Configuration {
  /// Configuration name
  final String name;

  /// Configuration priority (higher = applied later)
  final int priority;

  /// Constructor
  Configuration({required this.name, this.priority = 0});

  /// Apply this configuration to a shell
  void apply(ShellApp shell);
}

/// Configuration for UX customization
class UXConfiguration extends Configuration {
  /// Default disclosure level
  final DisclosureLevel? defaultDisclosureLevel;

  /// Custom entity adapters
  final Map<String, UXAdapterFactory> conceptAdapters;

  /// Custom field renderers
  final Map<String, dynamic> fieldRenderers;

  /// Custom visualization settings
  final Map<String, dynamic> visualizationSettings;

  /// Constructor
  UXConfiguration({
    required String name,
    int priority = 0,
    this.defaultDisclosureLevel,
    Map<String, UXAdapterFactory>? conceptAdapters,
    Map<String, dynamic>? fieldRenderers,
    Map<String, dynamic>? visualizationSettings,
  })  : conceptAdapters = conceptAdapters ?? {},
        fieldRenderers = fieldRenderers ?? {},
        visualizationSettings = visualizationSettings ?? {},
        super(name: name, priority: priority);

  @override
  void apply(ShellApp shell) {
    // Set default disclosure level if specified
    if (defaultDisclosureLevel != null) {
      shell.configureDisclosureLevel(
        userRole: 'default',
        defaultLevel: defaultDisclosureLevel!,
      );
    }

    // Register concept adapters
    // This requires a registry of concept-to-entity-type mappings
    // which would be provided by the generated code
  }
}

/// Configuration for domain model customization
class DomainConfiguration extends Configuration {
  /// Custom domain rules
  final Map<String, dynamic> rules;

  /// Custom validation
  final Map<String, dynamic> validation;

  /// Constructor
  DomainConfiguration({
    required String name,
    int priority = 0,
    Map<String, dynamic>? rules,
    Map<String, dynamic>? validation,
  })  : rules = rules ?? {},
        validation = validation ?? {},
        super(name: name, priority: priority);

  @override
  void apply(ShellApp shell) {
    // Apply domain rules
    // Typically this would configure validation, rules engines, etc.
  }
}

/// Configuration for data access
class DataConfiguration extends Configuration {
  /// Data source configurations
  final Map<String, dynamic> dataSources;

  /// Repository configurations
  final Map<String, dynamic> repositories;

  /// Constructor
  DataConfiguration({
    required String name,
    int priority = 0,
    Map<String, dynamic>? dataSources,
    Map<String, dynamic>? repositories,
  })  : dataSources = dataSources ?? {},
        repositories = repositories ?? {},
        super(name: name, priority: priority);

  @override
  void apply(ShellApp shell) {
    // Configure data access
    // Typically this would set up repositories, data sources, etc.
  }
}

/// Exception thrown for configuration errors
class ConfigurationException implements Exception {
  /// Error message
  final String message;

  /// Constructor
  ConfigurationException(this.message);

  @override
  String toString() => 'ConfigurationException: $message';
}

/// Factory for creating configurations from YAML
class ConfigurationFactory {
  /// Create a configuration from YAML data
  static Configuration fromYaml(YamlMap yaml, ConfigurationType type) {
    final name = yaml['name'] as String? ?? 'Unnamed Configuration';
    final priority = yaml['priority'] as int? ?? 0;

    switch (type) {
      case ConfigurationType.ux:
        return _createUXConfiguration(yaml, name, priority);
      case ConfigurationType.domain:
        return _createDomainConfiguration(yaml, name, priority);
      case ConfigurationType.data:
        return _createDataConfiguration(yaml, name, priority);
      case ConfigurationType.business:
        return _createBusinessConfiguration(yaml, name, priority);
      case ConfigurationType.custom:
        return _createCustomConfiguration(yaml, name, priority);
    }
  }

  /// Create a UX configuration from YAML
  static UXConfiguration _createUXConfiguration(
    YamlMap yaml,
    String name,
    int priority,
  ) {
    DisclosureLevel? disclosureLevel;
    if (yaml.containsKey('defaultDisclosureLevel')) {
      final level = yaml['defaultDisclosureLevel'] as String?;
      if (level != null) {
        disclosureLevel = _parseDisclosureLevel(level);
      }
    }

    // Parse other UX configuration settings
    return UXConfiguration(
      name: name,
      priority: priority,
      defaultDisclosureLevel: disclosureLevel,
    );
  }

  /// Create a domain configuration from YAML
  static DomainConfiguration _createDomainConfiguration(
    YamlMap yaml,
    String name,
    int priority,
  ) {
    // Parse domain rules and validation
    final rules = _yamlMapToStringDynamicMap(yaml['rules'] as YamlMap?);
    final validation = _yamlMapToStringDynamicMap(
      yaml['validation'] as YamlMap?,
    );

    return DomainConfiguration(
      name: name,
      priority: priority,
      rules: rules,
      validation: validation,
    );
  }

  /// Create a data configuration from YAML
  static DataConfiguration _createDataConfiguration(
    YamlMap yaml,
    String name,
    int priority,
  ) {
    // Parse data sources and repositories
    final dataSources = _yamlMapToStringDynamicMap(
      yaml['dataSources'] as YamlMap?,
    );
    final repositories = _yamlMapToStringDynamicMap(
      yaml['repositories'] as YamlMap?,
    );

    return DataConfiguration(
      name: name,
      priority: priority,
      dataSources: dataSources,
      repositories: repositories,
    );
  }

  /// Create a business configuration from YAML
  static Configuration _createBusinessConfiguration(
    YamlMap yaml,
    String name,
    int priority,
  ) {
    // Create a generic configuration for business rules
    return _createGenericConfiguration(yaml, name, priority);
  }

  /// Create a custom configuration from YAML
  static Configuration _createCustomConfiguration(
    YamlMap yaml,
    String name,
    int priority,
  ) {
    // Create a generic configuration for custom settings
    return _createGenericConfiguration(yaml, name, priority);
  }

  /// Create a generic configuration from YAML
  static GenericConfiguration _createGenericConfiguration(
    YamlMap yaml,
    String name,
    int priority,
  ) {
    // Convert entire YAML map to regular map
    final settings = _yamlMapToStringDynamicMap(yaml);

    return GenericConfiguration(
      name: name,
      priority: priority,
      settings: settings,
    );
  }

  /// Convert a YamlMap to a standard Map<String, dynamic>
  static Map<String, dynamic> _yamlMapToStringDynamicMap(YamlMap? yaml) {
    if (yaml == null) return {};

    final result = <String, dynamic>{};
    for (final entry in yaml.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      if (value is YamlMap) {
        result[key] = _yamlMapToStringDynamicMap(value);
      } else if (value is YamlList) {
        result[key] = _yamlListToDynamicList(value);
      } else {
        result[key] = value;
      }
    }

    return result;
  }

  /// Convert a YamlList to a standard List<dynamic>
  static List<dynamic> _yamlListToDynamicList(YamlList yamlList) {
    final result = <dynamic>[];
    for (final item in yamlList) {
      if (item is YamlMap) {
        result.add(_yamlMapToStringDynamicMap(item));
      } else if (item is YamlList) {
        result.add(_yamlListToDynamicList(item));
      } else {
        result.add(item);
      }
    }
    return result;
  }

  /// Parse a disclosure level from a string
  static DisclosureLevel _parseDisclosureLevel(String level) {
    switch (level.toLowerCase()) {
      case 'minimal':
        return DisclosureLevel.minimal;
      case 'basic':
        return DisclosureLevel.basic;
      case 'intermediate':
        return DisclosureLevel.intermediate;
      case 'advanced':
        return DisclosureLevel.advanced;
      case 'complete':
        return DisclosureLevel.complete;
      default:
        return DisclosureLevel.basic;
    }
  }
}

/// Generic configuration for custom settings
class GenericConfiguration extends Configuration {
  /// Configuration settings
  final Map<String, dynamic> settings;

  /// Constructor
  GenericConfiguration({
    required String name,
    int priority = 0,
    Map<String, dynamic>? settings,
  })  : settings = settings ?? {},
        super(name: name, priority: priority);

  @override
  void apply(ShellApp shell) {
    // Apply relevant settings
    // This is application-specific
  }

  /// Get a setting value by key
  T? getSetting<T>(String key) {
    final value = settings[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  /// Get a nested setting value using dot notation
  T? getNestedSetting<T>(String path) {
    final parts = path.split('.');
    dynamic current = settings;

    for (final part in parts) {
      if (current is Map) {
        current = current[part];
      } else {
        return null;
      }
    }

    if (current is T) {
      return current;
    }
    return null;
  }
}
