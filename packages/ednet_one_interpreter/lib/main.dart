import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one_interpreter/ednet_one_interpreter.dart';

import 'package:ednet_one_interpreter/presentation/blocs/domain_block.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_event.dart';
import 'package:ednet_one_interpreter/presentation/blocs/layout_block.dart';
import 'package:ednet_one_interpreter/presentation/blocs/theme_block.dart';
import 'package:ednet_one_interpreter/presentation/screens/home_page.dart';
import 'features/domain_visualization/domain_visualization_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => LayoutBloc()),
        BlocProvider(
          create:
              (_) => DomainBloc(app: ShellApp())..add(InitializeDomainEvent()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late AppLinks appLinks;

  @override
  void initState() {
    super.initState();
    appLinks = AppLinks();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeBloc>().state;
    return MaterialApp(
      title: 'EDNet One',
      theme: themeState.themeData,
      home: AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DomainVisualizationScreen(),
    const PlaceholderScreen(title: 'Interpreter'),
    const PlaceholderScreen(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Domain Model',
          ),
          NavigationDestination(icon: Icon(Icons.code), label: 'Interpreter'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

/// A simple placeholder screen for features not yet implemented
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64),
            const SizedBox(height: 16),
            Text(
              '$title Coming Soon',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('This feature is under development.'),
          ],
        ),
      ),
    );
  }
}
