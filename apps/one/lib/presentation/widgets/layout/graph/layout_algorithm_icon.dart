import 'dart:ui';
import 'package:flutter/material.dart';

class LayoutAlgorithmIcon extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  LayoutAlgorithmIcon({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40.0),
          Text(name, style: TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}
