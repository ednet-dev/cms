// header_widget.dart
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final List<String> path;
  final void Function(int index) onPathSegmentTapped;

  const HeaderWidget(
      {super.key, required this.path, required this.onPathSegmentTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: path.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onPathSegmentTapped(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Text(
                            path[index],
                          ),
                          if (index < path.length - 1)
                            const Icon(Icons.chevron_right,
                                color: Colors.white),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
