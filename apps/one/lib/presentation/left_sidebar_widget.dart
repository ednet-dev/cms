import 'package:flutter/material.dart';

class LeftSidebarWidget extends StatelessWidget {
  const LeftSidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.green,
      child: const Center(
        child: Text('Left Sidebar'),
      ),
    );
  }
}
