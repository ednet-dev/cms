import 'package:flutter/material.dart';
import '../widgets/layout/responsive_semantic_wrapper.dart';

/// A tutorial page explaining how to customize the layout
class LayoutCustomizationTutorial extends StatefulWidget {
  /// Constructor for LayoutCustomizationTutorial
  const LayoutCustomizationTutorial({super.key});

  /// Route name for navigation
  static const String routeName = '/layout-tutorial';

  @override
  State<LayoutCustomizationTutorial> createState() =>
      _LayoutCustomizationTutorialState();
}

class _LayoutCustomizationTutorialState
    extends State<LayoutCustomizationTutorial> {
  // Current step in the tutorial
  int _currentStep = 0;

  // The list of tutorial steps
  final List<_TutorialStep> _steps = [
    _TutorialStep(
      title: 'Welcome to Layout Customization',
      description:
          'Learn how to personalize your interface by pinning important elements and adapting to different screen sizes.',
      icon: Icons.view_quilt,
    ),
    _TutorialStep(
      title: 'Understanding Semantic Priorities',
      description:
          'Elements in the app have different priorities. Critical information is always shown, while less important details appear only on larger screens.',
      icon: Icons.priority_high,
    ),
    _TutorialStep(
      title: 'Pinning Important Elements',
      description:
          'Click the pin icon on any element to make it stay visible regardless of screen size. Pinned items will always show up, even on smaller screens.',
      icon: Icons.push_pin,
    ),
    _TutorialStep(
      title: 'Managing Your Pins',
      description:
          'Use the layout settings button in the app bar to view and manage all your pinned items in one place.',
      icon: Icons.settings,
    ),
    _TutorialStep(
      title: 'Testing Different Screen Sizes',
      description:
          'Use the screen size simulator to preview how your layout will look on different devices without changing your actual device.',
      icon: Icons.devices,
    ),
    _TutorialStep(
      title: 'Sharing Your Layout',
      description:
          'Your customizations are saved automatically and will persist across app restarts, providing a consistent experience.',
      icon: Icons.save,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Customization Tutorial'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Tutorial content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Step icon
                  Icon(
                    _steps[_currentStep].icon,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 32),

                  // Step title
                  Text(
                    _steps[_currentStep].title,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Step description
                  Text(
                    _steps[_currentStep].description,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Example visual
                  _buildExample(context),
                ],
              ),
            ),
          ),

          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                TextButton.icon(
                  onPressed:
                      _currentStep > 0
                          ? () => setState(() => _currentStep--)
                          : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),

                // Counter text
                Text(
                  '${_currentStep + 1} of ${_steps.length}',
                  style: theme.textTheme.bodyMedium,
                ),

                // Next/Done button
                TextButton.icon(
                  onPressed:
                      _currentStep < _steps.length - 1
                          ? () => setState(() => _currentStep++)
                          : () => Navigator.of(context).pop(),
                  icon:
                      _currentStep < _steps.length - 1
                          ? const Icon(Icons.arrow_forward)
                          : const Icon(Icons.check),
                  label: Text(
                    _currentStep < _steps.length - 1 ? 'Next' : 'Done',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build an example visual for the current step
  Widget _buildExample(BuildContext context) {
    final theme = Theme.of(context);
    final screenCategory = ResponsiveSemanticWrapper.getScreenCategory(context);

    // Different examples for different steps
    switch (_currentStep) {
      case 0:
        // Welcome - show responsive layout demo
        return _buildResponsiveLayoutDemo(context);
      case 1:
        // Priorities - show priority levels
        return _buildPriorityLevelsDemo(context);
      case 2:
        // Pinning - show pin demo
        return _buildPinningDemo(context);
      case 3:
        // Managing pins - show pin manager
        return _buildPinManagerDemo(context);
      case 4:
        // Screen sizes - show screen size selector
        return _buildScreenSizeDemo(context);
      case 5:
        // Saving - show save demo
        return _buildSavingDemo(context);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Build a responsive layout demonstration
  Widget _buildResponsiveLayoutDemo(BuildContext context) {
    return Column(
      children: [
        Text(
          'Content adapts to screen size',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDevicePreview(context, 'Mobile', Icons.smartphone, [
              Icons.star,
              Icons.info,
            ]),
            _buildDevicePreview(context, 'Tablet', Icons.tablet, [
              Icons.star,
              Icons.info,
              Icons.description,
            ]),
            _buildDevicePreview(context, 'Desktop', Icons.desktop_windows, [
              Icons.star,
              Icons.info,
              Icons.description,
              Icons.insert_chart,
            ]),
          ],
        ),
      ],
    );
  }

  /// Build a device preview with content
  Widget _buildDevicePreview(
    BuildContext context,
    String name,
    IconData deviceIcon,
    List<IconData> contentIcons,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Device name
        Text(name, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),

        // Device frame
        Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Device icon
              Icon(deviceIcon, size: 24, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),

              // Content icons
              ...contentIcons.map(
                (icon) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Icon(icon, size: 16, color: colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a priority levels demonstration
  Widget _buildPriorityLevelsDemo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        for (final priority in SemanticPriority.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority, colorScheme),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getPriorityIcon(priority),
                    color:
                        _getPriorityColor(
                                  priority,
                                  colorScheme,
                                ).computeLuminance() >
                                0.5
                            ? Colors.black87
                            : Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPriorityName(priority),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                _getPriorityColor(
                                          priority,
                                          colorScheme,
                                        ).computeLuminance() >
                                        0.5
                                    ? Colors.black87
                                    : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getPriorityDescription(priority),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                _getPriorityColor(
                                          priority,
                                          colorScheme,
                                        ).computeLuminance() >
                                        0.5
                                    ? Colors.black87
                                    : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Build a pinning demonstration
  Widget _buildPinningDemo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header with pin
          Row(
            children: [
              Expanded(
                child: Text(
                  'Customer Details',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.push_pin, color: Colors.amber),
            ],
          ),
          const Divider(),

          // Card content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text('Name:', style: theme.textTheme.bodyMedium),
                const SizedBox(width: 8),
                Text('John Smith', style: theme.textTheme.bodyLarge),
              ],
            ),
          ),

          // Animation hint
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Tap the pin icon',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a pin manager demonstration
  Widget _buildPinManagerDemo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dialog header
          Text('Pinned Items', style: theme.textTheme.titleLarge),
          const Divider(),

          // Pinned items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.push_pin),
                title: Text('Pinned Item ${index + 1}'),
                trailing: const Icon(Icons.close, size: 16),
                dense: true,
              );
            },
          ),

          // Action buttons
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(onPressed: null, child: const Text('Clear All')),
              const SizedBox(width: 8),
              FilledButton(onPressed: null, child: const Text('Close')),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a screen size demonstration
  Widget _buildScreenSizeDemo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Simulated Screen Size', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),

          // Screen size options
          for (final category in ScreenSizeCategory.values)
            RadioListTile<ScreenSizeCategory>(
              title: Text(_getScreenSizeName(category)),
              subtitle: Text(_getScreenSizeDescription(category)),
              secondary: Icon(_getScreenSizeIcon(category)),
              value: category,
              groupValue: ScreenSizeCategory.tablet,
              onChanged: (value) {},
              dense: true,
            ),
        ],
      ),
    );
  }

  /// Build a saving demonstration
  Widget _buildSavingDemo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Savings icon
          Icon(Icons.cloud_done, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),

          Text(
            'Your preferences are automatically saved',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            'Your customizations will be available the next time you open the app',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Get color for priority level
  Color _getPriorityColor(SemanticPriority priority, ColorScheme colorScheme) {
    switch (priority) {
      case SemanticPriority.critical:
        return Colors.red;
      case SemanticPriority.important:
        return Colors.orange;
      case SemanticPriority.standard:
        return colorScheme.primary;
      case SemanticPriority.auxiliary:
        return Colors.teal;
      case SemanticPriority.supplementary:
        return Colors.blueGrey;
    }
  }

  /// Get icon for priority level
  IconData _getPriorityIcon(SemanticPriority priority) {
    switch (priority) {
      case SemanticPriority.critical:
        return Icons.priority_high;
      case SemanticPriority.important:
        return Icons.star;
      case SemanticPriority.standard:
        return Icons.check_circle;
      case SemanticPriority.auxiliary:
        return Icons.info;
      case SemanticPriority.supplementary:
        return Icons.more_horiz;
    }
  }

  /// Get name for priority level
  String _getPriorityName(SemanticPriority priority) {
    switch (priority) {
      case SemanticPriority.critical:
        return 'Critical';
      case SemanticPriority.important:
        return 'Important';
      case SemanticPriority.standard:
        return 'Standard';
      case SemanticPriority.auxiliary:
        return 'Auxiliary';
      case SemanticPriority.supplementary:
        return 'Supplementary';
    }
  }

  /// Get description for priority level
  String _getPriorityDescription(SemanticPriority priority) {
    switch (priority) {
      case SemanticPriority.critical:
        return 'Always visible on all screens';
      case SemanticPriority.important:
        return 'Visible on tablet and larger';
      case SemanticPriority.standard:
        return 'Visible on regular desktop';
      case SemanticPriority.auxiliary:
        return 'Visible on large screens';
      case SemanticPriority.supplementary:
        return 'Only on ultra-wide screens';
    }
  }

  /// Get name for screen size category
  String _getScreenSizeName(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return 'Mobile';
      case ScreenSizeCategory.tablet:
        return 'Tablet';
      case ScreenSizeCategory.desktop:
        return 'Desktop';
      case ScreenSizeCategory.largeDesktop:
        return 'Large Screen';
      case ScreenSizeCategory.ultraWide:
        return 'Ultra Wide';
    }
  }

  /// Get description for screen size category
  String _getScreenSizeDescription(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return 'Small phone screens (<600px)';
      case ScreenSizeCategory.tablet:
        return 'Tablets and small laptops (600-1024px)';
      case ScreenSizeCategory.desktop:
        return 'Standard desktop displays (1024-1920px)';
      case ScreenSizeCategory.largeDesktop:
        return 'Large monitors (1920-3840px)';
      case ScreenSizeCategory.ultraWide:
        return '4K displays and larger (>3840px)';
    }
  }

  /// Get icon for screen size category
  IconData _getScreenSizeIcon(ScreenSizeCategory category) {
    switch (category) {
      case ScreenSizeCategory.mobile:
        return Icons.smartphone;
      case ScreenSizeCategory.tablet:
        return Icons.tablet;
      case ScreenSizeCategory.desktop:
        return Icons.desktop_windows;
      case ScreenSizeCategory.largeDesktop:
        return Icons.desktop_mac;
      case ScreenSizeCategory.ultraWide:
        return Icons.tv;
    }
  }
}

/// Helper class for tutorial steps
class _TutorialStep {
  final String title;
  final String description;
  final IconData icon;

  const _TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
