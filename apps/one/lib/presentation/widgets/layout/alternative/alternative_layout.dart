// alternative_layout.dart
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/entity/entity_widget.dart';
import 'package:flutter/material.dart';

class AlternativeLayout extends StatefulWidget {
  final Domains domains;
  final Entity? selectedEntity;
  final Function(Entity) onEntitySelected;

  const AlternativeLayout({
    super.key,
    required this.domains,
    required this.selectedEntity,
    required this.onEntitySelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AlternativeLayoutState createState() => _AlternativeLayoutState();
}

class _AlternativeLayoutState extends State<AlternativeLayout> {
  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
        });
      },
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: RelationshipPainter(
              domains: widget.domains,
              offset: _dragOffset,
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 200, // Set a fixed width for the container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.domains.toList().map((domain) {
                      return ListTile(
                        title: Text(domain.code),
                        onTap: () {
                          // Navigate to domain details
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          if (widget.selectedEntity != null)
            Positioned(
              left: 200 + _dragOffset.dx,
              top: 200 + _dragOffset.dy,
              child: SizedBox(
                width: 400,
                height: 800,
                child: EntityWidget(entity: widget.selectedEntity!),
              ),
            ),
        ],
      ),
    );
  }
}

class RelationshipPainter extends CustomPainter {
  final Domains domains;
  final Offset offset;

  RelationshipPainter({required this.domains, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2;

    // Draw relationships between entities
    for (var domain in domains) {
      for (var model in domain.models) {
        for (var entity in model.concepts) {
          // Example: Draw a point for each entity
          final entityPosition = Offset(
            100.0 * model.concepts.toList().indexOf(entity) + offset.dx,
            100.0 * domain.models.toList().indexOf(model) + offset.dy,
          );
          canvas.drawCircle(entityPosition, 5.0, paint);

          // Draw relations (example, you need to adjust as per actual relations)
          for (var relation in entity.children) {
            final relatedEntityPosition = Offset(
              100.0 * entity.children.toList().indexOf(relation) + offset.dx,
              100.0 * domain.models.toList().indexOf(model) + offset.dy,
            );
            canvas.drawLine(entityPosition, relatedEntityPosition, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class EntityCard extends StatelessWidget {
  final Entity entity;

  const EntityCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(entity.getStringFromAttribute('name') ?? 'Unnamed Entity'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
