#!/usr/bin/env dart

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ednet_dev_tools/src/cli/commands/pr_create_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('ednet', 'EDNet development tools')
    ..addCommand(PrCreateCommand());

  try {
    await runner.run(arguments);
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
} 