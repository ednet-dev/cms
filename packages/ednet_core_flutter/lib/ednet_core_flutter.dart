/// The Flutter UI shell for EDNet Core domain modeling
library ednet_core_flutter;

import 'dart:async';
import 'dart:math' as math;
import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ednet_core/ednet_core.dart';
import 'package:yaml/yaml.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core components
part 'src/ui/disclosure_level.dart';
part 'src/ui/field_descriptor.dart';
part 'src/ui/layout_adapter.dart';

// UI adapters
part 'src/ui/ux_adapter.dart';
part 'src/ui/adapter_registry.dart';
part 'src/ui/progressive_disclosure.dart';

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
part 'src/shell/shell_app_domains.dart';
part 'src/shell/domain_navigator_multi.dart';
part 'src/shell/configuration_injector.dart';
part 'src/shell/navigation/shell_navigation_service.dart';

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
part 'src/ui/theme/components/minimalistic_theme_component.dart';
part 'src/ui/theme/components/custom_colors.dart';

// Theme strategies
part 'src/ui/theme/strategy/theme_strategy.dart';
part 'src/ui/theme/strategy/standard_theme_strategy.dart';

// Theme providers
part 'src/ui/theme/providers/theme_provider.dart';

// UI Components
part 'src/ui/components/list_item_card.dart';
part 'src/ui/components/card/domain_entity_card.dart';
part 'src/ui/components/list/domain_list_item.dart';
part 'src/ui/components/concept/semantic_concept_container.dart';

// Canvas interactions
part 'src/ui/components/canvas/interactions/pan_handler.dart';
part 'src/ui/components/canvas/interactions/zoom_handler.dart';
part 'src/ui/components/canvas/interactions/selection_handler.dart';

// Canvas layout
part 'src/ui/components/canvas/layout/layout_algorithm.dart';
part 'src/ui/components/canvas/layout/layout_algorithm_icon.dart';

// Canvas visualization
part 'src/domain/visualization/node.dart';
part 'src/domain/visualization/visualization_system.dart';
part 'src/ui/components/canvas/meta_domain_canvas.dart';
part 'src/ui/components/canvas/meta_domain_painter.dart';
part 'src/ui/components/canvas/decorators/ux_decorator.dart';
part 'src/ui/components/canvas/unified_visualization_canvas.dart';
part 'src/ui/components/canvas/painters/entity_painter.dart';
part 'src/ui/components/canvas/painters/relation_painter.dart';
part 'src/ui/components/canvas/painters/grid_painter.dart';
part 'src/ui/components/canvas/render_objects/canvas_entity.dart';
part 'src/ui/components/canvas/render_objects/canvas_relation.dart';

// Breadcrumb Components
part 'src/ui/components/breadcrumb/breadcrumb.dart';
part 'src/ui/components/breadcrumb/breadcrumb_service.dart';
part 'src/ui/components/breadcrumb/example_breadcrumb.dart';

// Theme extensions
part 'src/ui/theme/extensions/theme_extensions.dart';
part 'src/ui/theme/extensions/theme_spacing.dart';
part 'src/ui/theme/extensions/disclosure_level_theme_extension.dart';
part 'src/ui/theme/extensions/semantic_colors_extension.dart';

// Utility services
part 'src/ui/utils/platform_utils.dart';
part 'src/ui/utils/response_utils.dart';
part 'src/ui/utils/string_utils.dart';
part 'src/ui/utils/device_utils.dart';
part 'src/ui/utils/logger_utils.dart';

// Bookmark components
part 'src/ui/components/bookmarks/bookmark_model.dart';
part 'src/ui/components/bookmarks/bookmark_service.dart';
part 'src/ui/components/bookmarks/bookmark_item.dart';
part 'src/ui/components/bookmarks/bookmark_sidebar.dart';

// Filter components
part 'src/ui/components/filters/filter_model.dart';
part 'src/ui/components/filters/filter_service.dart';
part 'src/ui/components/filters/filter_button.dart';

// Layout components
part 'src/ui/components/layout/responsive_semantic_wrapper.dart';
part 'src/ui/components/layout/semantic_layout_requirements.dart';
part 'src/ui/components/layout/semantic_pinning_service.dart';

// Samples
part 'src/ui/components/samples/holy_trinity_sample.dart';
