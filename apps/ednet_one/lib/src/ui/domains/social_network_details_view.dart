import 'package:flutter/material.dart';

import 'i_details_view.dart';

/// Displays detailed information about a SocialNetwork.
class SocialNetworkDetailsView extends StatelessWidget with DetailsView {
  const SocialNetworkDetailsView({super.key});

  static const String routeName = '/net';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social network domain model'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
