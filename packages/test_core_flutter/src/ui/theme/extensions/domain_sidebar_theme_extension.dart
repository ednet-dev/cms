part of ednet_core_flutter;

/// Theme extension for the DomainSidebar component
class DomainSidebarThemeExtension
    extends ThemeExtension<DomainSidebarThemeExtension> {
  final DomainSidebarTheme sidebarTheme;

  const DomainSidebarThemeExtension({
    required this.sidebarTheme,
  });

  @override
  ThemeExtension<DomainSidebarThemeExtension> copyWith({
    DomainSidebarTheme? sidebarTheme,
  }) {
    return DomainSidebarThemeExtension(
      sidebarTheme: sidebarTheme ?? this.sidebarTheme,
    );
  }

  @override
  ThemeExtension<DomainSidebarThemeExtension> lerp(
    covariant ThemeExtension<DomainSidebarThemeExtension>? other,
    double t,
  ) {
    if (other is! DomainSidebarThemeExtension) {
      return this;
    }

    return DomainSidebarThemeExtension(
      sidebarTheme: sidebarTheme,
    );
  }
}
