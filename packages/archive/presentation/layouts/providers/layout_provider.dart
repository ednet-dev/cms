import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../strategy/layout_strategy.dart';
import '../strategy/compact_layout_strategy.dart';
import '../strategy/detailed_layout_strategy.dart';

/// Provider for managing layout strategies in the application
///
/// This class is part of the "holy trinity" architecture, managing the layout
/// strategy aspect of the application. It allows registering multiple layout
/// strategies, selecting between them, and provides the active strategy to
/// widgets that need layout decisions.
///
/// The LayoutProvider should be placed near the top of the widget tree using
/// a ChangeNotifierProvider, allowing all descendant widgets to access the
/// current layout strategy through Provider.of<LayoutProvider>.
class LayoutProvider extends ChangeNotifier {
  /// Map of available layout strategies by ID
  final Map<String, LayoutStrategy> _strategies = {};

  /// The currently active layout strategy
  late LayoutStrategy _activeStrategy;

  /// Default strategy ID to use if none is specified
  static const String defaultStrategyId = 'detailed';

  /// Storage key for persisting selected layout strategy
  static const String prefsKey = 'selected_layout_strategy';

  /// Constructor for LayoutProvider
  ///
  /// Automatically registers built-in strategies and sets the default active strategy.
  /// If [initialStrategyId] is provided, it will be used instead of the default.
  LayoutProvider({String? initialStrategyId}) {
    // Register built-in strategies
    _registerBuiltInStrategies();

    // Set initial active strategy
    final strategyId = initialStrategyId ?? defaultStrategyId;
    _activeStrategy =
        _strategies[strategyId] ?? _strategies[defaultStrategyId]!;
  }

  /// Register the built-in layout strategies
  void _registerBuiltInStrategies() {
    registerStrategy(CompactLayoutStrategy());
    registerStrategy(DetailedLayoutStrategy());
  }

  /// The currently active layout strategy
  LayoutStrategy get activeStrategy => _activeStrategy;

  /// List of all available layout strategies
  List<LayoutStrategy> get availableStrategies => _strategies.values.toList();

  /// Register a new layout strategy
  ///
  /// This method adds a strategy to the available strategies. If a strategy
  /// with the same ID already exists, it will be replaced.
  ///
  /// [strategy] - The layout strategy to register
  void registerStrategy(LayoutStrategy strategy) {
    _strategies[strategy.id] = strategy;
    notifyListeners();
  }

  /// Set the active layout strategy by ID
  ///
  /// This method changes the active layout strategy. If the specified
  /// strategy ID is not found, no change will occur.
  ///
  /// [strategyId] - The ID of the strategy to activate
  ///
  /// Returns true if the strategy was found and activated, false otherwise.
  bool setActiveStrategy(String strategyId) {
    if (_strategies.containsKey(strategyId)) {
      _activeStrategy = _strategies[strategyId]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Get the most suitable layout strategy for the current device
  ///
  /// This method evaluates all registered strategies and returns the
  /// one that reports being most suitable for the current device.
  ///
  /// [context] - The build context, used to access device information
  ///
  /// Returns the most suitable layout strategy.
  LayoutStrategy getMostSuitableStrategy(BuildContext context) {
    // Start with default strategy
    LayoutStrategy bestStrategy = _strategies[defaultStrategyId]!;

    // Check each strategy for suitability
    for (final strategy in _strategies.values) {
      if (strategy.isSuitableForDevice(context)) {
        bestStrategy = strategy;
        break;
      }
    }

    return bestStrategy;
  }

  /// Automatically select the most suitable layout strategy for the current device
  ///
  /// This method evaluates all registered strategies, selects the one that
  /// reports being most suitable for the current device, and makes it active.
  ///
  /// [context] - The build context, used to access device information
  ///
  /// Returns true if a suitable strategy was found and activated.
  bool autoSelectSuitableStrategy(BuildContext context) {
    final strategy = getMostSuitableStrategy(context);
    return setActiveStrategy(strategy.id);
  }
}

/// Extension methods for accessing LayoutProvider from BuildContext
extension LayoutProviderExtension on BuildContext {
  /// Get the active layout strategy from the nearest LayoutProvider
  ///
  /// This is a convenient way to access the current layout strategy
  /// directly from a BuildContext.
  ///
  /// Example:
  /// ```dart
  /// final layoutStrategy = context.layoutStrategy;
  /// ```
  LayoutStrategy get layoutStrategy {
    return Provider.of<LayoutProvider>(this, listen: false).activeStrategy;
  }

  /// Get specific layout constraints for a concept from the active strategy
  ///
  /// This is a convenient way to get layout constraints for a specific
  /// concept type without having to access the layout provider directly.
  ///
  /// Example:
  /// ```dart
  /// final constraints = context.getConstraintsForConcept('User', parentConstraints);
  /// ```
  BoxConstraints getConstraintsForConcept(
    String conceptType,
    BoxConstraints parentConstraints,
  ) {
    return Provider.of<LayoutProvider>(
      this,
      listen: false,
    ).activeStrategy.getConstraintsForConcept(conceptType, parentConstraints);
  }
}
