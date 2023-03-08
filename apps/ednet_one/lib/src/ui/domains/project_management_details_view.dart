import 'package:flutter/material.dart';

import 'i_details_view.dart';

/// Displays detailed information about a ProjectManagement.
class ProjectManagementDetailsView extends StatelessWidget with DetailsView {
  const ProjectManagementDetailsView({super.key});

  static const String routeName = '/pm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project management domain model'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
