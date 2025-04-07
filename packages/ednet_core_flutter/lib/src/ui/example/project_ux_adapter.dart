import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../ednet_core_flutter.dart';

/// An example Project entity class
///
/// This would typically come from your domain model
class ProjectEntity extends Entity<ProjectEntity> {
  // For demonstration purposes
  ProjectEntity(
      {required String id,
      required String name,
      String? description,
      DateTime? dueDate,
      bool? isCompleted})
      : super() {
    setAttribute('name', name);
    if (description != null) setAttribute('description', description);
    if (dueDate != null) setAttribute('dueDate', dueDate);
    if (isCompleted != null) setAttribute('isCompleted', isCompleted);
  }

  // Convenience getters for attributes
  String get name => getAttribute<String>('name') ?? '';
  String get description => getAttribute<String>('description') ?? '';
  DateTime? get dueDate => getAttribute<DateTime>('dueDate');
  bool get isCompleted => getAttribute<bool>('isCompleted') ?? false;

  // Override code for display purposes
  @override
  String get code => name;
}

/// Custom adapter for Project entities with specialized UI rendering
class ProjectUXAdapter extends ProgressiveUXAdapter<ProjectEntity> {
  /// Color scheme for project status
  final Map<String, Color> _statusColors = {
    'completed': Colors.green,
    'inProgress': Colors.blue,
    'overdue': Colors.red
  };

  /// Constructor
  ProjectUXAdapter(ProjectEntity entity) : super(entity);

  /// Get project status based on completion and due date
  String _getProjectStatus() {
    if (entity.isCompleted) return 'completed';
    if (entity.dueDate != null && entity.dueDate!.isBefore(DateTime.now())) {
      return 'overdue';
    }
    return 'inProgress';
  }

  /// Get color based on project status
  Color _getStatusColor() {
    return _statusColors[_getProjectStatus()] ?? Colors.grey;
  }

  @override
  Widget buildListItem(BuildContext context,
      {DisclosureLevel disclosureLevel = DisclosureLevel.minimal}) {
    final status = _getProjectStatus();
    final statusColor = _getStatusColor();

    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: statusColor,
                child: Icon(
                    status == 'completed' ? Icons.check : Icons.schedule,
                    color: Colors.white)),
            title: Text(entity.name),
            subtitle: disclosureLevel.isAtLeast(DisclosureLevel.basic)
                ? Text(entity.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis)
                : null,
            trailing: disclosureLevel.isAtLeast(DisclosureLevel.intermediate)
                ? entity.dueDate != null
                    ? Chip(
                        label: Text(
                            '${entity.dueDate!.day}/${entity.dueDate!.month}',
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor: statusColor.withValues(alpha: 0.2))
                    : null
                : null));
  }

  @override
  Widget buildForm(BuildContext context,
      {DisclosureLevel disclosureLevel = DisclosureLevel.basic}) {
    // Get field descriptors with our custom fields
    final fields = getFieldDescriptors(disclosureLevel: disclosureLevel);

    // Use default form builder with our custom fields
    return DefaultFormBuilder<ProjectEntity>(
        entity: entity,
        fields: fields,
        initialData: getInitialFormData(),
        disclosureLevel: disclosureLevel,
        onLevelChanged: (newLevel) {
          // Return a new form with the new disclosure level
          return buildForm(context, disclosureLevel: newLevel);
        },
        onSubmit: submitForm);
  }

  @override
  Widget buildDetailView(BuildContext context,
      {DisclosureLevel disclosureLevel = DisclosureLevel.intermediate}) {
    final status = _getProjectStatus();
    final statusColor = _getStatusColor();

    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with name and status
          Row(children: [
            Expanded(
                child: Text(entity.name,
                    style: Theme.of(context).textTheme.headlineSmall)),
            Chip(
                label: Text(status.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: statusColor)
          ]),

          const SizedBox(height: 16.0),

          // Description
          if (entity.description.isNotEmpty) ...[
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(entity.description))
          ],

          // Due date
          if (entity.dueDate != null) ...[
            Text('Due Date', style: Theme.of(context).textTheme.titleMedium),
            Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Row(children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8.0),
                  Text(
                      '${entity.dueDate!.day}/${entity.dueDate!.month}/${entity.dueDate!.year}',
                      style: TextStyle(
                          color: status == 'overdue' ? Colors.red : null,
                          fontWeight:
                              status == 'overdue' ? FontWeight.bold : null))
                ]))
          ],

          // Show more actions with higher disclosure levels
          if (disclosureLevel.isAtLeast(DisclosureLevel.advanced)) ...[
            const Divider(),
            Text('Actions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8.0),
            Wrap(spacing: 8.0, children: [
              ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  onPressed: () {
                    // Show edit form
                  }),
              ElevatedButton.icon(
                  icon: Icon(entity.isCompleted ? Icons.refresh : Icons.check),
                  label: Text(entity.isCompleted ? 'Reopen' : 'Complete'),
                  onPressed: () {
                    // Toggle completion status
                  }),
              if (disclosureLevel.isAtLeast(DisclosureLevel.complete))
                ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      // Delete project
                    })
            ])
          ],

          // Disclosure control for progressive disclosure
          const SizedBox(height: 16.0),
          buildDisclosureControl(context, disclosureLevel,
              (newLevel) => buildDetailView(context, disclosureLevel: newLevel))
        ]));
  }

  @override
  Widget buildVisualization(BuildContext context,
      {DisclosureLevel disclosureLevel = DisclosureLevel.intermediate}) {
    final status = _getProjectStatus();
    final statusColor = _getStatusColor();

    return Card(
        elevation: 3,
        color: statusColor.withValues(alpha: 0.05),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Project name with status indicator
              Row(children: [
                Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: statusColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(entity.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)))
              ]),

              if (disclosureLevel.isAtLeast(DisclosureLevel.intermediate)) ...[
                const SizedBox(height: 8),
                if (entity.description.isNotEmpty)
                  Text(entity.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                if (entity.dueDate != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                        '${entity.dueDate!.day}/${entity.dueDate!.month}/${entity.dueDate!.year}',
                        style: TextStyle(
                            fontSize: 12,
                            color: status == 'overdue' ? Colors.red : null))
                  ])
                ]
              ]
            ])));
  }

  @override
  List<UXFieldDescriptor> getFieldDescriptors(
      {DisclosureLevel disclosureLevel = DisclosureLevel.basic}) {
    // Define all possible fields
    final allFields = [
      // Name field - always visible (basic)
      UXFieldDescriptor(
          fieldName: 'name',
          displayName: 'Project Name',
          fieldType: UXFieldType.text,
          required: true,
          validators: [
            (value) => value == null || (value as String).isEmpty
                ? 'Name is required'
                : null,
            (value) => value != null && (value as String).length < 3
                ? 'Name must be at least 3 characters'
                : null
          ]).withDisclosureLevel(DisclosureLevel.basic),

      // Description field - visible at basic level
      const UXFieldDescriptor(
              fieldName: 'description',
              displayName: 'Description',
              fieldType: UXFieldType.longText,
              required: false)
          .withDisclosureLevel(DisclosureLevel.basic)
          .withHint('Enter a detailed description of the project'),

      // Due date - visible at intermediate level
      const UXFieldDescriptor(
              fieldName: 'dueDate',
              displayName: 'Due Date',
              fieldType: UXFieldType.date,
              required: false)
          .withDisclosureLevel(DisclosureLevel.intermediate),

      // Completion status - visible at intermediate level
      const UXFieldDescriptor(
              fieldName: 'isCompleted',
              displayName: 'Mark as Completed',
              fieldType: UXFieldType.checkbox,
              required: false)
          .withDisclosureLevel(DisclosureLevel.intermediate)

      // More technical fields could be added at advanced/complete levels
    ];

    // Filter fields based on disclosure level
    return filterFieldsByDisclosure(allFields, disclosureLevel);
  }

  @override
  Map<String, dynamic> getInitialFormData() {
    // Get initial form data from entity attributes
    return {
      'name': entity.name,
      'description': entity.description,
      'dueDate': entity.dueDate,
      'isCompleted': entity.isCompleted
    };
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    try {
      // Update entity attributes from form data
      formData.forEach((key, value) {
        entity.setAttribute(key, value);
      });

      // In a real application, you would persist the entity here
      // For example: await projectRepository.update(entity);

      return true;
    } catch (e) {
      print('Error submitting form: $e');
      return false;
    }
  }
}

/// Factory for creating ProjectUXAdapter instances
class ProjectUXAdapterFactory implements UXAdapterFactory<ProjectEntity> {
  @override
  UXAdapter create(ProjectEntity entity) {
    return ProjectUXAdapter(entity);
  }
}

/// Example of how to register and use the custom adapter
void registerProjectUXAdapter() {
  // Register the adapter with the global registry
  UXAdapterRegistry().register<ProjectEntity>(ProjectUXAdapterFactory());

  // Now any ProjectEntity will automatically use this custom adapter
  // when using the entity.buildForm(), entity.buildListItem(), etc. methods
}

/// Example usage in a Flutter widget
class ProjectListItem extends StatelessWidget {
  final ProjectEntity project;
  final DisclosureLevel disclosureLevel;

  const ProjectListItem(
      {Key? key,
      required this.project,
      this.disclosureLevel = DisclosureLevel.basic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This will use the custom ProjectUXAdapter if registered,
    // otherwise falls back to the default adapter
    return project.buildListItem(context, disclosureLevel: disclosureLevel);
  }
}
