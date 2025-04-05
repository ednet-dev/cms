// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

import 'package:ednet_flow/ednet_flow.dart';
import 'package:ednet_flow/src/event_storming/model/element.dart';

// This file is part of the EDNetFlow library.
// Restored imports for source file organization.





/// Analyzes an Event Storming board to identify patterns, issues, and insights.
///
/// The domain analyzer examines the relationships between elements on the board
/// and provides insights about the domain structure, potential issues, and
/// recommendations for improvement.
class DomainAnalyzer {
  /// Analyzes the board and returns a comprehensive analysis report.
  ///
  /// Parameters:
  /// - [board]: The event storming board to analyze
  ///
  /// Returns:
  /// An analysis report with insights about the domain
  DomainAnalysisReport analyze(EventStormingBoard board) {
    final aggregateInsights = _analyzeAggregates(board);
    final eventInsights = _analyzeEvents(board);
    final commandInsights = _analyzeCommands(board);
    final policyInsights = _analyzePolicies(board);
    final hotSpotInsights = _analyzeHotSpots(board);

    final recommendations = [
      ...aggregateInsights.recommendations,
      ...eventInsights.recommendations,
      ...commandInsights.recommendations,
      ...policyInsights.recommendations,
      ...hotSpotInsights.recommendations,
    ];

    final issues = [
      ...aggregateInsights.issues,
      ...eventInsights.issues,
      ...commandInsights.issues,
      ...policyInsights.issues,
      ...hotSpotInsights.issues,
    ];

    final patterns = _identifyPatterns(board);

    return DomainAnalysisReport(
      aggregateInsights: aggregateInsights,
      eventInsights: eventInsights,
      commandInsights: commandInsights,
      policyInsights: policyInsights,
      hotSpotInsights: hotSpotInsights,
      patterns: patterns,
      recommendations: recommendations,
      issues: issues,
    );
  }

  /// Analyzes aggregates for insights.
  AggregateInsights _analyzeAggregates(EventStormingBoard board) {
    final orphanedAggregates = <String>[];
    final largeAggregates = <String>[];
    final recommendations = <String>[];
    final issues = <String>[];

    for (final entry in board.aggregates.entries) {
      final aggregate = entry.value;

      // Check for orphaned aggregates (no events or commands)
      if (aggregate.domainEventIds.isEmpty && aggregate.commandIds.isEmpty) {
        orphanedAggregates.add(aggregate.id);
        issues.add(
          'Aggregate "${aggregate.name}" has no associated events or commands',
        );
        recommendations.add(
          'Consider adding events and commands to "${aggregate.name}" or removing it',
        );
      }

      // Check for large aggregates (too many events/commands)
      if (aggregate.domainEventIds.length > 10 ||
          aggregate.commandIds.length > 10) {
        largeAggregates.add(aggregate.id);
        issues.add(
          'Aggregate "${aggregate.name}" has many events/commands and might be too large',
        );
        recommendations.add(
          'Consider splitting "${aggregate.name}" into multiple aggregates',
        );
      }
    }

    return AggregateInsights(
      totalCount: board.aggregates.length,
      orphanedAggregateIds: orphanedAggregates,
      largeAggregateIds: largeAggregates,
      recommendations: recommendations,
      issues: issues,
    );
  }

  /// Analyzes events for insights.
  EventInsights _analyzeEvents(EventStormingBoard board) {
    final orphanedEvents = <String>[];
    final pivotalEvents = <String>[];
    final recommendations = <String>[];
    final issues = <String>[];

    for (final entry in board.domainEvents.entries) {
      final event = entry.value;

      // Check for orphaned events (not associated with any aggregate)
      if (event.aggregateId == null) {
        orphanedEvents.add(event.id);
        issues.add(
          'Event "${event.name}" is not associated with any aggregate',
        );
        recommendations.add(
          'Associate "${event.name}" with an appropriate aggregate',
        );
      }

      // Identify pivotal events (many related commands or policies)
      int relatedCount = 0;

      // Count commands that trigger this event
      relatedCount +=
          board.commands.values
              .where((cmd) => cmd.triggersDomainEventId == event.id)
              .length;

      // Count policies that are triggered by this event
      relatedCount +=
          board.policies.values
              .where((policy) => policy.triggeringEventIds.contains(event.id))
              .length;

      if (relatedCount > 3) {
        pivotalEvents.add(event.id);
        recommendations.add(
          'Event "${event.name}" is pivotal and might deserve special attention',
        );
      }
    }

    return EventInsights(
      totalCount: board.domainEvents.length,
      orphanedEventIds: orphanedEvents,
      pivotalEventIds: pivotalEvents,
      recommendations: recommendations,
      issues: issues,
    );
  }

  /// Analyzes commands for insights.
  CommandInsights _analyzeCommands(EventStormingBoard board) {
    final orphanedCommands = <String>[];
    final incompleteCommands = <String>[];
    final recommendations = <String>[];
    final issues = <String>[];

    for (final entry in board.commands.entries) {
      final command = entry.value;

      // Check for orphaned commands (not associated with any aggregate)
      if (command.aggregateId == null) {
        orphanedCommands.add(command.id);
        issues.add(
          'Command "${command.name}" is not associated with any aggregate',
        );
        recommendations.add(
          'Associate "${command.name}" with an appropriate aggregate',
        );
      }

      // Check for incomplete commands (no resulting event)
      if (command.triggersDomainEventId == null) {
        incompleteCommands.add(command.id);
        issues.add('Command "${command.name}" has no resulting event');
        recommendations.add(
          'Consider what event "${command.name}" should produce',
        );
      }
    }

    return CommandInsights(
      totalCount: board.commands.length,
      orphanedCommandIds: orphanedCommands,
      incompleteCommandIds: incompleteCommands,
      recommendations: recommendations,
      issues: issues,
    );
  }

  /// Analyzes policies for insights.
  PolicyInsights _analyzePolicies(EventStormingBoard board) {
    final orphanedPolicies = <String>[];
    final incompletePolicies = <String>[];
    final recommendations = <String>[];
    final issues = <String>[];

    for (final entry in board.policies.entries) {
      final policy = entry.value;

      // Check for orphaned policies (no triggering events)
      if (policy.triggeringEventIds.isEmpty) {
        orphanedPolicies.add(policy.id);
        issues.add('Policy "${policy.name}" has no triggering events');
        recommendations.add(
          'Identify what events should trigger "${policy.name}"',
        );
      }

      // Check for incomplete policies (no resulting commands)
      if (policy.resultingCommandIds.isEmpty) {
        incompletePolicies.add(policy.id);
        issues.add('Policy "${policy.name}" has no resulting commands');
        recommendations.add(
          'Determine what commands "${policy.name}" should initiate',
        );
      }
    }

    return PolicyInsights(
      totalCount: board.policies.length,
      orphanedPolicyIds: orphanedPolicies,
      incompletePolicyIds: incompletePolicies,
      recommendations: recommendations,
      issues: issues,
    );
  }

  /// Analyzes hot spots for insights.
  HotSpotInsights _analyzeHotSpots(EventStormingBoard board) {
    final highPriorityHotSpots = <String>[];
    final unresolvedHotSpots = <String>[];
    final recommendations = <String>[];
    final issues = <String>[];

    for (final entry in board.hotSpots.entries) {
      final hotSpot = entry.value;

      // Identify high-priority hot spots
      if (hotSpot.importance >= 4) {
        highPriorityHotSpots.add(hotSpot.id);
        issues.add(
          'Hot spot "${hotSpot.title}" has high importance (${hotSpot.importance}) and needs attention',
        );
      }

      // Identify unresolved hot spots (no proposed solutions)
      if (hotSpot.proposedSolutions.isEmpty) {
        unresolvedHotSpots.add(hotSpot.id);
        recommendations.add(
          'Brainstorm solutions for hot spot "${hotSpot.title}"',
        );
      }
    }

    return HotSpotInsights(
      totalCount: board.hotSpots.length,
      highPriorityHotSpotIds: highPriorityHotSpots,
      unresolvedHotSpotIds: unresolvedHotSpots,
      recommendations: recommendations,
      issues: issues,
    );
  }

  /// Identifies patterns in the domain model.
  List<DomainPattern> _identifyPatterns(EventStormingBoard board) {
    final patterns = <DomainPattern>[];

    // Identify CQRS pattern
    if (board.readModels.isNotEmpty) {
      patterns.add(
        DomainPattern(
          name: 'CQRS',
          description: 'Command Query Responsibility Segregation',
          strength: 'High',
          elements: board.readModels.keys.toList(),
        ),
      );
    }

    // Identify Event Sourcing pattern
    if (board.domainEvents.length > board.commands.length * 1.5) {
      patterns.add(
        DomainPattern(
          name: 'Event Sourcing',
          description: 'Storing state as a sequence of events',
          strength: 'Medium',
          elements: board.domainEvents.keys.toList(),
        ),
      );
    }

    // Identify Process Manager pattern
    if (board.policies.length > 3) {
      patterns.add(
        DomainPattern(
          name: 'Process Manager',
          description: 'Coordinating processes across aggregates',
          strength: 'Medium',
          elements: board.policies.keys.toList(),
        ),
      );
    }

    return patterns;
  }
}

/// Represents a pattern identified in the domain model.
class DomainPattern {
  /// The name of the pattern.
  final String name;

  /// Description of the pattern.
  final String description;

  /// How strongly the pattern is present (Low, Medium, High).
  final String strength;

  /// IDs of elements that form this pattern.
  final List<String> elements;

  /// Creates a new domain pattern.
  DomainPattern({
    required this.name,
    required this.description,
    required this.strength,
    required this.elements,
  });
}

/// Contains insights about aggregates in the domain model.
class AggregateInsights {
  /// Total number of aggregates.
  final int totalCount;

  /// IDs of aggregates without events or commands.
  final List<String> orphanedAggregateIds;

  /// IDs of aggregates with too many events/commands.
  final List<String> largeAggregateIds;

  /// Recommendations for improving aggregates.
  final List<String> recommendations;

  /// Issues identified with aggregates.
  final List<String> issues;

  /// Creates a new aggregate insights object.
  AggregateInsights({
    required this.totalCount,
    required this.orphanedAggregateIds,
    required this.largeAggregateIds,
    required this.recommendations,
    required this.issues,
  });
}

/// Contains insights about events in the domain model.
class EventInsights {
  /// Total number of events.
  final int totalCount;

  /// IDs of events not associated with any aggregate.
  final List<String> orphanedEventIds;

  /// IDs of events that are central to the domain.
  final List<String> pivotalEventIds;

  /// Recommendations for improving events.
  final List<String> recommendations;

  /// Issues identified with events.
  final List<String> issues;

  /// Creates a new event insights object.
  EventInsights({
    required this.totalCount,
    required this.orphanedEventIds,
    required this.pivotalEventIds,
    required this.recommendations,
    required this.issues,
  });
}

/// Contains insights about commands in the domain model.
class CommandInsights {
  /// Total number of commands.
  final int totalCount;

  /// IDs of commands not associated with any aggregate.
  final List<String> orphanedCommandIds;

  /// IDs of commands that don't produce any event.
  final List<String> incompleteCommandIds;

  /// Recommendations for improving commands.
  final List<String> recommendations;

  /// Issues identified with commands.
  final List<String> issues;

  /// Creates a new command insights object.
  CommandInsights({
    required this.totalCount,
    required this.orphanedCommandIds,
    required this.incompleteCommandIds,
    required this.recommendations,
    required this.issues,
  });
}

/// Contains insights about policies in the domain model.
class PolicyInsights {
  /// Total number of policies.
  final int totalCount;

  /// IDs of policies without triggering events.
  final List<String> orphanedPolicyIds;

  /// IDs of policies that don't initiate any commands.
  final List<String> incompletePolicyIds;

  /// Recommendations for improving policies.
  final List<String> recommendations;

  /// Issues identified with policies.
  final List<String> issues;

  /// Creates a new policy insights object.
  PolicyInsights({
    required this.totalCount,
    required this.orphanedPolicyIds,
    required this.incompletePolicyIds,
    required this.recommendations,
    required this.issues,
  });
}

/// Contains insights about hot spots in the domain model.
class HotSpotInsights {
  /// Total number of hot spots.
  final int totalCount;

  /// IDs of hot spots with high importance.
  final List<String> highPriorityHotSpotIds;

  /// IDs of hot spots without proposed solutions.
  final List<String> unresolvedHotSpotIds;

  /// Recommendations for addressing hot spots.
  final List<String> recommendations;

  /// Issues identified with hot spots.
  final List<String> issues;

  /// Creates a new hot spot insights object.
  HotSpotInsights({
    required this.totalCount,
    required this.highPriorityHotSpotIds,
    required this.unresolvedHotSpotIds,
    required this.recommendations,
    required this.issues,
  });
}

/// Comprehensive report from analyzing a domain model.
class DomainAnalysisReport {
  /// Insights about aggregates.
  final AggregateInsights aggregateInsights;

  /// Insights about events.
  final EventInsights eventInsights;

  /// Insights about commands.
  final CommandInsights commandInsights;

  /// Insights about policies.
  final PolicyInsights policyInsights;

  /// Insights about hot spots.
  final HotSpotInsights hotSpotInsights;

  /// Patterns identified in the domain model.
  final List<DomainPattern> patterns;

  /// Overall recommendations for improving the domain model.
  final List<String> recommendations;

  /// Overall issues identified in the domain model.
  final List<String> issues;

  /// Creates a new domain analysis report.
  DomainAnalysisReport({
    required this.aggregateInsights,
    required this.eventInsights,
    required this.commandInsights,
    required this.policyInsights,
    required this.hotSpotInsights,
    required this.patterns,
    required this.recommendations,
    required this.issues,
  });
}
