import 'package:flutter/material.dart';

import 'responsive_layout.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget header;
  final Widget leftSidebar;
  final Widget rightSidebar;
  final Widget mainContent;
  final Widget footer;

  const LayoutTemplate({
    required this.header,
    required this.leftSidebar,
    required this.rightSidebar,
    required this.mainContent,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: header,
      ),
      body: ResponsiveLayout(
        largeScreen: Row(
          children: [
            Expanded(flex: 2, child: leftSidebar),
            Expanded(flex: 6, child: mainContent),
            Expanded(flex: 2, child: rightSidebar),
          ],
        ),
        smallScreen: Column(
          children: [
            leftSidebar,
            mainContent,
            rightSidebar,
          ],
        ),
      ),
      bottomNavigationBar: footer,
    );
  }
}
