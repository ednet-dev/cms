// main.dart
import 'package:ednet_one/presentation/household_management/blocs/layout_block.dart';
import 'package:ednet_one/presentation/household_management/blocs/theme_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/household_management/pages/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: const MyHomePage(title: 'EDNet One'),
          );
        },
      ),
    );
  }
}
