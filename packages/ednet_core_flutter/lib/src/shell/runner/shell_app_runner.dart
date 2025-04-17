part of ednet_core_flutter;

/// The standard shell application runner for ednet_core_flutter
class ShellAppRunner extends StatefulWidget {
  /// The shell application instance
  final ShellApp shellApp;

  /// Theme data for the app (optional)
  final ThemeData? theme;

  /// Dark theme data for the app (optional)
  final ThemeData? darkTheme;

  /// Whether to use material 3 design
  final bool useMaterial3;

  /// Constructor
  const ShellAppRunner({
    super.key,
    required this.shellApp,
    this.theme,
    this.darkTheme,
    this.useMaterial3 = true,
  });

  @override
  State<ShellAppRunner> createState() => _ShellAppRunnerState();
}

class _ShellAppRunnerState extends State<ShellAppRunner> {
  @override
  void initState() {
    super.initState();
    widget.shellApp.addListener(_rebuildOnShellChanges);
    // If shell has a theme service, listen to it too
    widget.shellApp.themeService.addListener(_rebuildOnShellChanges);
  }

  @override
  void dispose() {
    widget.shellApp.removeListener(_rebuildOnShellChanges);
    widget.shellApp.themeService.removeListener(_rebuildOnShellChanges);
    super.dispose();
  }

  void _rebuildOnShellChanges() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use theme from the theme service if available, otherwise use provided themes
    return MaterialApp(
      navigatorKey: GlobalNavigatorKey.currentState != null
          ? GlobalNavigatorKey
          : GlobalKey<NavigatorState>(),
      title: 'EDNet Core Flutter Shell',
      debugShowCheckedModeBanner: false,
      themeMode: widget.shellApp.themeMode,
      theme:
          widget.theme ?? widget.shellApp.themeService.getCurrentTheme(context),
      darkTheme: widget.darkTheme ?? widget.shellApp.themeService.darkTheme,
      home: _buildMainView(),
    );
  }

  Widget _buildMainView() {
    // Check if this shell has multiple domains
    if (widget.shellApp.isMultiDomain) {
      // Use MultiDomainNavigator for multi-domain support
      return MultiDomainNavigator(shellApp: widget.shellApp);
    } else {
      return DomainNavigator(shellApp: widget.shellApp);
    }
  }
}
