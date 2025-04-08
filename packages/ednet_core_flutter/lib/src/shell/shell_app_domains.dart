part of ednet_core_flutter;

/// Extends ShellApp to support multiple domains
extension ShellAppDomainExtension on ShellApp {
  /// Initializes the shell with multiple domains
  void initializeWithDomains(Domains domains, {int initialDomainIndex = 0}) {
    if (_domainManager == null) {
      _domainManager = _DomainManager(
        domains: domains,
        initialDomainIndex: initialDomainIndex,
        shellApp: this,
      );
    }
  }

  /// Access to the domain manager
  _DomainManager? get domainManager => _domainManager;

  /// Switch to a different domain by index
  void switchToDomain(int domainIndex) {
    _domainManager?.switchToDomain(domainIndex);
  }

  /// Switch to a different domain by code
  void switchToDomainByCode(String domainCode) {
    _domainManager?.switchToDomainByCode(domainCode);
  }

  /// Get all available domains
  Domains? get availableDomains => _domainManager?.domains;

  /// Get the currently selected domain index
  int get currentDomainIndex => _domainManager?.currentDomainIndex ?? 0;

  /// Check if this ShellApp manages multiple domains
  bool get isMultiDomain =>
      _domainManager != null && _domainManager!.domains.length > 1;
}

/// Manages multiple domains for a ShellApp
class _DomainManager {
  /// All available domains
  final Domains domains;

  /// Index of the currently selected domain
  int currentDomainIndex;

  /// Reference to the shell app
  final ShellApp shellApp;

  /// Observers for domain change events
  final List<void Function(Domain)> _domainChangeObservers = [];

  /// Constructor
  _DomainManager({
    required this.domains,
    required int initialDomainIndex,
    required this.shellApp,
  }) : currentDomainIndex = initialDomainIndex.clamp(0, domains.length - 1);

  /// Get the current domain
  Domain get currentDomain => domains[currentDomainIndex];

  /// Switch to a domain by index
  void switchToDomain(int domainIndex) {
    if (domainIndex < 0 || domainIndex >= domains.length) {
      throw ArgumentError(
          'Domain index $domainIndex out of range (0-${domains.length - 1})');
    }

    if (domainIndex != currentDomainIndex) {
      currentDomainIndex = domainIndex;

      // Notify observers
      for (final observer in _domainChangeObservers) {
        observer(currentDomain);
      }
    }
  }

  /// Switch to a domain by code
  void switchToDomainByCode(String domainCode) {
    final domainsList = domains.toList();
    int index = -1;

    for (int i = 0; i < domainsList.length; i++) {
      if (domainsList[i].code == domainCode) {
        index = i;
        break;
      }
    }

    if (index >= 0) {
      switchToDomain(index);
    } else {
      throw ArgumentError('Domain with code $domainCode not found');
    }
  }

  /// Add an observer for domain changes
  void addDomainChangeObserver(void Function(Domain) observer) {
    _domainChangeObservers.add(observer);
  }

  /// Remove an observer
  void removeDomainChangeObserver(void Function(Domain) observer) {
    _domainChangeObservers.remove(observer);
  }
}

/// UI component for domain navigation in a multi-domain shell
class DomainSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final domainManager = shellApp.domainManager;

    if (domainManager == null || domainManager.domains.length <= 1) {
      return const SizedBox.shrink();
    }

    final domains = domainManager.domains.toList();
    final currentIndex = domainManager.currentDomainIndex;

    // Use default style if none provided
    final effectiveStyle = style ?? DomainSelectorStyle();

    switch (effectiveStyle.selectorType) {
      case DomainSelectorType.dropdown:
        return _buildDropdown(context, domains, currentIndex, effectiveStyle);
      case DomainSelectorType.tabs:
        return _buildTabs(context, domains, currentIndex, effectiveStyle);
      case DomainSelectorType.chips:
        return _buildChips(context, domains, currentIndex, effectiveStyle);
      default:
        return _buildDropdown(context, domains, currentIndex, effectiveStyle);
    }
  }

  Widget _buildDropdown(
    BuildContext context,
    List<Domain> domains,
    int currentIndex,
    DomainSelectorStyle style,
  ) {
    return DropdownButton<int>(
      value: currentIndex,
      underline: style.hideDropdownUnderline ? const SizedBox() : null,
      icon: style.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
      items: List.generate(domains.length, (index) {
        final domain = domains[index];
        return DropdownMenuItem<int>(
          value: index,
          child: domainItemBuilder != null
              ? domainItemBuilder!(context, domain, index == currentIndex)
              : Text(domain.code),
        );
      }),
      onChanged: (index) {
        if (index != null) {
          shellApp.switchToDomain(index);
        }
      },
    );
  }

  Widget _buildTabs(
    BuildContext context,
    List<Domain> domains,
    int currentIndex,
    DomainSelectorStyle style,
  ) {
    return DefaultTabController(
      length: domains.length,
      initialIndex: currentIndex,
      child: TabBar(
        isScrollable: true,
        tabs: List.generate(domains.length, (index) {
          final domain = domains[index];
          return Tab(
            child: domainItemBuilder != null
                ? domainItemBuilder!(context, domain, index == currentIndex)
                : Text(domain.code),
          );
        }),
        onTap: (index) {
          shellApp.switchToDomain(index);
        },
      ),
    );
  }

  Widget _buildChips(
    BuildContext context,
    List<Domain> domains,
    int currentIndex,
    DomainSelectorStyle style,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(domains.length, (index) {
          final domain = domains[index];
          final isSelected = index == currentIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: domainItemBuilder != null
                  ? domainItemBuilder!(context, domain, isSelected)
                  : Text(domain.code),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  shellApp.switchToDomain(index);
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
