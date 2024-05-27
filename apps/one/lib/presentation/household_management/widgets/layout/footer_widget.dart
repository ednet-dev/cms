import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.purple,
      child: Center(
        child: Text('Footer - ${DateTime.now().toString()}'),
      ),
    );
  }
}