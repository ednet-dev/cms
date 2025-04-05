import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';

/// Component for the application's main navigation drawer
class HomeDrawer extends StatelessWidget {
  /// Optional callback for when the settings option is pressed
  final VoidCallback? onSettings;

  /// Optional callback for when the docs option is pressed
  final VoidCallback? onDocs;

  /// Optional callback for when the about option is pressed
  final VoidCallback? onAbout;

  /// Optional callback for when the help option is pressed
  final VoidCallback? onHelp;

  /// Constructor for HomeDrawer
  const HomeDrawer({
    super.key,
    this.onSettings,
    this.onDocs,
    this.onAbout,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with logo and app info
          _DrawerHeader(),

          // Navigation options
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Domains section
                _DomainSection(),

                const Divider(),

                // App options
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to dashboard
                  },
                ),

                if (onSettings != null)
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      onSettings!();
                    },
                  ),

                if (onDocs != null)
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Documentation'),
                    onTap: () {
                      Navigator.pop(context);
                      onDocs!();
                    },
                  ),

                if (onHelp != null)
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help'),
                    onTap: () {
                      Navigator.pop(context);
                      onHelp!();
                    },
                  ),

                if (onAbout != null)
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.pop(context);
                      onAbout!();
                    },
                  ),
              ],
            ),
          ),

          // Footer with version info
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'EDNet One v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header section for the drawer with the app logo and info
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            radius: 30,
            child: Icon(
              Icons.code,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'EDNet One',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Domain-Driven Design Platform',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 204),
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, state) {
        return ExpansionTile(
          leading: const Icon(Icons.domain),
          title: const Text('Domains'),
          initiallyExpanded: true,
          children: [
            if (state.allDomains.isEmpty)
              const ListTile(title: Text('No domains available'), dense: true)
            else
              for (var domain in state.allDomains)
                ListTile(
                  title: Text(domain.code),
                  dense: true,
                  selected: domain == state.selectedDomain,
                  selectedTileColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 77),
                  leading:
                      domain == state.selectedDomain
                          ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          )
                          : const Icon(Icons.circle_outlined, size: 18),
                  onTap: () {
                    // Close drawer
                    Navigator.pop(context);

                    // If not already selected, select the domain
                    if (domain != state.selectedDomain) {
                      // This would dispatch the domain selection event
                      // The actual implementation would come from the HomePage
                    }
                  },
                ),
          ],
        );
      },
    );
  }
}
