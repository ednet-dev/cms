import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import '../pages/domains_page.dart';

/// @deprecated Use DomainsPage or DomainsListWidget instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use DomainsPage or DomainsListWidget instead')
class DomainsWidget extends StatelessWidget {
  final Domains domains;
  final void Function(Domain domain)? onDomainSelected;

  const DomainsWidget({
    super.key,
    required this.domains,
    this.onDomainSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Delegate to the new implementation while maintaining the same interface
    return DomainsListWidget(
      domains: domains,
      onDomainSelected: onDomainSelected,
    );
  }
}
