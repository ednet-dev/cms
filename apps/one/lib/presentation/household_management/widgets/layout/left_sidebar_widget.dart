// left_sidebar_widget.dart
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class LeftSidebarWidget extends StatelessWidget {
  final Domains domains;
  final void Function(Domain domain) onDomainSelected;

  LeftSidebarWidget({
    required this.domains,
    required this.onDomainSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: ListView(
        children: domains.map((domain) {
          return ListTile(
            title: Text(domain.code),
            onTap: () => onDomainSelected(domain),
          );
        }).toList(),
      ),
    );
  }
}
