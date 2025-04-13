part of ednet_core_flutter;

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
///
/// This component is part of the EDNet Shell Architecture's layout system for
/// implementing responsive, semantically-aware UIs with pinning capabilities.
class ResponsiveSemanticWrapper extends StatefulWidget {
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

  /// The disclosure level that determines detail visibility
  final DisclosureLevel disclosureLevel;

  /// Constructor for ResponsiveSemanticWrapper
  const ResponsiveSemanticWrapper({
    super.key,
    required this.child,
    required this.artifactId,
    this.compactChild,
    this.showDivider = false,
    this.minScreenCategory = ScreenSizeCategory.mobile,
    this.modelCode,
    this.allowPinning = true,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  /// Helper constructor for minimal disclosure content
  factory ResponsiveSemanticWrapper.minimal({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      disclosureLevel: DisclosureLevel.minimal,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.mobile,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for basic disclosure content
  factory ResponsiveSemanticWrapper.basic({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      disclosureLevel: DisclosureLevel.basic,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.mobile,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for intermediate disclosure content
  factory ResponsiveSemanticWrapper.intermediate({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      disclosureLevel: DisclosureLevel.intermediate,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.tablet,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for advanced disclosure content
  factory ResponsiveSemanticWrapper.advanced({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      disclosureLevel: DisclosureLevel.advanced,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.desktop,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for detailed disclosure content
  factory ResponsiveSemanticWrapper.detailed({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      disclosureLevel: DisclosureLevel.detailed,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.desktop,
      allowPinning: allowPinning,
      child: child,
    );
  }

  /// Helper constructor for complete disclosure content
  factory ResponsiveSemanticWrapper.complete({
    required Widget child,
    required String artifactId,
    String? modelCode,
    Widget? compactChild,
    bool showDivider = false,
    bool allowPinning = true,
  }) {
    return ResponsiveSemanticWrapper(
      disclosureLevel: DisclosureLevel.complete,
      artifactId: artifactId,
      modelCode: modelCode,
      compactChild: compactChild,
      showDivider: showDivider,
      minScreenCategory: ScreenSizeCategory.largeDesktop,
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

  /// Map disclosure level to minimum screen category
  ScreenSizeCategory _getMinScreenCategoryFromDisclosureLevel() {
    switch (widget.disclosureLevel) {
      case DisclosureLevel.minimal:
      case DisclosureLevel.basic:
        return ScreenSizeCategory.mobile;
      case DisclosureLevel.standard:
        return ScreenSizeCategory.tablet;
      case DisclosureLevel.intermediate:
        return ScreenSizeCategory.tablet;
      case DisclosureLevel.advanced:
        return ScreenSizeCategory.desktop;
      case DisclosureLevel.detailed:
        return ScreenSizeCategory.desktop;
      case DisclosureLevel.complete:
        return ScreenSizeCategory.largeDesktop;
      case DisclosureLevel.debug:
        return ScreenSizeCategory.mobile; // Debug mode shows everywhere
    }
  }

  /// Check if the current screen should show content with this disclosure level
  bool _shouldShow(ScreenSizeCategory currentCategory) {
    // Custom override
    if (widget.minScreenCategory != ScreenSizeCategory.mobile) {
      return currentCategory.index >= widget.minScreenCategory.index;
    }

    // Default behavior based on disclosure level
    final minCategory = _getMinScreenCategoryFromDisclosureLevel();
    return currentCategory.index >= minCategory.index;
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = ResponsiveSemanticWrapper.getScreenCategory(
      context,
    );

    // If pinned or visible due to screen size, show the content
    final shouldShow = _isPinned || _shouldShow(currentCategory);

    // If this content shouldn't be shown at this screen size, return empty container
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    // Choose between compact or full version based on screen size
    final useCompactVersion =
        !_isPinned && currentCategory.index < ScreenSizeCategory.desktop.index;
    final content = useCompactVersion && widget.compactChild != null
        ? widget.compactChild!
        : widget.child;

    // Determine if pin button should be visible
    final showPinButton = widget.allowPinning &&
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

/// Extension for semantic prioritization based on Attribute properties
extension AttributeDisclosureLevelExtension on Attribute {
  /// Determine the disclosure level of this attribute
  DisclosureLevel get disclosureLevel {
    if (identifier == true) {
      return DisclosureLevel.minimal;
    } else if (required is bool && required as bool) {
      return DisclosureLevel.basic;
    } else if (essential == true) {
      return DisclosureLevel.standard;
    } else if (sensitive == true) {
      return DisclosureLevel.advanced;
    } else {
      return DisclosureLevel.standard;
    }
  }
}

/// Helper function to categorize elements by their disclosure level
Map<DisclosureLevel, List<T>> categorizeByDisclosureLevel<T>(
  List<T> items,
  DisclosureLevel Function(T item) levelExtractor,
) {
  final result = <DisclosureLevel, List<T>>{};

  for (final level in DisclosureLevel.values) {
    result[level] = [];
  }

  for (final item in items) {
    final level = levelExtractor(item);
    result[level]!.add(item);
  }

  return result;
}
