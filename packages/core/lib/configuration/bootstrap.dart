// part of ednet_core;
//
// import 'dart:io';
// import 'package:yaml/yaml.dart';
//
// /// A utility class for bootstrapping the domain model from YAML configuration.
// class Bootstrap {
//   final YamlSource _yamlSource;
//   final String _domainModelName;
//   final String _filePath;
//
//   /// Creates a new Bootstrap instance.
//   ///
//   /// Parameters:
//   /// - [domainModelName]: The name of the domain model to bootstrap (default: "domain_model_name")
//   /// - [filePath]: The path to the YAML configuration file (default: "domain_model_definition")
//   Bootstrap({
//     String domainModelName = "domain_model_name",
//     String filePath = "domain_model_definition",
//   })  : _domainModelName = domainModelName,
//         _filePath = filePath,
//         _yamlSource = YamlSource();
//
//   /// Bootstraps the domain model from the YAML configuration.
//   ///
//   /// Returns:
//   /// A [Domain] instance initialized with the configuration from the YAML file
//   ///
//   /// Throws:
//   /// - [FileSystemException] if the YAML file cannot be found or read
//   /// - [YamlException] if the YAML content is invalid
//   /// - [EDNetException] if the domain model cannot be created
//   Future<Domain> bootstrap() async {
//     try {
//       final yamlPath = await _yamlSource.getYamlPath();
//       final yamlFile = File("$yamlPath/$_domainModelName.yaml");
//
//       if (!yamlFile.existsSync()) {
//         throw FileSystemException(
//           'YAML file not found at path: ${yamlFile.path}',
//         );
//       }
//
//       final config = _yamlSource.readFromFile(yamlFile.path);
//       return _createDomainFromConfig(config);
//     } catch (e) {
//       throw EDNetException('Failed to bootstrap domain model: $e');
//     }
//   }
//
//   /// Creates a domain model from the YAML configuration.
//   ///
//   /// Parameters:
//   /// - [config]: The parsed YAML configuration
//   ///
//   /// Returns:
//   /// A [Domain] instance initialized with the configuration
//   Domain _createDomainFromConfig(Map<String, dynamic> config) {
//     final domainName = config['name'] as String? ?? _domainModelName;
//     final domain = Domain(domainName);
//
//     // Process bounded contexts
//     if (config.containsKey('boundedContexts')) {
//       final contexts = config['boundedContexts'] as Map<String, dynamic>;
//       for (final contextName in contexts.keys) {
//         final contextConfig = contexts[contextName] as Map<String, dynamic>;
//         _processBoundedContext(domain, contextName, contextConfig);
//       }
//     }
//
//     // Process application services
//     if (config.containsKey('applicationServices')) {
//       final services = config['applicationServices'] as Map<String, dynamic>;
//       for (final serviceName in services.keys) {
//         final serviceConfig = services[serviceName] as Map<String, dynamic>;
//         _processApplicationService(domain, serviceName, serviceConfig);
//       }
//     }
//
//     return domain;
//   }
//
//   /// Processes a bounded context from the configuration.
//   ///
//   /// Parameters:
//   /// - [domain]: The domain to add the bounded context to
//   /// - [contextName]: The name of the bounded context
//   /// - [config]: The configuration for the bounded context
//   void _processBoundedContext(
//     Domain domain,
//     String contextName,
//     Map<String, dynamic> config,
//   ) {
//     final dependencies = (config['depends_on'] as List<dynamic>?)?.cast<String>() ?? [];
//     final boundedContext = BoundedContext(domain, contextName, dependencies: dependencies);
//
//     // Process aggregate roots
//     if (config.containsKey('aggregates')) {
//       final aggregates = config['aggregates'] as Map<String, dynamic>;
//       for (final aggregateName in aggregates.keys) {
//         final aggregateConfig = aggregates[aggregateName] as Map<String, dynamic>;
//         _processAggregateRoot(boundedContext, aggregateName, aggregateConfig);
//       }
//     }
//   }
//
//   /// Processes an aggregate root from the configuration.
//   ///
//   /// Parameters:
//   /// - [boundedContext]: The bounded context to add the aggregate root to
//   /// - [aggregateName]: The name of the aggregate root
//   /// - [config]: The configuration for the aggregate root
//   void _processAggregateRoot(
//     BoundedContext boundedContext,
//     String aggregateName,
//     Map<String, dynamic> config,
//   ) {
//     final aggregateRoot = AggregateRoot(boundedContext, aggregateName);
//
//     // Process attributes
//     if (config.containsKey('attributes')) {
//       final attributes = config['attributes'] as Map<String, dynamic>;
//       for (final attributeName in attributes.keys) {
//         final attributeConfig = attributes[attributeName] as Map<String, dynamic>;
//         _processAttribute(aggregateRoot, attributeName, attributeConfig);
//       }
//     }
//
//     // Process commands
//     if (config.containsKey('commands')) {
//       final commands = config['commands'] as Map<String, dynamic>;
//       for (final commandName in commands.keys) {
//         final commandConfig = commands[commandName] as Map<String, dynamic>;
//         _processCommand(aggregateRoot, commandName, commandConfig);
//       }
//     }
//
//     // Process events
//     if (config.containsKey('events')) {
//       final events = config['events'] as Map<String, dynamic>;
//       for (final eventName in events.keys) {
//         final eventConfig = events[eventName] as Map<String, dynamic>;
//         _processEvent(aggregateRoot, eventName, eventConfig);
//       }
//     }
//   }
//
//   /// Processes an attribute from the configuration.
//   ///
//   /// Parameters:
//   /// - [aggregateRoot]: The aggregate root to add the attribute to
//   /// - [attributeName]: The name of the attribute
//   /// - [config]: The configuration for the attribute
//   void _processAttribute(
//     AggregateRoot aggregateRoot,
//     String attributeName,
//     Map<String, dynamic> config,
//   ) {
//     final type = config['type'] as String? ?? 'String';
//     final required = config['required'] as bool? ?? false;
//     final validation = config['validation'] as Map<String, dynamic>?;
//
//     aggregateRoot.addAttribute(
//       name: attributeName,
//       type: type,
//       required: required,
//       validation: validation,
//     );
//   }
//
//   /// Processes a command from the configuration.
//   ///
//   /// Parameters:
//   /// - [aggregateRoot]: The aggregate root to add the command to
//   /// - [commandName]: The name of the command
//   /// - [config]: The configuration for the command
//   void _processCommand(
//     AggregateRoot aggregateRoot,
//     String commandName,
//     Map<String, dynamic> config,
//   ) {
//     final intention = config['intention'] as String? ?? '';
//     final policies = config['policy'] as Map<String, dynamic>?;
//
//     aggregateRoot.addCommand(
//       name: commandName,
//       intention: intention,
//       policies: policies,
//     );
//   }
//
//   /// Processes an event from the configuration.
//   ///
//   /// Parameters:
//   /// - [aggregateRoot]: The aggregate root to add the event to
//   /// - [eventName]: The name of the event
//   /// - [config]: The configuration for the event
//   void _processEvent(
//     AggregateRoot aggregateRoot,
//     String eventName,
//     Map<String, dynamic> config,
//   ) {
//     final payload = config['payload'] as Map<String, dynamic>?;
//
//     aggregateRoot.addEvent(
//       name: eventName,
//       payload: payload,
//     );
//   }
//
//   /// Processes an application service from the configuration.
//   ///
//   /// Parameters:
//   /// - [domain]: The domain to add the application service to
//   /// - [serviceName]: The name of the application service
//   /// - [config]: The configuration for the application service
//   void _processApplicationService(
//     Domain domain,
//     String serviceName,
//     Map<String, dynamic> config,
//   ) {
//     final dependencies = (config['dependencies'] as List<dynamic>?)?.cast<String>() ?? [];
//     final commands = config['commands'] as Map<String, dynamic>? ?? {};
//
//     final service = ApplicationService(domain, serviceName, dependencies: dependencies);
//
//     for (final commandName in commands.keys) {
//       final commandConfig = commands[commandName] as Map<String, dynamic>;
//       _processServiceCommand(service, commandName, commandConfig);
//     }
//   }
//
//   /// Processes a service command from the configuration.
//   ///
//   /// Parameters:
//   /// - [service]: The application service to add the command to
//   /// - [commandName]: The name of the command
//   /// - [config]: The configuration for the command
//   void _processServiceCommand(
//     ApplicationService service,
//     String commandName,
//     Map<String, dynamic> config,
//   ) {
//     final intention = config['intention'] as String? ?? '';
//     final events = config['events'] as Map<String, dynamic>?;
//
//     service.addCommand(
//       name: commandName,
//       intention: intention,
//       events: events,
//     );
//   }
// }
