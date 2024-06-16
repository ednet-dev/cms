import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

abstract class LayoutAlgorithm {
  Map<String, Offset> calculateLayout(Domains domains, Size size);
}
