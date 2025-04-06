import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/providers/theme_provider.dart';
import '../navigation/navigation_service.dart';
import 'app_module.dart';

/// The AppShell serves as the main container for the application,
/// providing a single consistent scaffold that hosts all micro-frontend modules.
class AppShell extends StatefulWidget {
  /// The title displayed in the app bar
  final String title;

  /// The list of registered modules
  final List<AppModule> modules;

  /// The initial module to display (defaults to first module)
  final String? initialModuleId;

  /// Navigation service for module navigation
  final NavigationService navigationService;

  const AppShell({
    super.key,
    required this.title,
    required this.modules,
    required this.navigationService,
    this.initialModuleId,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late String _currentModuleId;
  AppModule? _currentModule;

  @override
  void initState() {
    super.initState();
    _currentModuleId =
        widget.initialModuleId ??
        (widget.modules.isNotEmpty ? widget.modules.first.id : '');
    _updateCurrentModule();

    // Register the navigation handler with NavigationService
    widget.navigationService.setModuleNavigationHandler(_navigateToModule);
    widget.navigationService.updateCurrentModuleId(_currentModuleId);
  }

  void _updateCurrentModule() {
    try {
      _currentModule = widget.modules.firstWhere(
        (module) => module.id == _currentModuleId,
      );
    } catch (e) {
      // If module not found, use the first module if available
      if (widget.modules.isNotEmpty) {
        _currentModule = widget.modules.first;
        _currentModuleId = _currentModule!.id;
      } else {
        _currentModule = null;
      }
    }
  }

  void _navigateToModule(String moduleId) {
    setState(() {
      _currentModuleId = moduleId;
      _updateCurrentModule();
      widget.navigationService.updateCurrentModuleId(moduleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider for responsive breakpoints
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Domain Model Editor button
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: 'Domain Model Editor',
            onPressed: () {
              widget.navigationService.navigateToDomainModelEditor();
            },
          ),
          // Additional actions from the current module
          if (_currentModule != null)
            ..._currentModule!.buildAppBarActions(context),

          // Common app-wide actions
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle theme',
          ),
        ],
      ),

      drawer: isSmallScreen ? _buildNavigationDrawer() : null,

      body: Row(
        children: [
          // Navigation rail for larger screens
          if (!isSmallScreen) _buildNavigationRail(),

          // Content area - expanded to take available space
          Expanded(
            child:
                _currentModule != null
                    ? _currentModule!.buildModuleContent(context)
                    : const Center(child: Text('No module selected')),
          ),
        ],
      ),

      // Allow modules to add floating action buttons
      floatingActionButton: _currentModule?.buildFloatingActionButton(context),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: widget.modules.indexWhere((m) => m.id == _currentModuleId),
      onDestinationSelected: (int index) {
        if (index >= 0 && index < widget.modules.length) {
          _navigateToModule(widget.modules[index].id);
        }
      },
      labelType: NavigationRailLabelType.selected,
      destinations:
          widget.modules.map((module) {
            return NavigationRailDestination(
              icon: Icon(module.icon),
              label: Text(module.name),
            );
          }).toList(),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ...widget.modules.map((module) {
            return ListTile(
              leading: Icon(module.icon),
              title: Text(module.name),
              selected: _currentModuleId == module.id,
              onTap: () {
                _navigateToModule(module.id);
                Navigator.pop(context); // Close drawer
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
