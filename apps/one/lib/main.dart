import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'generated/one_application.dart';
import 'presentation/blocs/domain_block.dart';
import 'presentation/blocs/domain_event.dart';
import 'presentation/blocs/layout_block.dart';
import 'presentation/blocs/theme_block.dart';
import 'presentation/screens/home_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => LayoutBloc()),
        BlocProvider(
            create: (_) => DomainBloc(app: OneApplication())
              ..add(InitializeDomainEvent())),
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
      home: HomePage(title: 'One Home', appLinks: appLinks),
    );
  }
}
