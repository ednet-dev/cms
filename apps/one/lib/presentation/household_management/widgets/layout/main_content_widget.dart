import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class MainContentWidget<E extends Entity<E>> extends StatelessWidget {
  final E entity;

  const MainContentWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: EntityWidget(
          entity: entity,
        ),
      ),
    );
  }
}
