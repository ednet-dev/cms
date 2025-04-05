import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/staging/one_application.dart';

/// A shell application for interpreting domain models.
///
/// This widget serves as the main entry point for interpreting and displaying
/// domain models defined in ednet_core. It provides a framework for rendering
/// and interacting with domain-specific UI components.
class EdnetOneInterpreterShell extends StatelessWidget {
  /// Creates a new instance of [EdnetOneInterpreterShell].
  const EdnetOneInterpreterShell({
    super.key,
    required this.domain,
    required this.model,
  });

  /// The domain model to interpret and display.
  final Domain domain;
  final Model model;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ednet One Interpreter',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    // TODO: Implement the home screen with domain model interpretation
    return const Scaffold(body: Center(child: Text('Ednet One Interpreter')));
  }
}

/// A shell application that implements IOneApplication interface,
/// wrapping the OneApplication implementation from the staging directory.
class ShellApp implements IOneApplication {
  final OneApplication _oneApplication = OneApplication();

  @override
  Domains get domains => _oneApplication.domains;

  @override
  Domains get groupedDomains => _oneApplication.groupedDomains;

  @override
  DomainModels getDomainModels(String domain, String model) =>
      _oneApplication.getDomainModels(domain, model);
}
