import 'package:flutter/material.dart';

class RightSidebarWidget extends StatelessWidget {
  const RightSidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.yellow,
      child: const Center(
        child: Text('Right Sidebar'),
      ),
    );
  }
}