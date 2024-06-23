import 'package:flutter/material.dart';

import 'position_component.dart';

class DraggableArtefact extends StatefulWidget {
  final Artefact artefact;

  DraggableArtefact({required this.artefact});

  @override
  _DraggableArtefactState createState() => _DraggableArtefactState();
}

class _DraggableArtefactState extends State<DraggableArtefact> {
  Offset position = Offset(100, 100); // Initial position

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable<Artefact>(
        data: widget.artefact,
        feedback: Material(
          color: Colors.transparent,
          child: _buildArtefactWidget(widget.artefact),
        ),
        child: _buildArtefactWidget(widget.artefact),
        childWhenDragging: Container(),
        // Placeholder when dragging
        onDragEnd: (dragDetails) {
          setState(() {
            position = dragDetails.offset;
          });
        },
      ),
    );
  }

  Widget _buildArtefactWidget(Artefact artefact) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.blue,
      child: Center(
        child: Text(
          artefact.label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
