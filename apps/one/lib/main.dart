import 'package:flutter/material.dart';

import 'presentation/di/bloc_providers.dart';
import 'presentation/di/service_locator.dart' as di;
import 'presentation/navigation/navigation_service.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.initServiceLocator();

  // Initialize theme service
  await di.sl<ThemeService>().init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the navigation service
    final NavigationService navigationService = di.sl<NavigationService>();

    // Get the theme service
    final ThemeService themeService = di.sl<ThemeService>();

    return AppBlocProviders.wrapWithProviders(
      MaterialApp(
        title: 'EDNet One',
        theme: themeService.lightTheme,
        darkTheme: themeService.darkTheme,
        themeMode: themeService.currentThemeMode,
        navigatorKey: navigationService.navigatorKey,
        home: HomePage(title: 'EDNet One'),
      ),
    );
  }
}
