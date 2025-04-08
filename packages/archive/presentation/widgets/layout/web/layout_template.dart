import 'package:flutter/material.dart';

import 'responsive_layout.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget? header;
  final Widget? leftSidebar;
  final Widget? rightSidebar;
  final Widget mainContent;
  final Widget? footer;

  const LayoutTemplate({
    super.key,
    this.header,
    this.leftSidebar,
    this.rightSidebar,
    required this.mainContent,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      largeScreen: _buildLargeScreenLayout(),
      smallScreen: _buildSmallScreenLayout(),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Column(
      children: [
        if (header != null) header!,
        Expanded(
          child: Row(
            children: [
              if (leftSidebar != null) Expanded(flex: 2, child: leftSidebar!),
              Expanded(flex: 6, child: mainContent),
              if (rightSidebar != null) Expanded(flex: 2, child: rightSidebar!),
            ],
          ),
        ),
        if (footer != null) footer!,
      ],
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      children: [
        if (header != null) header!,
        if (leftSidebar != null) leftSidebar!,
        Expanded(child: mainContent),
        if (rightSidebar != null) rightSidebar!,
        if (footer != null) footer!,
      ],
    );
  }
}
