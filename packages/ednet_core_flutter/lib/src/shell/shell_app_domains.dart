part of ednet_core_flutter;

/// Extends ShellApp to support multiple domains
extension ShellAppDomainExtension on ShellApp {
  /// Initializes the shell with multiple domains
  void initializeWithDomains(List<Domain> domains,
      {int initialDomainIndex = 0}) {
    if (_domainManager == null) {
      // Create a domain manager with the provided domains
      _domainManager = ShellDomainManager(domains);

      // Set initial domain index
      if (initialDomainIndex >= 0 && initialDomainIndex < domains.length) {
        (_domainManager as ShellDomainManager)
            .switchToDomain(initialDomainIndex);
      }
    }
  }

  /// Access to the domain manager
  ShellDomainManager? get domainManager =>
      _domainManager;

  /// Switch to a different domain by index
  void switchToDomain(int domainIndex) {
    domainManager?.switchToDomain(domainIndex);
    notifyListeners(); // Notify listeners of the change
  }

  /// Switch to a different domain by code
  void switchToDomainByCode(String domainCode) {
    domainManager?.switchToDomainByCode(domainCode);
    notifyListeners(); // Notify listeners of the change
  }

  /// Get all available domains
  List<Domain>? get availableDomains => domainManager?.domains;

  /// Get the currently selected domain index
  int get currentDomainIndex => domainManager?.currentDomainIndex ?? 0;

  /// Check if this ShellApp manages multiple domains
  bool get isMultiDomain =>
      domainManager != null && domainManager!.domains.length > 1;
}

/// UI component for domain navigation in a multi-domain shell
class DomainSelector extends StatefulWidget {
  /// The shell app
  final ShellApp shellApp;

  /// Optional builder for domain items
  final Widget Function(BuildContext, Domain, bool)? domainItemBuilder;

  /// Style customization for the domain selector
  final DomainSelectorStyle? style;

  /// Constructor
  const DomainSelector({
    Key? key,
    required this.shellApp,
    this.domainItemBuilder,
    this.style,
  }) : super(key: key);

  @override
  State<DomainSelector> createState() => _DomainSelectorState();
}

class _DomainSelectorState extends State<DomainSelector> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.shellApp.currentDomainIndex;
    widget.shellApp.addListener(_onShellAppChanged);
  }

  @override
  void dispose() {
    widget.shellApp.removeListener(_onShellAppChanged);
    super.dispose();
  }

  void _onShellAppChanged() {
    if (mounted) {
      setState(() {
        _currentIndex = widget.shellApp.currentDomainIndex;
      });
    }
  }

  @override
  void didUpdateWidget(DomainSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shellApp != widget.shellApp) {
      oldWidget.shellApp.removeListener(_onShellAppChanged);
      widget.shellApp.addListener(_onShellAppChanged);
      _currentIndex = widget.shellApp.currentDomainIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final domainManager = widget.shellApp.domainManager;

    if (domainManager == null || domainManager.domains.length <= 1) {
      return const SizedBox.shrink();
    }

    final domains = domainManager.domains;
    final effectiveStyle = widget.style ?? const DomainSelectorStyle();

    switch (effectiveStyle.selectorType) {
      case DomainSelectorType.dropdown:
        return _buildDropdown(context, domains, effectiveStyle);
      case DomainSelectorType.tabs:
        return _buildTabs(context, domains, effectiveStyle);
      case DomainSelectorType.chips:
        return _buildChips(context, domains, effectiveStyle);
      default:
        return _buildDropdown(context, domains, effectiveStyle);
    }
  }

  Widget _buildDropdown(
    BuildContext context,
    List<Domain> domains,
    DomainSelectorStyle style,
  ) {
    return DropdownButton<int>(
      value: _currentIndex,
      underline: style.hideDropdownUnderline ? const SizedBox() : null,
      icon: style.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
      items: List.generate(domains.length, (index) {
        final domain = domains[index];
        return DropdownMenuItem<int>(
          value: index,
          child: widget.domainItemBuilder != null
              ? widget.domainItemBuilder!(
                  context, domain, index == _currentIndex)
              : Text(domain.code),
        );
      }),
      onChanged: (index) {
        if (index != null) {
          widget.shellApp.switchToDomain(index);
        }
      },
    );
  }

  Widget _buildTabs(
    BuildContext context,
    List<Domain> domains,
    DomainSelectorStyle style,
  ) {
    return DefaultTabController(
      length: domains.length,
      initialIndex: _currentIndex,
      child: TabBar(
        isScrollable: true,
        tabs: List.generate(domains.length, (index) {
          final domain = domains[index];
          return Tab(
            child: widget.domainItemBuilder != null
                ? widget.domainItemBuilder!(
                    context, domain, index == _currentIndex)
                : Text(domain.code),
          );
        }),
        onTap: (index) {
          widget.shellApp.switchToDomain(index);
        },
      ),
    );
  }

  Widget _buildChips(
    BuildContext context,
    List<Domain> domains,
    DomainSelectorStyle style,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(domains.length, (index) {
          final domain = domains[index];
          final isSelected = index == _currentIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: widget.domainItemBuilder != null
                  ? widget.domainItemBuilder!(context, domain, isSelected)
                  : Text(domain.code),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  widget.shellApp.switchToDomain(index);
                }
              },
            ),
          );
        }),
      ),
    );
  }
}

/// Style options for the domain selector
class DomainSelectorStyle {
  /// Type of selector to use
  final DomainSelectorType selectorType;

  /// Whether to hide the underline in dropdown type
  final bool hideDropdownUnderline;

  /// Custom icon for dropdown type
  final Icon? dropdownIcon;

  /// Custom styling for text items
  final TextStyle? textStyle;

  /// Custom styling for selected text items
  final TextStyle? selectedTextStyle;

  /// Constructor
  const DomainSelectorStyle({
    this.selectorType = DomainSelectorType.dropdown,
    this.hideDropdownUnderline = false,
    this.dropdownIcon,
    this.textStyle,
    this.selectedTextStyle,
  });
}

/// Types of domain selectors
enum DomainSelectorType {
  /// Dropdown selector
  dropdown,

  /// Tab bar selector
  tabs,

  /// Chip-based selector
  chips,
}
