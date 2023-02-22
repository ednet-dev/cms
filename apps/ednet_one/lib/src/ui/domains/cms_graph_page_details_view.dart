import 'package:flutter/material.dart';

import '../cms_graph/engines/first/first.dart';
import '../cms_graph/model/mock.dart';
import 'i_details_view.dart';

/// Displays detailed information about a GraphPage.
class CmsGraphPageDetailsView extends StatelessWidget with DetailsView {
  const CmsGraphPageDetailsView({super.key});

  static const String routeName = '/cms_graph';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS Graph domain model'),
      ),
      body: Center(
        child: CMSCanvas(nodes: nodes2, edges: edges2),
      ),
    );
  }
}
