import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Center(
        child: Text('Footer - ${DateTime.now().toString()}'),
      ),
    );
  }
}
