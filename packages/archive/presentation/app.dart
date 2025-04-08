import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/pages/project_management/project_management_page.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/layouts/app_shell.dart';
import 'package:ednet_one/presentation/theme/theme_service.dart';
import 'package:ednet_one/presentation/navigation/navigation_service.dart';
import 'package:ednet_one/presentation/modules/module_registry.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart';

/// Main App component
class App extends StatefulWidget {
  /// Constructor
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Use the global instances from main.dart
    moduleRegistry.registerModules(oneApplication);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'EDNet One',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: _buildHome(),
      // Add routes for direct navigation
      routes: {
        ProjectManagementPage.routeName: (context) =>
            const ProjectManagementPage(),
      },
    );
  }

  Widget _buildHome() {
    // For testing purposes, return the ProjectManagementPage directly
    return const ProjectManagementPage();
  }
}
