import 'package:flutter/material.dart';
import '../widgets/bookmarks/bookmarks_screen.dart';
import '../widgets/layout/web/header_widget.dart';

/// Dedicated page for accessing and managing bookmarks
class BookmarksPage extends StatelessWidget {
  /// The route name for this page
  static const String routeName = '/bookmarks';

  const BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: const ['Home', 'Bookmarks'],
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          },
          onAddFilter: (_) {},
          onBookmark: () {},
        ),
      ),
      body: const BookmarksScreen(),
    );
  }
}
