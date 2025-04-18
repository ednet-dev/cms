part of ednet_core_flutter;

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
    final effectiveStyle = style ?? const DomainSelectorStyle();

    // Wrap in a ResponsiveSemanticWrapper for responsive behavior
    return ResponsiveSemanticWrapper.basic(
      artifactId: 'domain_selector',
      child:
          _buildResponsiveLinks(context, domains, currentIndex, effectiveStyle),
    );
  }

  Widget _buildResponsiveLinks(
    BuildContext context,
    List<Domain> domains,
    int currentIndex,
    DomainSelectorStyle style,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get screen category to determine layout
        final screenCategory =
            ResponsiveSemanticWrapper.getScreenCategory(context);
        final isSmallScreen = screenCategory == ScreenSizeCategory.mobile;

        // For small screens, use a more compact layout
        if (isSmallScreen) {
          return _buildCompactLinks(context, domains, currentIndex, style);
        }

        // For larger screens, use a row of links
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildDomainLinks(context, domains, currentIndex, style),
          ),
        );
      },
    );
  }

  Widget _buildCompactLinks(
    BuildContext context,
    List<Domain> domains,
    int currentIndex,
    DomainSelectorStyle style,
  ) {
    return PopupMenuButton<int>(
      initialValue: currentIndex,
      onSelected: (index) => shellApp.switchToDomain(index),
      itemBuilder: (context) {
        return List.generate(domains.length, (index) {
          final domain = domains[index];
          final isSelected = index == currentIndex;

          return PopupMenuItem<int>(
            value: index,
            child: _buildDomainLink(context, domain, isSelected, style, false),
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDomainLink(
              context,
              domains[currentIndex],
              true,
              style,
              true,
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDomainLinks(
    BuildContext context,
    List<Domain> domains,
    int currentIndex,
    DomainSelectorStyle style,
  ) {
    return List.generate(domains.length, (index) {
      final domain = domains[index];
      final isSelected = index == currentIndex;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: () => shellApp.switchToDomain(index),
          child: _buildDomainLink(context, domain, isSelected, style, false),
        ),
      );
    });
  }

  Widget _buildDomainLink(
    BuildContext context,
    Domain domain,
    bool isSelected,
    DomainSelectorStyle style,
    bool isCompact,
  ) {
    final theme = Theme.of(context);

    // Use custom builder if provided
    if (domainItemBuilder != null) {
      return domainItemBuilder!(context, domain, isSelected);
    }

    // Default link styling
    final textStyle = isSelected
        ? (style.selectedTextStyle ??
            theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ))
        : (style.textStyle ?? theme.textTheme.bodyLarge);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isCompact ? 4.0 : 12.0,
      ),
      decoration: isSelected
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2.0,
                ),
              ),
            )
          : null,
      child: Text(
        domain.code,
        style: textStyle,
      ),
    );
  }
}
