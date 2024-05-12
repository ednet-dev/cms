import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:ednet_cms/ednet_cms.dart';
import '../../domain/direct_democracy/direct_democracy.dart';
import 'i_details_view.dart';

/// Displays detailed information about a Direct democracy domain model.
class DirectDemocracyDetailsView extends StatefulWidget with DetailsView {
  DirectDemocracyDetailsView({super.key});

  static const String routeName = '/dd';

  @override
  State<DirectDemocracyDetailsView> createState() =>
      _DirectDemocracyDetailsViewState();
}

class _DirectDemocracyDetailsViewState
    extends State<DirectDemocracyDetailsView> {
  var vote = Vote(Concept(Model(Domain(), 'Digital democracy'), 'Vote'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct democracy domain model'),
      ),
      body: Center(
        child: EntityWidget(entity: vote),
      ),
    );
  }
}
