part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// An example implementation of a breadcrumb visualizer using the breadcrumb service
///
/// This component demonstrates how to use the breadcrumb service
/// to create a complete breadcrumb navigation solution.
class ExampleBreadcrumb extends StatefulWidget {
  /// The breadcrumb service instance
  final BreadcrumbService? breadcrumbService;

  /// Custom styling for the breadcrumb
  final BreadcrumbStyle? style;

  /// Initial disclosure level
  final DisclosureLevel? disclosureLevel;

  /// Creates an example breadcrumb component
  const ExampleBreadcrumb({
    Key? key,
    this.breadcrumbService,
    this.style,
    this.disclosureLevel,
  }) : super(key: key);

  @override
  State<ExampleBreadcrumb> createState() => _ExampleBreadcrumbState();
}

class _ExampleBreadcrumbState extends State<ExampleBreadcrumb> {
  late final BreadcrumbService _service;
  List<BreadcrumbItem> _items = [];

  @override
  void initState() {
    super.initState();

    // Get the service instance (either provided or singleton)
    _service = widget.breadcrumbService ?? BreadcrumbService();

    // Initialize items from the service
    _items = _service.items;

    // Listen for updates
    _service.addListener(_onBreadcrumbsUpdated);
  }

  void _onBreadcrumbsUpdated(List<BreadcrumbItem> items) {
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  @override
  void dispose() {
    // Nothing to dispose since the service is shared
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If no items, show nothing
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Pass the items to the breadcrumb component
    return Breadcrumb(
      items: _items,
      onItemTap: _handleBreadcrumbTap,
      style: widget.style,
      disclosureLevel: widget.disclosureLevel,
    );
  }

  void _handleBreadcrumbTap(BreadcrumbItem item) {
    // Navigate using the service
    _service.navigateTo(item);
  }
}

/// Provides a demonstration of the breadcrumb component
///
/// This is a utility method to quickly demonstrate the breadcrumb
/// functionality with sample data.
Widget buildBreadcrumbDemo(BuildContext context,
    {DisclosureLevel? disclosureLevel}) {
  // Create a breadcrumb service for the demo
  final service = BreadcrumbService();

  // Add some sample breadcrumb items
  if (service.items.isEmpty) {
    service.resetToHome(
      const BreadcrumbItem(
        label: 'Home',
        destination: '/',
        icon: Icons.home,
      ),
    );

    service.add(
      const BreadcrumbItem(
        label: 'Domains',
        destination: '/domains',
        icon: Icons.cloud,
      ),
    );

    service.add(
      const BreadcrumbItem(
        label: 'User Management',
        destination: '/domains/user-management',
        icon: Icons.people,
      ),
    );

    service.add(
      const BreadcrumbItem(
        label: 'User Profiles',
        destination: '/domains/user-management/profiles',
        icon: Icons.person,
      ),
    );
  }

  // Wrap in a card for better presentation
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Navigation Breadcrumb',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ExampleBreadcrumb(
            breadcrumbService: service,
            disclosureLevel: disclosureLevel,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Home'),
                onPressed: () => service.navigateToIndex(0),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                onPressed: () => service.add(
                  BreadcrumbItem(
                    label: 'New Item ${service.items.length}',
                    destination: '/new-item-${service.items.length}',
                    icon: Icons.star,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                onPressed: () => service.clear(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
