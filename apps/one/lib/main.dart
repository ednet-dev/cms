import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/blocs/theme_block.dart';
import 'presentation/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  late StreamSubscription<Uri> _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        // Handle incoming link
        // Parse the URI and navigate to the appropriate screen
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'EDNet One',
            theme: themeState.themeData,
            home: HomePage(title: 'One Home', appLinks: _appLinks),
          );
        },
      ),
    );
  }
}
