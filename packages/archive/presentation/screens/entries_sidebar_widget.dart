import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

class EntriesSidebarWidget extends StatelessWidget {
  final Entities entries;

  const EntriesSidebarWidget({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entity = entries.elementAt(index);
          return ListTile(
            title: Text(entity.code),
            onTap: () {
              // Handle entity selection
            },
          );
        },
      ),
    );
  }
}
