import 'package:flutter/material.dart';

import 'i_details_view.dart';

/// Displays detailed information about a Legislation.
class LegislationDetailsView extends StatelessWidget with DetailsView {
  const LegislationDetailsView({super.key});

  static const String routeName = '/lg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legislation domain model'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
