import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Application entry point
void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize the application with the core functionality
  final domain = Domain('EDNetOne');
  domain.description = 'EDNet One - A unified platform for democratic systems';

  // Run the application with the shell app from ednet_core_flutter
  runApp(MaterialApp(
    title: 'EDNet One',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: ShellAppRunner(
      shellApp: ShellApp(domain: domain),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    ),
  ));
}
