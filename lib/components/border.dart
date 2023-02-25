import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// Represents a Border
class Border extends PositionComponent {
  final Paint paint = Paint()..color = Colors.red;

  late final radius = size.x / 2;
  late final offset = position.toOffset();

  Border();

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(offset, radius, paint);
  }
}
