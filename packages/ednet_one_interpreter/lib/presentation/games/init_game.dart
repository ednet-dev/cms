import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

class InitGame extends FlameGame {
  Entity entity;

  InitGame(this.entity);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    String svgString = generateEntitySvg(entity);
    final svg = await Svg.loadFromString(svgString);

    final svgComponent = SvgComponent(
      svg: svg,
      size: Vector2(400, 250),
      position: Vector2(0, 0),
    );

    add(svgComponent);
  }
}

void main() {
  // Replace with your actual entity initialization
  Entity entity = Entity(
    name: "Sample Entity",
    code: "1234",
    attributes: {},
    parents: {},
    children: {},
  );

  runApp(GameWidget(game: InitGame(entity)));
}

String generateEntitySvg(Entity entity) {
  String svgTemplate =
      '''<svg width="400" height="250" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="10" width="380" height="230" fill="white" stroke="black" stroke-width="2" rx="10" ry="10"/>
  
  <!-- Image Placeholder -->
  <rect x="10" y="10" width="380" height="100" fill="#d6d6d6" rx="10" ry="10"/>
  <circle cx="50" cy="60" r="20" fill="rgba(0,0,0,0.1)"/>
  <polygon points="70,50 90,50 80,70" fill="rgba(0,0,0,0.1)"/>
  
  <!-- Title -->
  <text x="20" y="130" font-family="Arial" font-size="20" fill="black">Name: {{entityName}}</text>
  
  <!-- Code -->
  <text x="20" y="150" font-family="Arial" font-size="16" fill="black">Code: {{entityCode}}</text>
  
  <!-- Attributes -->
  <text x="20" y="170" font-family="Arial" font-size="12" fill="black">Attributes: {{attributes}}</text>

  <!-- Parents -->
  <text x="20" y="190" font-family="Arial" font-size="12" fill="black">Parents: {{parents}}</text>

  <!-- Children -->
  <text x="20" y="210" font-family="Arial" font-size="12" fill="black">Children: {{children}}</text>
  
  <!-- Action Button -->
  <rect x="320" y="210" width="70" height="20" fill="#6200ee" rx="5" ry="5"/>
  <text x="335" y="225" font-family="Arial" font-size="12" fill="white">ACTION</text>
</svg>''';

  // Replace placeholders with actual entity data
  svgTemplate = svgTemplate.replaceFirst('{{entityName}}', entity.name);
  svgTemplate = svgTemplate.replaceFirst('{{entityCode}}', entity.code);
  svgTemplate =
      svgTemplate.replaceFirst('{{attributes}}', entity.attributes.toString());
  svgTemplate =
      svgTemplate.replaceFirst('{{parents}}', entity.parents.toString());
  svgTemplate =
      svgTemplate.replaceFirst('{{children}}', entity.children.toString());

  return svgTemplate;
}

// Dummy implementation for Entity class
class Entity {
  String name;
  String code;
  Map<String, dynamic> attributes;
  Map<String, dynamic> parents;
  Map<String, dynamic> children;

  Entity({
    required this.name,
    required this.code,
    required this.attributes,
    required this.parents,
    required this.children,
  });
}

// class MyGame extends FlameGame {
//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//
//     final domain = Artefact(label: 'Domain', width: 200, height: 100, color: Colors.green)
//       ..position = Vector2(100, 100);
//     add(domain);
//
//     final model = Artefact(label: 'Model', width: 150, height: 75, color: Colors.red)
//       ..position = Vector2(150, 250);
//     add(model);
//
//     final entity = Artefact(label: 'Entity', width: 100, height: 50, color: Colors.blue)
//       ..position = Vector2(175, 350);
//     add(entity);
//
//     // Add lines between artefacts
//     add(LineComponent(start: domain.position + Vector2(domain.width / 2, domain.height), end: model.position + Vector2(model.width / 2, 0)));
//     add(LineComponent(start: model.position + Vector2(model.width / 2, model.height), end: entity.position + Vector2(entity.width / 2, 0)));
//   }
// }
//
// class LineComponent extends PositionComponent {
//   final Vector2 start;
//   final Vector2 end;
//   final Paint _paint;
//
//   LineComponent({
//     required this.start,
//     required this.end,
//     Color color = Colors.black,
//   }) : _paint = Paint()
//     ..color = color
//     ..strokeWidth = 2;
//
//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     canvas.drawLine(start.toOffset(), end.toOffset(), _paint);
//   }
// }
