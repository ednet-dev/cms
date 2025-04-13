import 'package:ednet_core/ednet_core.dart';

/// Types of navigation items in the domain hierarchy
enum NavigationItemType {
  domain,
  model,
  concept,
  relationship,
}

/// Represents a selected item in the domain navigation
class DomainNavigationItem {
  final NavigationItemType type;
  final String path;
  final String title;
  final Domain? domain;
  final Model? model;
  final Concept? concept;

  DomainNavigationItem({
    required this.type,
    required this.path,
    required this.title,
    this.domain,
    this.model,
    this.concept,
  });
}
