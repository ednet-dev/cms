import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/theme/theme_components/custom_colors.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/pages/workspace/immersive_workspace_page.dart';
import 'package:ednet_one/presentation/pages/examples/entity_persistence_example_page.dart';

/// Component for the application's main navigation drawer
///
/// Follows the Holy Trinity architecture by using semantic concept containers
/// and applying theme styling based on navigation semantics.
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

  bool _isPinned = false;
  bool _isDomainSectionExpanded = true;
  final ScrollController _scrollController = ScrollController();

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    return SemanticConceptContainer(
      conceptType: 'Navigation',
      child: Drawer(
        elevation: _isPinned ? 0 : 16, // Reduced elevation when pinned
        backgroundColor: context.conceptColor('Navigation', role: 'background'),
        child: SafeArea(
          child: Column(
            children: [
              // Header with logo, app info, and pin option
              _buildHeader(context),

              // Navigation options in a scrollable container
              Expanded(
                child: SemanticConceptContainer(
                  conceptType: 'NavigationMenu',
                  scrollable: true,
                  scrollController: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      // Domains section
                      _DomainSection(
                        isExpanded: _isDomainSectionExpanded,
                        onExpansionChanged: _saveExpandedState,
                      ),

                      Divider(
                        color: context
                            .conceptColor('Navigation', role: 'divider')
                            .withValues(alpha: 255.0 * 0.3),
                      ),

                      // App options
                      _buildNavigationItem(
                        context,
                        icon: Icons.dashboard,
                        title: 'Dashboard',
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          // Navigate to dashboard
                        },
                      ),

                      // Add workspace link
                      _buildNavigationItem(
                        context,
                        icon: Icons.workspaces,
                        title: 'Immersive Workspace',
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            ImmersiveWorkspacePage.routeName,
                          );
                        },
                      ),

                      // Add Entity Persistence Example
                      _buildNavigationItem(
                        context,
                        icon: Icons.storage,
                        title: 'Entity Persistence',
                        onTap: () {
                          if (!_isPinned) Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            EntityPersistenceExamplePage.routeName,
                          );
                        },
                      ),

                      if (widget.onSettings != null)
                        _buildNavigationItem(
                          context,
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            if (!_isPinned) Navigator.pop(context);
                            widget.onSettings!();
                          },
                        ),

                      if (widget.onDocs != null)
                        _buildNavigationItem(
                          context,
                          icon: Icons.description,
                          title: 'Documentation',
                          onTap: () {
                            if (!_isPinned) Navigator.pop(context);
                            widget.onDocs!();
                          },
                        ),

                      if (widget.onHelp != null)
                        _buildNavigationItem(
                          context,
                          icon: Icons.help,
                          title: 'Help',
                          onTap: () {
                            if (!_isPinned) Navigator.pop(context);
                            widget.onHelp!();
                          },
                        ),

                      if (widget.onAbout != null)
                        _buildNavigationItem(
                          context,
                          icon: Icons.info,
                          title: 'About',
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
              SemanticConceptContainer(
                conceptType: 'NavigationFooter',
                child: Padding(
                  padding: EdgeInsets.all(context.spacingS),
                  child: Text(
                    'EDNet One v1.0.0',
                    style: context.conceptTextStyle(
                      'Navigation',
                      role: 'footer',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a navigation menu item with consistent styling
  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return SemanticConceptContainer(
      conceptType: 'NavigationItem',
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isSelected
                  ? context.conceptColor('NavigationItem', role: 'selectedIcon')
                  : context.conceptColor('NavigationItem', role: 'icon'),
          size: 20,
        ),
        title: Text(
          title,
          style: context.conceptTextStyle(
            'NavigationItem',
            role: isSelected ? 'selectedTitle' : 'title',
          ),
        ),
        selected: isSelected,
        selectedTileColor: context
            .conceptColor('NavigationItem', role: 'selectedBackground')
            .withValues(alpha: 255.0 * 0.2),
        onTap: onTap,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'NavigationHeader',
      child: Container(
        padding: EdgeInsets.all(context.spacingM),
        color: context.conceptColor('NavigationHeader', role: 'background'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: context.conceptColor(
                    'NavigationHeader',
                    role: 'logoBackground',
                  ),
                  radius: 25,
                  child: Icon(
                    Icons.code,
                    color: context.conceptColor(
                      'NavigationHeader',
                      role: 'logoForeground',
                    ),
                    size: 25,
                  ),
                ),
                // Pin button
                IconButton(
                  icon: Icon(
                    _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: context.conceptColor(
                      'NavigationHeader',
                      role: 'icon',
                    ),
                  ),
                  tooltip: _isPinned ? 'Unpin drawer' : 'Pin drawer',
                  onPressed: _togglePinState,
                ),
              ],
            ),
            SizedBox(height: context.spacingS),
            Text(
              'EDNet One',
              style: context.conceptTextStyle(
                'NavigationHeader',
                role: 'title',
              ),
            ),
            SizedBox(height: context.spacingXs / 2),
            Text(
              'Domain Modeling Platform',
              style: context.conceptTextStyle(
                'NavigationHeader',
                role: 'subtitle',
              ),
            ),
          ],
        ),
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
    return SemanticConceptContainer(
      conceptType: 'DomainSection',
      child: BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
        builder: (context, state) {
          return ExpansionTile(
            leading: Icon(
              Icons.domain,
              color: context.conceptColor('Domain', role: 'icon'),
            ),
            title: Text(
              'Domains',
              style: context.conceptTextStyle('DomainSection', role: 'title'),
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: onExpansionChanged,
            children: [
              if (state.availableDomains.isEmpty)
                ListTile(
                  title: Text(
                    'No domains available',
                    style: context.conceptTextStyle('Domain', role: 'empty'),
                  ),
                  dense: true,
                )
              else
                ...state.availableDomains.map(
                  (domain) => _buildDomainItem(context, domain, state),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Build a domain list item with consistent styling
  Widget _buildDomainItem(
    BuildContext context,
    dynamic domain,
    DomainSelectionState state,
  ) {
    final isSelected = domain == state.selectedDomain;

    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: ListTile(
        title: Text(
          domain.code,
          style: context.conceptTextStyle(
            'Domain',
            role: isSelected ? 'selected' : 'default',
          ),
        ),
        dense: true,
        selected: isSelected,
        selectedTileColor: context
            .conceptColor('Domain', role: 'selectedBackground')
            .withValues(alpha: 255.0 * 0.2),
        leading:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: context.conceptColor('Domain', role: 'selected'),
                  size: 18,
                )
                : Icon(
                  Icons.circle_outlined,
                  size: 18,
                  color: context
                      .conceptColor('Domain', role: 'icon')
                      .withValues(alpha: 255.0 * 0.6),
                ),
        onTap: () {
          // If not already selected, select the domain
          if (domain != state.selectedDomain) {
            // Use the centralized navigation helper
            NavigationHelper.navigateToDomain(context, domain);
          }
        },
      ),
    );
  }
}
