import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => LayoutBloc(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          return LayoutTemplate(
            header: const HeaderWidget(),
            leftSidebar: const LeftSidebarWidget(),
            rightSidebar: const RightSidebarWidget(),
            mainContent: const MainContentWidget(),
            footer: const FooterWidget(),
          );
        },
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blue,
      child: const Center(
        child: Text('Header with Breadcrumbs'),
      ),
    );
  }
}

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

class MainContentWidget extends StatelessWidget {
  const MainContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: const Center(
        child: Text('Main Content Area'),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.purple,
      child: Center(
        child: Text('Footer - ${DateTime.now().toString()}'),
      ),
    );
  }
}

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(LayoutInitial()) {
    on<LayoutEvent>((event, emit) {
      // Handle layout events here
    });
  }
}

abstract class LayoutEvent {}

abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

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
