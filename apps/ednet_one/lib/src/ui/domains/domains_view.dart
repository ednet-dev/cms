import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/src/domain/project_management/project_management.dart';
import 'package:ednet_one/src/ui/domains/direct_democracy_details_view.dart';
import 'package:ednet_one/src/ui/domains/legislation_details_view.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'domain_page.dart';
import 'cms_graph_page_details_view.dart';
import 'project_management_details_view.dart';
import 'social_network_details_view.dart';

/// Displays a list of integrated domain models.
class DomainsView extends StatelessWidget {
  final Domains domains = createDomainModels();

  DomainsView({
    super.key,
    this.items = const [
      DomainPage(
          1, ProjectManagementDetailsView.routeName, 'Project management'),
      DomainPage(2, DirectDemocracyDetailsView.routeName, 'Democracy'),
      DomainPage(3, SocialNetworkDetailsView.routeName, 'Social network'),
      DomainPage(4, LegislationDetailsView.routeName, 'Legislation'),
      DomainPage(5, CmsGraphPageDetailsView.routeName, 'CMS graph'),
    ],
  });

  static const routeName = '/';

  final List<DomainPage> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domains'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'ednetDomainsListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.domain),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  item.routeName,
                );
              });
        },
      ),
    );
  }
}
