library ednet_core_flutter;

import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:yaml/yaml.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core components
part 'src/ui/disclosure_level.dart';
part 'src/ui/field_descriptor.dart';

// UI adapters
part 'src/ui/ux_adapter.dart';
part 'src/ui/adapter_registry.dart';

// Core interfaces
part 'src/ui/messages/message.dart';

// Factory classes
part 'src/ui/factory/entity_factory.dart';

// Messages
part 'src/ui/messages/ux_message.dart';
part 'src/ui/messages/ux_channel.dart';

// Extension methods
part 'src/ui/extensions/entity_ux_extension.dart';

// Shell components
part 'src/shell/shell_app.dart';
part 'src/shell/configuration_injector.dart';

// Default form builder
part 'src/ui/default_form_builder.dart';

// UX component filter
part 'src/ui/ux_component_filter.dart';

// Domain model visualizer
part 'src/ui/domain_model_visualizer.dart';

// Canonical model adapter
part 'src/ui/canonical_model_adapter.dart';

// UI module
part 'src/ui/ui_module.dart';

// Theme components
part 'src/ui/theme/theme_constants.dart';
part 'src/ui/theme/theme.dart';
part 'src/ui/theme/theme_service.dart';
part 'src/ui/theme/components/theme_component.dart';
part 'src/ui/theme/components/cheerful_theme_component.dart';
part 'src/ui/theme/components/cli_theme_component.dart';
part 'src/ui/theme/components/custom_colors.dart';

// Theme extensions
part 'src/ui/theme/extensions/theme_extensions.dart';
part 'src/ui/theme/extensions/theme_spacing.dart';
part 'src/ui/theme/extensions/disclosure_level_theme_extension.dart';
part 'src/ui/theme/extensions/semantic_colors_extension.dart';
