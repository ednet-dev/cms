part of ednet_core_flutter;

/// A Flutter app that wraps the Shell
class ShellAppRunner extends StatefulWidget {
  /// The shell app to run
  final ShellApp shellApp;

  /// Optional theme override
  final ThemeData? theme;

  /// Constructor
  const ShellAppRunner({Key? key, required this.shellApp, this.theme})
      : super(key: key);

  @override
  State<ShellAppRunner> createState() => _ShellAppRunnerState();
}

class _ShellAppRunnerState extends State<ShellAppRunner> {
  @override
  Widget build(BuildContext context) {
    // Create a widget that gives access to the shell without additional MaterialApp
    // This prevents nesting MaterialApp widgets when used in client apps
    final effectiveTheme = widget.theme ??
        widget.shellApp.configuration.theme ??
        Theme.of(context);

    final navigator = widget.shellApp.isMultiDomain
        ? MultiDomainNavigator(shellApp: widget.shellApp)
        : DomainNavigator(shellApp: widget.shellApp);

    // Use Scaffold to ensure consistent layout with AppBar
    return Theme(
      data: effectiveTheme,
      child: navigator,
    );
  }
}
