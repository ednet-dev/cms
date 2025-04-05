import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

/// Widget displaying a list of domains
///
/// This widget renders a scrollable list of domains that can be selected.
/// Used in various places where domain selection is required.
class DomainsListWidget extends StatelessWidget {
  final Domains domains;
  final void Function(Domain domain)? onDomainSelected;

  const DomainsListWidget({
    super.key,
    required this.domains,
    this.onDomainSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: domains.length,
      itemBuilder: (context, index) {
        var domain = domains.elementAt(index);
        return ListTile(
          title: Text(domain.code),
          onTap: () {
            if (onDomainSelected != null) {
              onDomainSelected!(domain);
            }
          },
        );
      },
    );
  }
}
