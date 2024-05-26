import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class LeftSidebarWidget<E extends Entity<E>> extends StatelessWidget {
  final Entities<E> items;

  const LeftSidebarWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.green,
      child: Center(
        child: EntitiesWidget<E>(entities: this.items),
      ),
    );
  }
}
