import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../widgets/layout/web/header_widget.dart';

/// Domain listing page for the application
///
/// This page displays all available domains in the application and
/// allows navigation to specific domain details.
class DomainsPage extends StatelessWidget {
  /// Route name for this page
  static const String routeName = '/domains';

  /// The domains to display
  final Domains domains;

  /// Callback for when a domain is selected
  final void Function(Domain domain)? onDomainSelected;

  /// Creates a domains page
  const DomainsPage({super.key, required this.domains, this.onDomainSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: const ['Home', 'Domains'],
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          },
          filters: [],
          onAddFilter: (header.FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: DomainsListWidget(
        domains: domains,
        onDomainSelected: onDomainSelected,
      ),
    );
  }
}

/// Widget for displaying a list of domains
///
/// This widget renders a list of domains with consistent styling and
/// handles domain selection.
class DomainsListWidget extends StatelessWidget {
  /// The domains to display
  final Domains domains;

  /// Callback for when a domain is selected
  final void Function(Domain domain)? onDomainSelected;

  /// Creates a domains list widget
  const DomainsListWidget({
    super.key,
    required this.domains,
    this.onDomainSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return domains.isEmpty
        ? const Center(child: Text('No domains available'))
        : ListView.builder(
          itemCount: domains.length,
          itemBuilder: (context, index) {
            var domain = domains.elementAt(index);
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              elevation: 2,
              child: ListTile(
                title: Text(domain.code, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  '${domain.models.length} models',
                  style: theme.textTheme.bodySmall,
                ),
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Text(domain.code.substring(0, 1).toUpperCase()),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.primary,
                ),
                onTap: () {
                  if (onDomainSelected != null) {
                    onDomainSelected!(domain);
                  }
                },
              ),
            );
          },
        );
  }
}
