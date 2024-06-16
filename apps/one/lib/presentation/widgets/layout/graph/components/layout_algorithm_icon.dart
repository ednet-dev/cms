import 'package:flutter/material.dart';

class LayoutAlgorithmIcon extends StatefulWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;
  final bool isActive;

  const LayoutAlgorithmIcon({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
    required this.isActive,
  });

  @override
  _LayoutAlgorithmIconState createState() => _LayoutAlgorithmIconState();
}

class _LayoutAlgorithmIconState extends State<LayoutAlgorithmIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Tooltip(
        message: widget.name,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding around the icon
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 17,
                    color: widget.isActive || _isHovering
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(height: 4.0), // Add spacing between icon and text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
