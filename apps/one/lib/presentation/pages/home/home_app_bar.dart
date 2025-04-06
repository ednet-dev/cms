import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/pages/bookmarks_page.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_event.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_state.dart';
import 'package:ednet_one/presentation/theme/theme.dart';
import 'package:ednet_one/presentation/theme/theme_constants.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/widgets/layout/user_layout_settings.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/pages/workspace/immersive_workspace_page.dart';

/// Component for the application's main app bar with navigation and actions
///
/// Follows the Holy Trinity architecture by using semantic concept containers
/// and applying theme styling based on app bar semantics.
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
    // Use LayoutBuilder to make responsive decisions
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we should use a compact layout
        final bool useCompactLayout = constraints.maxWidth < 800;

        return SemanticConceptContainer(
          conceptType: 'AppBar',
          child: AppBar(
            title: Text(
              title,
              style: context.conceptTextStyle('AppBar', role: 'title'),
            ),
            centerTitle: false,
            elevation: 0,
            backgroundColor: context.conceptColor('AppBar', role: 'background'),
            foregroundColor: context.conceptColor('AppBar', role: 'foreground'),
            automaticallyImplyLeading: showMenuButton,
            actions:
                useCompactLayout
                    ? _buildCompactActions(context)
                    : _buildFullActions(context),
          ),
        );
      },
    );
  }

  /// Build a reduced set of actions for compact layouts
  List<Widget> _buildCompactActions(BuildContext context) {
    return [
      // Bookmarks button
      Tooltip(
        message: 'Bookmarks',
        child: IconButton(
          icon: Icon(
            Icons.bookmarks,
            color: context.conceptColor('AppBar', role: 'iconPrimary'),
          ),
          onPressed: () => _navigateToBookmarks(context),
        ),
      ),

      // More menu for additional actions
      _buildOverflowMenu(context),
    ];
  }

  /// Build the full set of actions for wider layouts
  List<Widget> _buildFullActions(BuildContext context) {
    return [
      // Bookmarks button
      Tooltip(
        message: 'Bookmarks',
        child: IconButton(
          icon: Icon(
            Icons.bookmarks,
            color: context.conceptColor('AppBar', role: 'iconPrimary'),
          ),
          onPressed: () => _navigateToBookmarks(context),
        ),
      ),

      // User Layout Settings button
      BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
        builder:
            (context, state) =>
                UserLayoutSettings(modelCode: state.selectedModel?.code),
      ),

      // Theme selector dropdown
      _ThemeDropdown(),

      // Show Domain Model DSL button
      if (onShowDSL != null)
        Tooltip(
          message: 'Show Domain Model DSL',
          child: IconButton(
            icon: Icon(
              Icons.code,
              color: context.conceptColor('AppBar', role: 'iconSecondary'),
            ),
            onPressed: onShowDSL,
          ),
        ),

      // Toggle Meta Canvas button
      if (onToggleCanvas != null)
        Tooltip(
          message: 'Toggle Meta Canvas',
          child: IconButton(
            icon: Icon(
              isCanvasVisible ? Icons.grid_off : Icons.view_quilt,
              color: context.conceptColor('AppBar', role: 'iconSecondary'),
            ),
            onPressed: onToggleCanvas,
          ),
        ),

      // Theme toggle button
      Tooltip(
        message: 'Toggle Theme',
        child: IconButton(
          icon: Icon(
            Icons.brightness_6,
            color: context.conceptColor('AppBar', role: 'iconPrimary'),
          ),
          onPressed: () => _toggleTheme(context),
        ),
      ),

      // Generate & Download Code button
      if (onGenerateCode != null)
        Tooltip(
          message: 'Generate & Download Code',
          child: IconButton(
            icon: Icon(
              Icons.download,
              color: context.conceptColor('AppBar', role: 'iconSecondary'),
            ),
            onPressed: onGenerateCode,
          ),
        ),
    ];
  }

  /// Build overflow menu for compact layouts
  Widget _buildOverflowMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: context.conceptColor('AppBar', role: 'iconPrimary'),
      ),
      onSelected: (value) {
        switch (value) {
          case 'theme':
            _toggleTheme(context);
            break;
          case 'dsl':
            if (onShowDSL != null) onShowDSL!();
            break;
          case 'canvas':
            if (onToggleCanvas != null) onToggleCanvas!();
            break;
          case 'generate':
            if (onGenerateCode != null) onGenerateCode!();
            break;
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'theme',
              child: _buildPopupItem(
                context,
                Icons.brightness_6,
                'Toggle Theme',
              ),
            ),
            if (onShowDSL != null)
              PopupMenuItem(
                value: 'dsl',
                child: _buildPopupItem(
                  context,
                  Icons.code,
                  'Show Domain Model DSL',
                ),
              ),
            if (onToggleCanvas != null)
              PopupMenuItem(
                value: 'canvas',
                child: _buildPopupItem(
                  context,
                  isCanvasVisible ? Icons.grid_off : Icons.view_quilt,
                  'Toggle Meta Canvas',
                ),
              ),
            if (onGenerateCode != null)
              PopupMenuItem(
                value: 'generate',
                child: _buildPopupItem(
                  context,
                  Icons.download,
                  'Generate & Download Code',
                ),
              ),
          ],
    );
  }

  /// Helper method to build consistent popup menu items
  Widget _buildPopupItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: context.conceptColor('Menu', role: 'icon'), size: 20),
        SizedBox(width: context.spacingS),
        Text(text, style: context.conceptTextStyle('Menu', role: 'item')),
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

        return SemanticConceptContainer(
          conceptType: 'ThemeSelector',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacingXs),
            child: DropdownButton<String>(
              value: currentThemeName,
              hint: Text(
                'Select Theme',
                style: context.conceptTextStyle('ThemeSelector', role: 'hint'),
              ),
              underline: const SizedBox.shrink(),
              icon: Icon(
                Icons.palette_outlined,
                size: 20,
                color: context.conceptColor('ThemeSelector', role: 'icon'),
              ),
              items:
                  themes[brightness]!.keys.map((String themeName) {
                    return DropdownMenuItem<String>(
                      value: themeName,
                      child: Text(
                        themeName,
                        style: context.conceptTextStyle(
                          'ThemeSelector',
                          role: 'item',
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (themeName) {
                if (themeName != null) {
                  context.read<ThemeBloc>().add(ChangeThemeEvent(themeName));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
