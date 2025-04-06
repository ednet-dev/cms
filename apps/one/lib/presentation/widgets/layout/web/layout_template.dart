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
        if (header != null) header!, // Remove _buildScrollableHeader
        Expanded(
          child: Row(
            children: [
              if (leftSidebar != null) Expanded(flex: 2, child: leftSidebar!),
              // Remove _buildScrollableSidebar
              Expanded(flex: 6, child: mainContent),
              // Remove _buildScrollableContent
              if (rightSidebar != null) Expanded(flex: 2, child: rightSidebar!),
              // Remove _buildScrollableSidebar
            ],
          ),
        ),
        if (footer != null) footer!, // Remove _buildScrollableFooter
      ],
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      children: [
        if (header != null) header!,
        // Remove _buildScrollableHeader
        if (leftSidebar != null) leftSidebar!,
        // Remove _buildScrollableSidebar
        Expanded(child: mainContent),
        // Remove _buildScrollableContent
        if (rightSidebar != null) rightSidebar!,
        // Remove _buildScrollableSidebar
        if (footer != null) footer!,
        // Remove _buildScrollableFooter
      ],
    );
  }

  Widget _buildScrollableHeader() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: header,
    );
  }

  Widget _buildScrollableFooter() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: footer,
    );
  }

  Widget _buildScrollableContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: double.infinity),
      child: mainContent,
    );
  }

  Widget _buildScrollableSidebar(Widget sidebar) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: double.infinity),
      child: sidebar,
    );
  }
}
