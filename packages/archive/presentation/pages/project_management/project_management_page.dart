import 'package:flutter/material.dart';
import 'package:ednet_one/domain/services/project_service.dart';
import 'package:ednet_one/domain/services/deployment_service.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart';

/// Project Management Page for managing projects and deployments
class ProjectManagementPage extends StatefulWidget {
  /// Route name for the project management page
  static const String routeName = '/project-management';

  /// Constructor
  const ProjectManagementPage({Key? key}) : super(key: key);

  @override
  _ProjectManagementPageState createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage>
    with SingleTickerProviderStateMixin {
  late ProjectService _projectService;
  late DeploymentService _deploymentService;
  late TabController _tabController;

  List<Project> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initServices();
  }

  Future<void> _initServices() async {
    // Initialize services
    _projectService = ProjectService(oneApplication, persistenceService);
    _deploymentService = DeploymentService(
      oneApplication,
      persistenceService,
      _projectService,
    );

    // Load projects
    await _loadProjects();

    // Create a demo project if none exist
    if (_projects.isEmpty) {
      await _createDemoProject();
    }
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    await _projectService.loadProjects();

    setState(() {
      _projects = _projectService.allProjects;
      _isLoading = false;
    });
  }

  Future<void> _createDemoProject() async {
    if (_projects.isNotEmpty) return;

    // Get a list of available domains
    final domains = oneApplication.domains.toList();
    if (domains.isEmpty) return;

    // Create a project for the first available domain
    final domain = domains.first;
    await _projectService.createProject(
      name: 'Demo Project',
      description: 'A sample project for demonstration',
      domainCode: domain.code,
      modelCode: domain.models.isEmpty ? null : domain.models.first.code,
    );

    // Refresh the projects list
    await _loadProjects();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Projects'), Tab(text: 'Deployments')],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadProjects,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Project',
            onPressed: _showCreateProjectDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildProjectsTab(), _buildDeploymentsTab()],
            ),
    );
  }

  Widget _buildProjectsTab() {
    if (_projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: context.spacingM),
            Text(
              'No projects yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: context.spacingS),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Project'),
              onPressed: _showCreateProjectDialog,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(context.spacingM),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return Card(
          margin: EdgeInsets.only(bottom: context.spacingM),
          child: InkWell(
            onTap: () => _showProjectDetails(project),
            child: Padding(
              padding: EdgeInsets.all(context.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              project.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(project.status.toString()),
                    ],
                  ),
                  SizedBox(height: context.spacingM),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Domain: ${project.domainCode}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (project.modelCode != null)
                              Text('Model: ${project.modelCode}'),
                          ],
                        ),
                      ),
                      Text(
                        'Created: ${_formatDate(project.createdAt)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.rocket_launch),
                        label: const Text('Deploy'),
                        onPressed: () => _showDeployDialog(project),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      SizedBox(width: context.spacingS),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Project',
                        onPressed: () => _showEditProjectDialog(project),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete Project',
                        onPressed: () => _confirmDeleteProject(project),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    IconData icon;

    switch (status) {
      case 'ProjectStatus.development':
        chipColor = Colors.blue;
        icon = Icons.code;
        break;
      case 'ProjectStatus.testing':
        chipColor = Colors.orange;
        icon = Icons.bug_report;
        break;
      case 'ProjectStatus.production':
        chipColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'ProjectStatus.archived':
        chipColor = Colors.grey;
        icon = Icons.archive;
        break;
      default:
        chipColor = Colors.blue;
        icon = Icons.help_outline;
    }

    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        status.split('.').last,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildDeploymentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rocket_launch,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: context.spacingM),
          Text(
            'No deployments yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: context.spacingS),
          Text(
            'Select a project and click "Deploy" to create a new deployment',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Project'),
        content: const Text('Project creation form would appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project.name),
        content: Text('Project details would appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeployDialog(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deploy ${project.name}'),
        content: const Text('Deployment options would appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Deploy'),
          ),
        ],
      ),
    );
  }

  void _showEditProjectDialog(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${project.name}'),
        content: const Text('Project edit form would appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProject(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete ${project.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
