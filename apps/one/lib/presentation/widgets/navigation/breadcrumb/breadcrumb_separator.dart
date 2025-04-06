import 'package:flutter/material.dart';

/// A visual separator between breadcrumb items
class BreadcrumbSeparator extends StatelessWidget {
  /// Custom icon to use as separator
  final IconData? icon;

  /// Custom color for the separator
  final Color? color;

  /// Custom size for the separator
  final double size;

  /// Constructor for BreadcrumbSeparator
  const BreadcrumbSeparator({
    super.key,
    this.icon = Icons.chevron_right,
    this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Icon(
        icon,
        size: size,
        color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
