import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/pages/bookmarks_page.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_event.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_state.dart';
import 'package:ednet_one/presentation/theme/theme.dart';
import 'package:ednet_one/presentation/theme/theme_constants.dart';

/// Component for the application's main app bar with navigation and actions
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title for the app bar
  final String title;

  /// Optional callback for when the DSL button is pressed
  final VoidCallback? onShowDSL;

  /// Optional callback for when the canvas toggle button is pressed
  final VoidCallback? onToggleCanvas;

  /// Optional callback for when the code generation button is pressed
  final VoidCallback? onGenerateCode;

  /// Current state of the canvas toggle
  final bool isCanvasVisible;

  /// Whether to show the menu button
  final bool showMenuButton;

  /// Constructor for HomeAppBar
  const HomeAppBar({
    super.key,
    required this.title,
    this.onShowDSL,
    this.onToggleCanvas,
    this.onGenerateCode,
    this.isCanvasVisible = false,
    this.showMenuButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: showMenuButton,
      actions: [
        // Bookmarks button
        Tooltip(
          message: 'Bookmarks',
          child: IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () => _navigateToBookmarks(context),
          ),
        ),

        // Theme selector dropdown
        _ThemeDropdown(),

        // Show Domain Model DSL button
        if (onShowDSL != null)
          Tooltip(
            message: 'Show Domain Model DSL',
            child: IconButton(
              icon: const Icon(Icons.code),
              onPressed: onShowDSL,
            ),
          ),

        // Toggle Meta Canvas button
        if (onToggleCanvas != null)
          Tooltip(
            message: 'Toggle Meta Canvas',
            child: IconButton(
              icon: Icon(isCanvasVisible ? Icons.grid_off : Icons.view_quilt),
              onPressed: onToggleCanvas,
            ),
          ),

        // Theme toggle button
        Tooltip(
          message: 'Toggle Theme',
          child: IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _toggleTheme(context),
          ),
        ),

        // Generate & Download Code button
        if (onGenerateCode != null)
          Tooltip(
            message: 'Generate & Download Code',
            child: IconButton(
              icon: const Icon(Icons.download),
              onPressed: onGenerateCode,
            ),
          ),
      ],
    );
  }

  /// Navigate to the bookmarks page
  void _navigateToBookmarks(BuildContext context) {
    Navigator.of(context).pushNamed(BookmarksPage.routeName);
  }

  void _toggleTheme(BuildContext context) {
    context.read<ThemeBloc>().add(ToggleThemeEvent());
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Theme dropdown widget for selecting between different theme styles
class _ThemeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final brightness =
            themeState.isDarkMode ? ThemeModes.dark : ThemeModes.light;
        final currentThemeName = themeState.themeName;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<String>(
            value: currentThemeName,
            hint: const Text('Select Theme'),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.palette_outlined, size: 20),
            items:
                themes[brightness]!.keys.map((String themeName) {
                  return DropdownMenuItem<String>(
                    value: themeName,
                    child: Text(themeName),
                  );
                }).toList(),
            onChanged: (themeName) {
              if (themeName != null) {
                context.read<ThemeBloc>().add(ChangeThemeEvent(themeName));
              }
            },
          ),
        );
      },
    );
  }
}
