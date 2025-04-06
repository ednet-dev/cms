/// EDNet Core Patterns library for system integration and messaging.
///
/// This library provides implementations of integration patterns used
/// to build distributed, message-based systems within the EDNet ecosystem.
///
/// Support for doing something awesome.
///
/// More dartdocs go here.
library ednet_core_patterns;

export 'src/ednet_core_patterns_base.dart';
export 'src/patterns/common/base_message.dart';
export 'src/patterns/common/channel.dart';
export 'src/patterns/common/http_types.dart';
export 'src/patterns/aggregator/aggregator.dart';
export 'src/patterns/canonical/canonical_model.dart';
export 'src/patterns/channel/adapter/channel_adapter.dart';
export 'src/patterns/filter/message_filter.dart';
export 'src/patterns/filter/ednet_core_message_filter.dart'
    hide MessagePredicate;

// Patterns will be exported here as they are implemented

// TODO: Export any libraries intended for clients of this package.
