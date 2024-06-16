import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class MainContentWidget extends StatelessWidget {
  final Entity? entity;

  const MainContentWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: entity != null
            ? Text('Displaying: ${entity?.code}')
            : Text('No entity selected'),
      ),
    );
  }
}
