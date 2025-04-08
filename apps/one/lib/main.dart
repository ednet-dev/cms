import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'package:ednet_one/enhanced_shell.dart';

/// Application entry point
void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize OneApplication
  final oneApplication = OneApplication();
  await oneApplication.initializeApplication();

  // Create a fully-featured shell with all capabilities enabled by default
  final shellApp = EnhancedShellFactory.createFullFeaturedShell(oneApplication);

  // Run the application with the enhanced shell runner
  runApp(EnhancedShellAppRunner(shellApp: shellApp));
}
