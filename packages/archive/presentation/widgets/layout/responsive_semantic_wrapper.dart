import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:shared_preferences/shared_preferences.dart';
import 'semantic_pinning_service.dart';

/// Semantic priority levels for content adaptation based on importance
enum SemanticPriority {
  /// Critical content that must be shown on all device sizes
  critical,

  /// Important content shown on all sizes except mobile
  important,

  /// Useful content shown on tablet and larger
  standard,

  /// Supplementary content shown only on desktop/large screens
  auxiliary,

  /// Rich content only shown on very large screens (4K+)
  supplementary,
}

/// Screen size categories for adaptive layouts
enum ScreenSizeCategory {
  /// Mobile devices (<600px width)
  mobile,

  /// Tablet devices (600px-1024px)
  tablet,

  /// Desktop/Laptop screens (1024px-1920px)
  desktop,

  /// Full HD and QHD displays (1920px-3840px)
  largeDesktop,

  /// 4K and larger displays (3840px+)
  ultraWide,
}

/// Widget that wraps content with semantic prioritization and responsive behavior
class ResponsiveSemanticWrapper extends StatefulWidget {
  /// The semantic priority of this content
  final SemanticPriority priority;

  /// The child widget to display
  final Widget child;

  /// Optional alternative widget for smaller screens
  final Widget? compactChild;

  /// Whether to show a divider above this content
  final bool showDivider;

  /// The minimum screen category where this content should be visible
  final ScreenSizeCategory minScreenCategory;

  /// Unique identifier for this artifact (used for pinning)
  final String artifactId;

  /// Optional model code this artifact belongs to (used for pinning)
  final String? modelCode;

  /// Whether to show pin UI controls
  final bool allowPinning;

  /// Constructor for ResponsiveSemanticWrapper
  const ResponsiveSemanticWrapper({
    super.key,
    required this.child,
    required this.artifactId,
    this.priority = SemanticPriority.standard,
    this.compactChild,
    this.showDivider = false,
    this.minScreenCategory = ScreenSizeCategory.mobile,
    this.modelCode,
    this.allowPinning = true,
  });

  /// Helper constructor for critical content
  factory ResponsiveSemanticWrapper.critical({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      priority: SemanticPriority.critical,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.mobile,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for important content
  factory ResponsiveSemanticWrapper.important({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      priority: SemanticPriority.important,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.tablet,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for auxiliary content
  factory ResponsiveSemanticWrapper.auxiliary({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      priority: SemanticPriority.auxiliary,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.desktop,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for supplementary content (4K+ only)
  factory ResponsiveSemanticWrapper.supplementary({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      priority: SemanticPriority.supplementary,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.ultraWide,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Determine the current screen size category
  static ScreenSizeCategory getScreenCategory(BuildContext context) {
    // Check if a simulated screen size is set
    final simulatedSize = _getSimulatedScreenSize();
    if (simulatedSize != null) {
      return simulatedSize;
    }

    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return ScreenSizeCategory.mobile;
    } else if (width < 1024) {
      return ScreenSizeCategory.tablet;
    } else if (width < 1920) {
      return ScreenSizeCategory.desktop;
    } else if (width < 3840) {
      return ScreenSizeCategory.largeDesktop;
    } else {
      return ScreenSizeCategory.ultraWide;
    }
  }

  /// Get the simulated screen size from preferences if set
  static ScreenSizeCategory? _getSimulatedScreenSize() {
    // This is a synchronous method, so we use a static value
    // that's updated asynchronously by the UserLayoutSettings component
    return _simulatedScreenSizeOverride;
  }

  /// The currently active simulated screen size (if any)
  static ScreenSizeCategory? _simulatedScreenSizeOverride;

  /// Set the simulated screen size (used by UserLayoutSettings)
  static void setSimulatedScreenSize(ScreenSizeCategory? category) {
    _simulatedScreenSizeOverride = category;
  }

  /// Check if user edit mode is enabled
  static Future<bool> isEditModeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('edit_mode_enabled') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Check if pin controls should be shown
  static Future<bool> shouldShowPinControls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('show_pin_controls') ?? true;
    } catch (_) {
      return true;
    }
  }

  @override
  State<ResponsiveSemanticWrapper> createState() =>
      _ResponsiveSemanticWrapperState();
}

class _ResponsiveSemanticWrapperState extends State<ResponsiveSemanticWrapper> {
  late SemanticPinningService _pinningService;
  bool _isPinned = false;
  bool _pinningInitialized = false;
  bool _editModeEnabled = false;
  bool _showPinControls = true;

  @override
  void initState() {
    super.initState();
    _pinningService = SemanticPinningService();
    _initializePin();
    _loadUserPreferences();
  }

  /// Load user preferences for edit mode and pin controls
  Future<void> _loadUserPreferences() async {
    final editMode = await ResponsiveSemanticWrapper.isEditModeEnabled();
    final showControls =
        await ResponsiveSemanticWrapper.shouldShowPinControls();

    if (mounted) {
      setState(() {
        _editModeEnabled = editMode;
        _showPinControls = showControls;
      });
    }
  }

  @override
  void didUpdateWidget(ResponsiveSemanticWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.artifactId != widget.artifactId ||
        oldWidget.modelCode != widget.modelCode) {
      _initializePin();
    }
  }

  Future<void> _initializePin() async {
    if (widget.modelCode != null) {
      await _pinningService.initialize();
      setState(() {
        _isPinned = _pinningService.isPinned(
          widget.modelCode!,
          widget.artifactId,
        );
        _pinningInitialized = true;
      });
    } else {
      setState(() {
        _isPinned = false;
        _pinningInitialized = true;
      });
    }
  }

  Future<void> _togglePin() async {
    if (widget.modelCode == null) return;

    if (_isPinned) {
      await _pinningService.unpinArtifact(widget.modelCode!, widget.artifactId);
    } else {
      await _pinningService.pinArtifact(widget.modelCode!, widget.artifactId);
    }

    setState(() {
      _isPinned = !_isPinned;
    });
  }

  /// Check if the current screen should show content with this priority
  bool _shouldShow(ScreenSizeCategory currentCategory) {
    return currentCategory.index >= widget.minScreenCategory.index;
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = ResponsiveSemanticWrapper.getScreenCategory(
      context,
    );

    // If pinned or visible due to screen size, show the content
    final bool shouldShow = _isPinned || _shouldShow(currentCategory);

    // If this content shouldn't be shown at this screen size, return empty container
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    // Choose between compact or full version based on screen size
    final useCompactVersion =
        !_isPinned && currentCategory.index < ScreenSizeCategory.desktop.index;
    final content =
        useCompactVersion && widget.compactChild != null
            ? widget.compactChild!
            : widget.child;

    // Determine if pin button should be visible
    final showPinButton =
        widget.allowPinning &&
        widget.modelCode != null &&
        _pinningInitialized &&
        _editModeEnabled &&
        _showPinControls;

    // Display with optional pin button
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showDivider) const Divider(),

        // Content with optional pin button
        Stack(
          children: [
            // Main content with padding if pin button is visible
            Padding(
              padding: EdgeInsets.only(top: showPinButton ? 24.0 : 0.0),
              child: content,
            ),

            // Pin button if applicable
            if (showPinButton)
              Positioned(top: 0, right: 0, child: _buildPinButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildPinButton() {
    return IconButton(
      icon: Icon(
        _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        size: 16,
      ),
      tooltip: _isPinned ? 'Unpin this content' : 'Pin this content',
      onPressed: _togglePin,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    );
  }
}

/// Extension for semantic prioritization based on ednet.Attribute properties
extension AttributePriorityExtension on ednet.Attribute {
  /// Determine the semantic priority of this attribute
  SemanticPriority get semanticPriority {
    if (identifier == true) {
      return SemanticPriority.critical;
    } else if (required == true) {
      return SemanticPriority.important;
    } else if (essential == true) {
      return SemanticPriority.standard;
    } else if (sensitive == true) {
      return SemanticPriority.auxiliary;
    } else {
      return SemanticPriority.standard;
    }
  }
}

/// Helper function to categorize elements by their semantic priority
Map<SemanticPriority, List<T>> categorizeBySemantic<T>(
  List<T> items,
  SemanticPriority Function(T item) priorityExtractor,
) {
  final result = <SemanticPriority, List<T>>{};

  for (final priority in SemanticPriority.values) {
    result[priority] = [];
  }

  for (final item in items) {
    final priority = priorityExtractor(item);
    result[priority]!.add(item);
  }

  return result;
}
