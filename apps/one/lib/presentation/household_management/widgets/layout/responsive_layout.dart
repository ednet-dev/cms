import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget smallScreen;

  const ResponsiveLayout({
    Key? key,
    required this.largeScreen,
    this.mediumScreen,
    required this.smallScreen,
  }) : super(key: key);

  static int tabletBreakpoint = 768;
  static int desktopBreakpoint = 1440;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint &&
        MediaQuery.of(context).size.width < desktopBreakpoint;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) {
          return largeScreen;
        } else if (constraints.maxWidth >= tabletBreakpoint) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen;
        }
      },
    );
  }
}
