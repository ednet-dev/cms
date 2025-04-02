import 'package:ednet_core/ednet_core.dart' as ednet_core;
import '../session/event_storming_board.dart';
import '../model/domain_event.dart';
import '../model/command.dart';
import '../model/aggregate.dart';
import '../model/policy.dart';
import '../model/read_model.dart';

/// Exports an Event Storming board to various formats.
///
/// The model exporter transforms an event storming board into different formats
/// such as EDNet Core models, JSON, or other representations that can be used
/// for implementation or documentation.
abstract class ModelExporter {
  /// Exports the board to a specific format.
  ///
  /// The output format depends on the implementing class.
  ///
  /// Parameters:
  /// - [board]: The event storming board to export
  /// - [options]: Optional export options
  ///
  /// Returns:
  /// A representation of the exported model
  dynamic export(EventStormingBoard board, {Map<String, dynamic> options = const {}});
}

/// Exports an Event Storming board to an EDNet Core domain model.
///
/// This exporter creates a complete EDNet Core domain model from
/// the event storming board, including concepts, attributes, events,
/// commands, and policies.
class EDNetCoreExporter implements ModelExporter {
  @override
  ednet_core.model.Model export(EventStormingBoard board, {Map<String, dynamic> options = const {}}) {
    // Create the EDNet Core model
    final model = ednet_core.model.Model(
      board.name,
      code: board.name.toLowerCase().replaceAll(' ', '_'),
      description: board.description,
    );
    
    // Create a domain for the model
    final domain = ednet_core.model.Domain(
      model,
      'domain',
      code: 'domain',
      description: 'Main domain for ${board.name}',
    );
    model.domains.add(domain);
    
    // Convert aggregates to concepts
    for (final aggregate in board.aggregates.values) {
      final concept = aggregate.toCoreAggregateConcept();
      domain.concepts.add(concept);
      
      // Add aggregate ID attribute
      concept.attributes.add(
        ednet_core.model.Attribute(
          concept,
          'id',
          code: 'id',
          type: 'String',
          init: '',
          essential: true,
          identifier: true,
        ),
      );
      
      // Get domain events for this aggregate
      final aggregateEvents = board.domainEvents.values
          .where((event) => event.aggregateId == aggregate.id)
          .toList();
      
      // Add event methods and properties
      for (final event in aggregateEvents) {
        // Add event method to concept
        final eventMethodName = 'raise${event.name}';
        
        // TODO: Add event method logic here
        // This would require generating method bodies
      }
    }
    
    // Convert read models to concepts
    for (final readModel in board.readModels.values) {
      final concept = readModel.toCoreConcept();
      domain.concepts.add(concept);
    }
    
    return model;
  }
}

/// Exports an Event Storming board to JSON format.
///
/// This exporter creates a structured JSON representation of the
/// event storming board that can be used for documentation or
/// further processing.
class JsonExporter implements ModelExporter {
  @override
  Map<String, dynamic> export(EventStormingBoard board, {Map<String, dynamic> options = const {}}) {
    // Convert the board to a structured JSON format
    final Map<String, dynamic> result = {};
    
    // Add board metadata
    result['name'] = board.name;
    result['description'] = board.description;
    result['createdAt'] = board.createdAt.toIso8601String();
    result['createdBy'] = board.createdBy;
    
    // Add domain entities
    result['domain'] = {
      'aggregates': _exportAggregates(board),
      'events': _exportEvents(board),
      'commands': _exportCommands(board),
      'policies': _exportPolicies(board),
      'readModels': _exportReadModels(board),
    };
    
    return result;
  }
  
  /// Converts aggregates to JSON format.
  List<Map<String, dynamic>> _exportAggregates(EventStormingBoard board) {
    return board.aggregates.values.map((aggregate) => {
      'id': aggregate.id,
      'name': aggregate.name,
      'description': aggregate.description,
      'events': aggregate.domainEventIds.map((id) => 
        board.domainEvents[id]?.name ?? 'Unknown Event'
      ).toList(),
      'commands': aggregate.commandIds.map((id) => 
        board.commands[id]?.name ?? 'Unknown Command'
      ).toList(),
    }).toList();
  }
  
  /// Converts events to JSON format.
  List<Map<String, dynamic>> _exportEvents(EventStormingBoard board) {
    return board.domainEvents.values.map((event) => {
      'id': event.id,
      'name': event.name,
      'description': event.description,
      'aggregate': event.aggregateId != null 
          ? board.aggregates[event.aggregateId]?.name 
          : null,
      'properties': event.properties,
    }).toList();
  }
  
  /// Converts commands to JSON format.
  List<Map<String, dynamic>> _exportCommands(EventStormingBoard board) {
    return board.commands.values.map((command) => {
      'id': command.id,
      'name': command.name,
      'description': command.description,
      'aggregate': command.aggregateId != null 
          ? board.aggregates[command.aggregateId]?.name 
          : null,
      'triggersEvent': command.triggersDomainEventId != null 
          ? board.domainEvents[command.triggersDomainEventId]?.name 
          : null,
      'parameters': command.parameters,
    }).toList();
  }
  
  /// Converts policies to JSON format.
  List<Map<String, dynamic>> _exportPolicies(EventStormingBoard board) {
    return board.policies.values.map((policy) => {
      'id': policy.id,
      'name': policy.name,
      'description': policy.description,
      'triggeringEvents': policy.triggeringEventIds.map((id) => 
        board.domainEvents[id]?.name ?? 'Unknown Event'
      ).toList(),
      'resultingCommands': policy.resultingCommandIds.map((id) => 
        board.commands[id]?.name ?? 'Unknown Command'
      ).toList(),
      'condition': policy.condition,
    }).toList();
  }
  
  /// Converts read models to JSON format.
  List<Map<String, dynamic>> _exportReadModels(EventStormingBoard board) {
    return board.readModels.values.map((readModel) => {
      'id': readModel.id,
      'name': readModel.name,
      'description': readModel.description,
      'fields': readModel.fields,
      'updatedByEvents': readModel.updatedByEventIds.map((id) => 
        board.domainEvents[id]?.name ?? 'Unknown Event'
      ).toList(),
    }).toList();
  }
}

/// Factory for creating model exporters.
///
/// This factory provides a convenient way to create the appropriate
/// exporter based on the desired output format.
class ModelExporterFactory {
  /// Creates an exporter for the specified format.
  ///
  /// Parameters:
  /// - [format]: The desired output format ('ednet_core', 'json', etc.)
  ///
  /// Returns:
  /// An exporter for the specified format
  ///
  /// Throws:
  /// ArgumentError if the format is not supported
  static ModelExporter createExporter(String format) {
    switch (format.toLowerCase()) {
      case 'ednet_core':
        return EDNetCoreExporter();
      case 'json':
        return JsonExporter();
      default:
        throw ArgumentError('Unsupported format: $format');
    }
  }
} 