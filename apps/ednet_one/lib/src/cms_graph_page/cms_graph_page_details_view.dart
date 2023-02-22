import 'package:flutter/material.dart';

import '../cms_graph/engines/first/first.dart';
import '../cms_graph/model/mock.dart';

/// Displays detailed information about a GraphPage.
class CmsGraphPageDetailsView extends StatelessWidget {
  const CmsGraphPageDetailsView({super.key});

  static const routeName = '/cms_graph_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS Graph Page Details'),
      ),
      body: Center(
        child: CMSCanvas(nodes: nodes2, edges: edges2),
      ),
    );
  }
}
