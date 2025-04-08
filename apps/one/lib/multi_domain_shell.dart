import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'package:ednet_one/generated/one_application.dart';

/// A ShellApp extension that supports multiple domains from OneApplication
class MultiDomainShellApp extends StatefulWidget {
  /// The OneApplication instance containing multiple domains
  final OneApplication oneApplication;

  /// Default shell configuration
  final ShellConfiguration? configuration;

  const MultiDomainShellApp({
    Key? key,
    required this.oneApplication,
    this.configuration,
  }) : super(key: key);

  @override
  State<MultiDomainShellApp> createState() => _MultiDomainShellAppState();
}

class _MultiDomainShellAppState extends State<MultiDomainShellApp> {
  // Currently selected domain index
  int _selectedDomainIndex = 0;
  // Global navigator key
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // Scaffold key for drawer control
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDNet One Multi-Domain Shell',
      navigatorKey: _navigatorKey,
      theme: widget.configuration?.theme ??
          ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
      home: _buildMultiDomainNavigator(),
    );
  }

  Widget _buildMultiDomainNavigator() {
    final domains = widget.oneApplication.groupedDomains.toList();

    if (domains.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No domains available'),
        ),
      );
    }

    final currentDomain = domains[_selectedDomainIndex];

    // Create a ShellApp instance for the current domain
    final currentShell = ShellApp(
      domain: currentDomain,
      configuration: widget.configuration,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('EDNet One: ${currentDomain.code}'),
        actions: [
          // Domain switcher
          PopupMenuButton<int>(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch Domain',
            onSelected: (index) {
              setState(() {
                _selectedDomainIndex = index;
              });
            },
            itemBuilder: (context) {
              return List.generate(domains.length, (index) {
                final domain = domains[index];
                return PopupMenuItem(
                  value: index,
                  child: Text(domain.code),
                );
              });
            },
          ),
        ],
      ),
      body: DomainNavigator(shellApp: currentShell),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EDNet One',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Domains: ${domains.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Domain sections
            ...List.generate(domains.length, (domainIndex) {
              final domain = domains[domainIndex];
              return ExpansionTile(
                title: Text(domain.code),
                initiallyExpanded: domainIndex == _selectedDomainIndex,
                leading: Icon(
                  Icons.domain,
                  color: domainIndex == _selectedDomainIndex
                      ? Theme.of(context).primaryColor
                      : null,
                ),
                children: domain.models.map((model) {
                  return ListTile(
                    title: Text(model.code),
                    leading: const Icon(Icons.model_training, size: 18),
                    onTap: () {
                      setState(() {
                        _selectedDomainIndex = domainIndex;
                      });

                      // Close drawer safely using the scaffold key
                      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                        _scaffoldKey.currentState?.closeDrawer();
                      }

                      // Need to rebuild to get a fresh ShellApp for the new domain
                      // before we can navigate to the model
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final newShell = ShellApp(
                          domain: domain,
                          configuration: widget.configuration,
                        );
                        newShell.navigateToModel(model);
                      });
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
