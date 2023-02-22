import 'package:flutter/material.dart';

import 'i_details_view.dart';

/// Displays detailed information about a Direct democracy domain model.
class DirectDemocracyDetailsView extends StatelessWidget with DetailsView {
  const DirectDemocracyDetailsView({super.key});

  static const String routeName = '/dd';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct democracy domain model'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
