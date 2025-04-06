import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;
import 'filter_entities.dart';

/// Domain model for Message Filter pattern tests
///
/// In a digital democracy platform, the Message Filter pattern enables:
/// - Topic-specific discussion threads for focused citizen deliberation
/// - Regional/jurisdictional filtering for relevant governance
/// - Interest-based filtering to connect citizens with relevant proposals
/// - Language preference filtering for inclusive multilingual democracy
/// - Content moderation to maintain civil democratic discourse
class MessageFilterDomain {
  /// Creates test channels for citizen discussion threads
  ///
  /// In a democracy platform, these channels represent various contexts:
  /// - General discussion forum for all citizens
  /// - Topic-specific deliberation threads (housing, transportation, etc.)
  /// - Jurisdiction-specific channels (local, regional, national)
  /// - Citizen interest groups and committees
  Map<String, patterns.InMemoryChannel> createDeliberationChannels() {
    final channels = <String, patterns.InMemoryChannel>{};

    // Main discussion channel that receives all citizen messages
    channels['all-discussions'] = patterns.InMemoryChannel(
      id: 'all-discussions',
      broadcast: true,
    );

    // Topic-specific channels for focused deliberation
    channels['housing'] = patterns.InMemoryChannel(
      id: 'housing-policy',
      broadcast: true,
    );

    channels['transportation'] = patterns.InMemoryChannel(
      id: 'transportation-policy',
      broadcast: true,
    );

    channels['environment'] = patterns.InMemoryChannel(
      id: 'environmental-policy',
      broadcast: true,
    );

    // Regional channels for jurisdiction-specific discussions
    channels['north-district'] = patterns.InMemoryChannel(
      id: 'north-district',
      broadcast: true,
    );

    channels['south-district'] = patterns.InMemoryChannel(
      id: 'south-district',
      broadcast: true,
    );

    // Special interest channels
    channels['youth-council'] = patterns.InMemoryChannel(
      id: 'youth-council',
      broadcast: true,
    );

    return channels;
  }

  /// Creates a topic filter for routing messages to topic-specific discussion threads
  ///
  /// In a democracy platform, topic filters ensure:
  /// - Citizens can focus on policy areas of interest
  /// - Deliberations stay on-topic and relevant
  /// - Specialized knowledge can be applied to specific domains
  /// - Clear organization of democratic discourse
  TestPredicateFilter createTopicFilter({
    required patterns.Channel sourceChannel,
    required patterns.Channel targetChannel,
    required String topic,
    String name = 'topic-filter',
  }) {
    return TestPredicateFilter(
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      name: name,
      predicate: (message) {
        // Check if message topic matches the target topic
        return message.metadata['topic'] == topic;
      },
    );
  }

  /// Creates a regional filter for jurisdiction-specific discussions
  ///
  /// In a democracy platform, regional filters:
  /// - Direct citizens to relevant local governance issues
  /// - Ensure information is jurisdictionally appropriate
  /// - Support multi-level democratic participation
  /// - Connect citizens with their immediate community
  TestSelectorFilter<String> createRegionalFilter({
    required patterns.Channel sourceChannel,
    required patterns.Channel targetChannel,
    required String region,
    String name = 'regional-filter',
  }) {
    return TestSelectorFilter<String>(
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      name: name,
      selector: (message) => message.metadata['region'] as String? ?? '',
      expectedValue: region,
    );
  }

  /// Creates a composite filter combining multiple democratic filtering criteria
  ///
  /// In a democracy platform, composite filters enable:
  /// - Targeted citizen engagement based on multiple factors
  /// - Personalized democratic participation experiences
  /// - Complex policy area intersections (e.g., urban housing AND sustainability)
  /// - Relevance enhancement for citizen information
  TestCompositeFilter createCompositeFilter({
    required patterns.Channel sourceChannel,
    required patterns.Channel targetChannel,
    required List<bool Function(patterns.Message)> filters,
    required String operation,
    String name = 'composite-filter',
  }) {
    return TestCompositeFilter(
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      name: name,
      filters: filters,
      operation: operation,
    );
  }

  /// Creates a language preference filter for multilingual democratic participation
  ///
  /// In a democracy platform, language filters:
  /// - Support inclusive participation across language barriers
  /// - Direct citizens to content in their preferred languages
  /// - Ensure equal access to democratic processes
  /// - Support cultural diversity in democratic institutions
  TestPredicateFilter createLanguageFilter({
    required patterns.Channel sourceChannel,
    required patterns.Channel targetChannel,
    required String language,
    String name = 'language-filter',
  }) {
    return TestPredicateFilter(
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      name: name,
      predicate: (message) {
        // Messages without language metadata default to the platform's primary language
        final msgLanguage = message.metadata['language'] as String? ?? 'en';
        return msgLanguage == language;
      },
    );
  }

  /// Creates a democratic discourse moderation filter
  ///
  /// In a democracy platform, moderation filters:
  /// - Maintain civil democratic discourse
  /// - Filter inappropriate content from deliberation spaces
  /// - Ensure safe participation for all citizens
  /// - Uphold community standards and guidelines
  TestPredicateFilter createModerationFilter({
    required patterns.Channel sourceChannel,
    required patterns.Channel targetChannel,
    required List<String> blockedTerms,
    String name = 'moderation-filter',
  }) {
    return TestPredicateFilter(
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      name: name,
      predicate: (message) {
        // Check message content against blocked terms
        final content = message.payload['content'] as String? ?? '';
        // Message passes filter if it doesn't contain blocked terms
        return !blockedTerms.any(
          (term) => content.toLowerCase().contains(term.toLowerCase()),
        );
      },
    );
  }
}
