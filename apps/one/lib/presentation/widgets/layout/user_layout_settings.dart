import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'semantic_pinning_service.dart';
import 'responsive_semantic_wrapper.dart';
import 'model_pin_manager_dialog.dart';

/// User settings for semantic layout customization
class UserLayoutSettings extends StatefulWidget {
  /// Current model code (if any)
  final String? modelCode;

  /// Constructor for UserLayoutSettings
  const UserLayoutSettings({super.key, this.modelCode});

  @override
  State<UserLayoutSettings> createState() => _UserLayoutSettingsState();
}

class _UserLayoutSettingsState extends State<UserLayoutSettings> {
  bool _editModeEnabled = false;
  bool _showPinControls = true;
  ScreenSizeCategory _simulatedScreenSize = ScreenSizeCategory.mobile;
  late SemanticPinningService _pinningService;
  int _pinnedItemCount = 0;

  @override
  void initState() {
    super.initState();
    _pinningService = SemanticPinningService();
    _loadSettings();

    if (widget.modelCode != null) {
      _loadPinCount();
    }
  }

  @override
  void didUpdateWidget(UserLayoutSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modelCode != widget.modelCode && widget.modelCode != null) {
      _loadPinCount();
    }
  }

  /// Load user layout settings
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _editModeEnabled = prefs.getBool('edit_mode_enabled') ?? false;
      _showPinControls = prefs.getBool('show_pin_controls') ?? true;
      _simulatedScreenSize =
          ScreenSizeCategory.values[prefs.getInt('simulated_screen_size') ?? 0];
    });
  }

  /// Load pin count for current model
  Future<void> _loadPinCount() async {
    await _pinningService.initialize();

    if (widget.modelCode != null) {
      final pinnedItems = _pinningService.getPinnedArtifactsForModel(
        widget.modelCode!,
      );

      setState(() {
        _pinnedItemCount = pinnedItems.length;
      });
    }
  }

  /// Save user layout settings
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('edit_mode_enabled', _editModeEnabled);
    await prefs.setBool('show_pin_controls', _showPinControls);
    await prefs.setInt('simulated_screen_size', _simulatedScreenSize.index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      tooltip: 'Layout Settings',
      icon: Badge(
        isLabelVisible: _pinnedItemCount > 0,
        label: Text(_pinnedItemCount.toString()),
        child: const Icon(Icons.view_quilt),
      ),
      itemBuilder:
          (context) => [
            // Title
            PopupMenuItem<String>(
              enabled: false,
              child: Text(
                'Layout Settings',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const PopupMenuDivider(),

            // Edit mode toggle
            PopupMenuItem<String>(
              value: 'edit_mode',
              child: StatefulBuilder(
                builder:
                    (context, setState) => SwitchListTile.adaptive(
                      title: const Text('Edit Mode'),
                      subtitle: const Text('Enable users to customize layout'),
                      value: _editModeEnabled,
                      onChanged: (value) {
                        setState(() => _editModeEnabled = value);
                        this.setState(() {});
                        _saveSettings();
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
              ),
            ),

            // Show pin controls
            if (_editModeEnabled)
              PopupMenuItem<String>(
                value: 'show_pins',
                child: StatefulBuilder(
                  builder:
                      (context, setState) => SwitchListTile.adaptive(
                        title: const Text('Show Pin Controls'),
                        subtitle: const Text(
                          'Show pin/unpin buttons on elements',
                        ),
                        value: _showPinControls,
                        onChanged: (value) {
                          setState(() => _showPinControls = value);
                          this.setState(() {});
                          _saveSettings();
                        },
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                ),
              ),

            // Simulated screen size
            PopupMenuItem<String>(
              value: 'screen_size',
              child: StatefulBuilder(
                builder:
                    (context, setState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Simulated Screen Size'),
                        const SizedBox(height: 4),
                        DropdownButton<ScreenSizeCategory>(
                          value: _simulatedScreenSize,
                          isExpanded: true,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _simulatedScreenSize = value);
                              this.setState(() {});
                              _saveSettings();
                            }
                          },
                          items:
                              ScreenSizeCategory.values.map((size) {
                                return DropdownMenuItem<ScreenSizeCategory>(
                                  value: size,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getIconForScreenSize(size),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(_getScreenSizeName(size)),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
              ),
            ),

            // Pin management
            if (widget.modelCode != null)
              PopupMenuItem<String>(
                value: 'manage_pins',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.push_pin_outlined),
                  title: const Text('Manage Pinned Items'),
                  subtitle:
                      _pinnedItemCount > 0
                          ? Text('$_pinnedItemCount items pinned')
                          : const Text('No pinned items'),
                  dense: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showPinManager(context);
                  },
                ),
              ),

            const PopupMenuDivider(),

            // Help
            PopupMenuItem<String>(
              value: 'help',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.help_outline),
                title: const Text('Layout Customization Help'),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  _showLayoutHelp(context);
                },
              ),
            ),
          ],
    );
  }

  /// Show the pin manager dialog
  void _showPinManager(BuildContext context) {
    if (widget.modelCode != null) {
      ModelPinManagerDialog.show(
        context,
        widget.modelCode!,
        title: 'Customize Layout',
      ).then((_) {
        _loadPinCount();
      });
    }
  }

  /// Show help dialog for layout customization
  void _showLayoutHelp(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Layout Customization'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Customize how content appears on different screen sizes',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),

                  Text('How to Use:', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),

                  const ListTile(
                    leading: Icon(Icons.push_pin_outlined),
                    title: Text('Pin Items'),
                    subtitle: Text(
                      'Items with pin icons can be pinned to stay visible on all screens',
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),

                  const ListTile(
                    leading: Icon(Icons.devices),
                    title: Text('Test Different Screens'),
                    subtitle: Text(
                      'Use the screen size simulator to see how content displays on different devices',
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),

                  const ListTile(
                    leading: Icon(Icons.restore),
                    title: Text('Reset Customizations'),
                    subtitle: Text(
                      'Use the pin manager to clear custom settings',
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  /// Get icon for screen size category
  IconData _getIconForScreenSize(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return Icons.smartphone;
      case ScreenSizeCategory.tablet:
        return Icons.tablet;
      case ScreenSizeCategory.desktop:
        return Icons.desktop_windows;
      case ScreenSizeCategory.largeDesktop:
        return Icons.desktop_mac;
      case ScreenSizeCategory.ultraWide:
        return Icons.tv;
    }
  }

  /// Get name for screen size category
  String _getScreenSizeName(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return 'Mobile';
      case ScreenSizeCategory.tablet:
        return 'Tablet';
      case ScreenSizeCategory.desktop:
        return 'Desktop';
      case ScreenSizeCategory.largeDesktop:
        return 'Large Screen';
      case ScreenSizeCategory.ultraWide:
        return 'Ultra Wide';
    }
  }
}
