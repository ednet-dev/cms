part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Interface for UI components that support progressive disclosure levels,
/// allowing the UI to adapt based on user expertise
mixin ProgressiveDisclosure {
  /// The current disclosure level for progressive UI
  DisclosureLevel get disclosureLevel;
}
