// import 'package:flutter/material.dart';
// import 'package:ednet_core/ednet_core.dart';

// /// Example client application demonstrating the EDNet Shell architecture
// /// with UX customization and progressive disclosure.
// ///
// /// This example shows how to:
// /// 1. Initialize the EDNet Shell with a domain model
// /// 2. Configure UX customization points
// /// 3. Implement custom UI adapters for domain entities
// /// 4. Apply progressive disclosure based on user roles
// /// 5. Use Enterprise Integration Patterns for UI workflows
// ///
// /// The EDNet architecture follows the Domain-Driven Design principle of maintaining
// /// separation between domain models and presentation, while providing a flexible
// /// framework for client customization.
// void main() async {
//   // Initialize Flutter
//   WidgetsFlutterBinding.ensureInitialized();

//   // Generate or load the domain model
//   final domain = await loadDomainModel();

//   // Create shell configuration
//   final config = ShellConfiguration(
//     defaultDisclosureLevel: DisclosureLevel.basic,
//     features: {'filtering', 'export', 'visualization'},
//     theme: _createCustomTheme(),
//   );

//   // Initialize the shell
//   final shell = ShellApp(domain: domain, configuration: config);

//   // Register custom adapters
//   _registerCustomAdapters(shell);

//   // Apply custom configurations using the injector
//   final injector = ConfigurationInjector();
//   await _loadAndRegisterConfigurations(injector);
//   injector.configure(shell);

//   // Run the app
//   runApp(ClientAppExample(shell: shell));
// }

// /// Load the domain model (simulated for this example)
// Future<Domain> loadDomainModel() async {
//   // In a real application, this would load from generated code or a repository
//   // For this example, we'll create a simple domain model programmatically

//   // Create a domain
//   final domain = Domain('ExampleDomain');
//   domain.description = 'Example domain for client app';

//   // Create a model
//   final model = Model(domain, 'ProjectManagement');
//   model.description = 'Project management model';
//   domain.models.add(model);

//   // Create concepts
//   final projectConcept = Concept(model, 'Project');
//   model.concepts.add(projectConcept);

//   // Add attributes to Project
//   final nameAttr = Attribute(projectConcept, 'name');
//   nameAttr.type = domain.getType('String');
//   nameAttr.required = true;
//   projectConcept.attributes.add(nameAttr);

//   final descriptionAttr = Attribute(projectConcept, 'description');
//   descriptionAttr.type = domain.getType('String');
//   projectConcept.attributes.add(descriptionAttr);

//   final dueDateAttr = Attribute(projectConcept, 'dueDate');
//   dueDateAttr.type = domain.getType('DateTime');
//   projectConcept.attributes.add(dueDateAttr);

//   final statusAttr = Attribute(projectConcept, 'status');
//   statusAttr.type = domain.getType('String');
//   statusAttr.required = true;
//   projectConcept.attributes.add(statusAttr);

//   final budgetAttr = Attribute(projectConcept, 'budget');
//   budgetAttr.type = domain.getType('double');
//   projectConcept.attributes.add(budgetAttr);

//   final isCompleteAttr = Attribute(projectConcept, 'isComplete');
//   isCompleteAttr.type = domain.getType('bool');
//   projectConcept.attributes.add(isCompleteAttr);

//   // Add a task concept
//   final taskConcept = Concept(model, 'Task');
//   model.concepts.add(taskConcept);

//   // Add attributes to Task
//   final taskTitleAttr = Attribute(taskConcept, 'title');
//   taskTitleAttr.type = domain.getType('String');
//   taskTitleAttr.required = true;
//   taskConcept.attributes.add(taskTitleAttr);

//   final assigneeAttr = Attribute(taskConcept, 'assignee');
//   assigneeAttr.type = domain.getType('String');
//   taskConcept.attributes.add(assigneeAttr);

//   final priorityAttr = Attribute(taskConcept, 'priority');
//   priorityAttr.type = domain.getType('int');
//   taskConcept.attributes.add(priorityAttr);

//   return domain;
// }

// /// Register custom UX adapters for domain entities
// void _registerCustomAdapters(ShellApp shell) {
//   // Register a custom adapter for Project entities
//   shell.registerAdapter<ProjectEntity>(ProjectUXAdapterFactory());

//   // Register a disclosure-specific adapter for Task entities
//   shell.registerAdapterWithDisclosure<TaskEntity>(
//     TaskAdvancedUXAdapterFactory(),
//     DisclosureLevel.advanced,
//   );
// }

// /// Load and register configurations from various sources
// Future<void> _loadAndRegisterConfigurations(
//   ConfigurationInjector injector,
// ) async {
//   // Load from a YAML file (if available)
//   try {
//     await injector.loadFromYaml('config/app_config.yaml');
//   } catch (e) {
//     print('Could not load YAML configuration: $e');
//   }

//   // Create and register a programmatic UX configuration
//   final uxConfig = UXConfiguration(
//     name: 'Client App UX Configuration',
//     priority: 10,
//     defaultDisclosureLevel: DisclosureLevel.basic,
//   );
//   injector.registerConfiguration(uxConfig, ConfigurationType.ux);

//   // Create and register a data configuration
//   final dataConfig = DataConfiguration(
//     name: 'Client App Data Configuration',
//     priority: 5,
//     repositories: {
//       'Project': {
//         'type': 'inMemory',
//         'initialData': [
//           {'id': '1', 'name': 'Website Redesign', 'status': 'active'},
//           {'id': '2', 'name': 'Mobile App', 'status': 'planning'},
//         ],
//       },
//     },
//   );
//   injector.registerConfiguration(dataConfig, ConfigurationType.data);
// }

// /// Create a custom theme for the application
// ThemeData _createCustomTheme() {
//   return ThemeData(
//     primarySwatch: Colors.indigo,
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.indigo,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     ),
//     cardTheme: const CardTheme(elevation: 3, margin: EdgeInsets.all(8)),
//   );
// }

// /// Main application widget
// class ClientAppExample extends StatelessWidget {
//   final ShellApp shell;

//   const ClientAppExample({Key? key, required this.shell}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EDNet Client Example',
//       theme: shell.configuration.theme ?? ThemeData.light(),
//       home: MainScreen(shell: shell),
//     );
//   }
// }

// /// Main screen of the application showing the domain models
// class MainScreen extends StatefulWidget {
//   final ShellApp shell;

//   const MainScreen({Key? key, required this.shell}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   String _currentUserRole = 'user';
//   DisclosureLevel get _currentDisclosureLevel {
//     return _userRoleToDisclosureLevel(_currentUserRole);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Update the shell's user role
//     widget.shell.currentUserRole = _currentUserRole;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('EDNet Client Example'),
//         actions: [
//           // User role selector
//           DropdownButton<String>(
//             value: _currentUserRole,
//             dropdownColor: Theme.of(context).primaryColor,
//             underline: Container(), // Remove underline
//             icon: const Icon(Icons.person, color: Colors.white),
//             items: [
//               _buildRoleDropdownItem('user', 'User'),
//               _buildRoleDropdownItem('power_user', 'Power User'),
//               _buildRoleDropdownItem('admin', 'Admin'),
//               _buildRoleDropdownItem('developer', 'Developer'),
//             ],
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 setState(() {
//                   _currentUserRole = newValue;
//                   widget.shell.currentUserRole = newValue;
//                 });
//               }
//             },
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Current disclosure level indicator
//           Container(
//             color: _getDisclosureLevelColor(_currentDisclosureLevel),
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: Row(
//               children: [
//                 const Icon(Icons.visibility, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Current disclosure level: ${_currentDisclosureLevel.toString().split('.').last.toUpperCase()}',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),

//           // Main content
//           Expanded(child: DomainNavigator(shellApp: widget.shell)),
//         ],
//       ),
//       floatingActionButton:
//           widget.shell.hasFeature('visualization')
//               ? FloatingActionButton(
//                 onPressed: () {
//                   _showDomainVisualization(context);
//                 },
//                 tooltip: 'Domain visualization',
//                 child: const Icon(Icons.account_tree),
//               )
//               : null,
//     );
//   }

//   DropdownMenuItem<String> _buildRoleDropdownItem(String value, String label) {
//     return DropdownMenuItem(
//       value: value,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }

//   DisclosureLevel _userRoleToDisclosureLevel(String role) {
//     switch (role) {
//       case 'user':
//         return DisclosureLevel.basic;
//       case 'power_user':
//         return DisclosureLevel.intermediate;
//       case 'admin':
//         return DisclosureLevel.advanced;
//       case 'developer':
//         return DisclosureLevel.complete;
//       default:
//         return DisclosureLevel.basic;
//     }
//   }

//   Color _getDisclosureLevelColor(DisclosureLevel level) {
//     switch (level) {
//       case DisclosureLevel.minimal:
//         return Colors.grey;
//       case DisclosureLevel.basic:
//         return Colors.blue;
//       case DisclosureLevel.intermediate:
//         return Colors.green;
//       case DisclosureLevel.advanced:
//         return Colors.orange;
//       case DisclosureLevel.complete:
//         return Colors.red;
//     }
//   }

//   void _showDomainVisualization(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => DomainVisualizationScreen(
//               shellApp: widget.shell,
//               disclosureLevel: _currentDisclosureLevel,
//             ),
//       ),
//     );
//   }
// }

// /// Example domain visualization screen
// class DomainVisualizationScreen extends StatelessWidget {
//   final ShellApp shellApp;
//   final DisclosureLevel disclosureLevel;

//   const DomainVisualizationScreen({
//     Key? key,
//     required this.shellApp,
//     required this.disclosureLevel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Domain Visualization')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: shellApp.buildDomainVisualization(
//           context,
//           disclosureLevel: disclosureLevel,
//         ),
//       ),
//     );
//   }
// }

// /// Example entity implementation
// class ProjectEntity extends Entity<ProjectEntity> {
//   ProjectEntity({
//     required String id,
//     required String name,
//     String? description,
//     DateTime? dueDate,
//     String? status,
//     double? budget,
//     bool? isComplete,
//   }) : super(id) {
//     setAttribute('name', name);
//     if (description != null) setAttribute('description', description);
//     if (dueDate != null) setAttribute('dueDate', dueDate);
//     setAttribute('status', status ?? 'planning');
//     if (budget != null) setAttribute('budget', budget);
//     setAttribute('isComplete', isComplete ?? false);
//   }

//   String get name => getAttribute<String>('name') ?? '';
//   String get description => getAttribute<String>('description') ?? '';
//   DateTime? get dueDate => getAttribute<DateTime>('dueDate');
//   String get status => getAttribute<String>('status') ?? 'planning';
//   double get budget => getAttribute<double>('budget') ?? 0.0;
//   bool get isComplete => getAttribute<bool>('isComplete') ?? false;
// }

// /// Example entity implementation
// class TaskEntity extends Entity<TaskEntity> {
//   TaskEntity({
//     required String id,
//     required String title,
//     String? assignee,
//     int? priority,
//   }) : super(id) {
//     setAttribute('title', title);
//     if (assignee != null) setAttribute('assignee', assignee);
//     setAttribute('priority', priority ?? 1);
//   }

//   String get title => getAttribute<String>('title') ?? '';
//   String get assignee => getAttribute<String>('assignee') ?? '';
//   int get priority => getAttribute<int>('priority') ?? 1;
// }

// /// Example UX adapter for Project entities
// class ProjectUXAdapter extends ProgressiveUXAdapter<ProjectEntity> {
//   ProjectUXAdapter(ProjectEntity entity) : super(entity);

//   @override
//   Widget buildListItem(
//     BuildContext context, {
//     DisclosureLevel disclosureLevel = DisclosureLevel.minimal,
//   }) {
//     // Determine status color
//     final statusColor = _getStatusColor(entity.status);

//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: statusColor,
//           child: Icon(
//             entity.isComplete ? Icons.check : Icons.pending,
//             color: Colors.white,
//           ),
//         ),
//         title: Text(entity.name),
//         subtitle:
//             disclosureLevel.isAtLeast(DisclosureLevel.basic)
//                 ? Text(
//                   entity.description.isNotEmpty
//                       ? entity.description
//                       : entity.status,
//                 )
//                 : null,
//         trailing:
//             disclosureLevel.isAtLeast(DisclosureLevel.intermediate)
//                 ? entity.dueDate != null
//                     ? Chip(
//                       label: Text(
//                         '${entity.dueDate!.day}/${entity.dueDate!.month}',
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       backgroundColor: statusColor.withOpacity(0.2),
//                     )
//                     : null
//                 : null,
//       ),
//     );
//   }

//   @override
//   List<UXFieldDescriptor> getFieldDescriptors({
//     DisclosureLevel disclosureLevel = DisclosureLevel.basic,
//   }) {
//     // Define all possible fields
//     final allFields = [
//       // Name field - always visible (minimal)
//       UXFieldDescriptor(
//         fieldName: 'name',
//         displayName: 'Project Name',
//         fieldType: UXFieldType.text,
//         required: true,
//         validators: [
//           (value) =>
//               value == null || value.toString().isEmpty
//                   ? 'Name is required'
//                   : null,
//         ],
//       ).withDisclosureLevel(DisclosureLevel.minimal),

//       // Status field - always visible (minimal)
//       UXFieldDescriptor(
//         fieldName: 'status',
//         displayName: 'Status',
//         fieldType: UXFieldType.dropdown,
//         required: true,
//       ).withDisclosureLevel(DisclosureLevel.minimal).withOptions([
//         UXFieldOption(value: 'planning', label: 'Planning'),
//         UXFieldOption(value: 'active', label: 'Active'),
//         UXFieldOption(value: 'on_hold', label: 'On Hold'),
//         UXFieldOption(value: 'completed', label: 'Completed'),
//       ]),

//       // Description field - visible at basic level
//       UXFieldDescriptor(
//             fieldName: 'description',
//             displayName: 'Description',
//             fieldType: UXFieldType.longText,
//             required: false,
//           )
//           .withDisclosureLevel(DisclosureLevel.basic)
//           .withHint('Enter a detailed description of the project'),

//       // Due date - visible at intermediate level
//       UXFieldDescriptor(
//         fieldName: 'dueDate',
//         displayName: 'Due Date',
//         fieldType: UXFieldType.date,
//         required: false,
//       ).withDisclosureLevel(DisclosureLevel.intermediate),

//       // Completion status - visible at intermediate level
//       UXFieldDescriptor(
//         fieldName: 'isComplete',
//         displayName: 'Mark as Completed',
//         fieldType: UXFieldType.checkbox,
//         required: false,
//       ).withDisclosureLevel(DisclosureLevel.intermediate),

//       // Budget - visible at advanced level (for managers)
//       UXFieldDescriptor(
//         fieldName: 'budget',
//         displayName: 'Budget',
//         fieldType: UXFieldType.number,
//         required: false,
//       ).withDisclosureLevel(DisclosureLevel.advanced),
//     ];

//     // Filter fields based on disclosure level
//     return filterFieldsByDisclosure(allFields, disclosureLevel);
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'planning':
//         return Colors.blue;
//       case 'active':
//         return Colors.green;
//       case 'on_hold':
//         return Colors.orange;
//       case 'completed':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// /// Factory for creating ProjectUXAdapter instances
// class ProjectUXAdapterFactory implements UXAdapterFactory<ProjectEntity> {
//   @override
//   UXAdapter<ProjectEntity> create(ProjectEntity entity) {
//     return ProjectUXAdapter(entity);
//   }
// }

// /// Factory for creating advanced Task UX adapters
// class TaskAdvancedUXAdapterFactory implements UXAdapterFactory<TaskEntity> {
//   @override
//   UXAdapter<TaskEntity> create(TaskEntity entity) {
//     // This would return a specialized adapter for advanced users
//     return DefaultUXAdapter<TaskEntity>(entity);
//   }
// }
