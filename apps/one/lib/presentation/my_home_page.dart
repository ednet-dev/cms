import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'footer_widget.dart';
import 'header_widget.dart';
import 'layout_block.dart';
import 'layout_state.dart';
import 'layout_template.dart';
import 'left_sidebar_widget.dart';
import 'main_content_widget.dart';
import 'right_sidebar_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          return LayoutTemplate(
            header: const HeaderWidget(),
            leftSidebar: const LeftSidebarWidget(),
            rightSidebar: const RightSidebarWidget(),
            mainContent: const MainContentWidget(),
            footer: const FooterWidget(),
          );
        },
      ),
    );
  }
}
