import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/theme/theme_components/custom_colors.dart';

/// Component for the application's main navigation drawer
class HomeDrawer extends StatefulWidget {
  /// Optional callback for when the settings option is pressed
  final VoidCallback? onSettings;

  /// Optional callback for when the docs option is pressed
  final VoidCallback? onDocs;

  /// Optional callback for when the about option is pressed
  final VoidCallback? onAbout;

  /// Optional callback for when the help option is pressed
  final VoidCallback? onHelp;

  /// Optional callback for when the drawer pin state changes
  final Function(bool isPinned)? onPinStateChanged;

  /// Whether the drawer should be permanently shown (pinned)
  final bool isPinned;

  /// Constructor for HomeDrawer
  const HomeDrawer({
    super.key,
    this.onSettings,
    this.onDocs,
    this.onAbout,
    this.onHelp,
    this.onPinStateChanged,
    this.isPinned = true,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  static const _domainSectionExpandedKey = 'domain_section_expanded';
  static const _drawerPinnedKey = 'drawer_pinned';

  bool _isDomainSectionExpanded = true;
  bool _isPinned = true;

  @override
  void initState() {
    super.initState();
    _isPinned = widget.isPinned;
    _loadPreferences();
  }

  @override
  void didUpdateWidget(HomeDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPinned != widget.isPinned) {
      _isPinned = widget.isPinned;
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDomainSectionExpanded =
          prefs.getBool(_domainSectionExpandedKey) ?? true; // Default expanded
      _isPinned = prefs.getBool(_drawerPinnedKey) ?? true; // Default to pinned
    });
  }

  Future<void> _saveExpandedState(bool isExpanded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_domainSectionExpandedKey, isExpanded);
    setState(() {
      _isDomainSectionExpanded = isExpanded;
    });
  }

  Future<void> _togglePinState() async {
    final newPinState = !_isPinned;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_drawerPinnedKey, newPinState);
    setState(() {
      _isPinned = newPinState;
    });

    if (widget.onPinStateChanged != null) {
      widget.onPinStateChanged!(newPinState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      elevation: _isPinned ? 0 : 16, // Reduced elevation when pinned
      child: SafeArea(
        child: Column(
          children: [
            // Header with logo, app info, and pin option
            _buildHeader(context),

            // Navigation options in a scrollable container
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Domains section
                    _DomainSection(
                      isExpanded: _isDomainSectionExpanded,
                      onExpansionChanged: _saveExpandedState,
                    ),

                    const Divider(),

                    // App options
                    ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: const Text('Dashboard'),
                      onTap: () {
                        if (!_isPinned) Navigator.pop(context);
                        // Navigate to dashboard
                      },
                    ),

                    if (widget.onSettings != null)
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          widget.onSettings!();
                        },
                      ),

                    if (widget.onDocs != null)
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('Documentation'),
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          widget.onDocs!();
                        },
                      ),

                    if (widget.onHelp != null)
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Help'),
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          widget.onHelp!();
                        },
                      ),

                    if (widget.onAbout != null)
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('About'),
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          widget.onAbout!();
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Footer with version info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'EDNet One v1.0.0',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: colorScheme.primary,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum size needed
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.onPrimary,
                radius: 25, // Smaller radius
                child: Icon(
                  Icons.code,
                  color: colorScheme.primary,
                  size: 25, // Smaller icon
                ),
              ),
              // Pin button
              IconButton(
                icon: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: colorScheme.onPrimary,
                ),
                tooltip: _isPinned ? 'Unpin drawer' : 'Pin drawer',
                onPressed: _togglePinState,
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced space
          Text(
            'EDNet One',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 20, // Smaller font
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2), // Reduced space
          Text(
            'Domain Modeling Platform',
            style: TextStyle(
              color: colorScheme.onPrimary.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section that displays the available domains as selectable options
class _DomainSection extends StatelessWidget {
  /// Whether this section is initially expanded
  final bool isExpanded;

  /// Callback when the expansion state changes
  final Function(bool) onExpansionChanged;

  const _DomainSection({
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, state) {
        return ExpansionTile(
          leading: Icon(Icons.domain, color: colorScheme.domainColor),
          title: Text(
            'Domains',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.domainColor,
            ),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          children: [
            if (state.allDomains.isEmpty)
              const ListTile(title: Text('No domains available'), dense: true)
            else
              for (var domain in state.allDomains)
                ListTile(
                  title: Text(domain.code),
                  dense: true,
                  selected: domain == state.selectedDomain,
                  selectedTileColor: colorScheme.selectedBackground,
                  leading:
                      domain == state.selectedDomain
                          ? Icon(
                            Icons.check_circle,
                            color: colorScheme.domainColor,
                            size: 18,
                          )
                          : Icon(
                            Icons.circle_outlined,
                            size: 18,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                  onTap: () {
                    // If not already selected, select the domain
                    if (domain != state.selectedDomain) {
                      // Dispatch the domain selection event
                      context.read<DomainSelectionBloc>().add(
                        SelectDomainEvent(domain),
                      );
                    }
                  },
                ),
          ],
        );
      },
    );
  }
}
