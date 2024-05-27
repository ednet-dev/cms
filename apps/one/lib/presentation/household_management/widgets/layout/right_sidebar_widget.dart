import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class RightSidebarWidget extends StatelessWidget {
  final Domains domains;
  final void Function(Domain domain)? onDomainSelected;
  final void Function(Model model)? onModelSelected;

  RightSidebarWidget({
    required this.domains,
    this.onDomainSelected,
    this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blueGrey[50],
      child: ListView(
        children: domains.map((domain) {
          return ExpansionTile(
            title: Text(domain.code),
            children: domain.models.map((model) {
              return ListTile(
                title: Text(model.code),
                onTap: () {
                  if (onModelSelected != null) {
                    onModelSelected!(model);
                  }
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
