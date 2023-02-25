import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Block extends PositionComponent {
  final enabledPaint = Paint()..color = Colors.white;

  final int gridXPosition;
  final int gridYPosition;
  late final radius = size.x / 2;
  late final offset = position.toOffset();

  bool _enabled = false;

  bool _requestedEnabled = false;

  List<Block>? neighbours;

  double timer = 0;

  final double updateInterval;

  bool get enabled => _enabled;

  Block(this.gridXPosition, this.gridYPosition, this.updateInterval);

  @override
  void render(Canvas canvas) {
    if (!_enabled) {
      return;
    }
    canvas.drawCircle(offset, radius, enabledPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;
    if (timer < updateInterval) {
      return;
    }
    timer = 0;

    if (_enabled != _requestedEnabled) {
      _enabled = _requestedEnabled;
    }

    applyGameOfLifeRules();
  }

  void applyGameOfLifeRules() {
    if (neighbours != null) {
      final enabledNeighbours = neighbours!.where((e) => e.enabled).length;
      if (_enabled) {
        if (enabledNeighbours < 2 || enabledNeighbours > 3) {
          setEnabled(false);
        }
      } else {
        if (enabledNeighbours == 3) {
          setEnabled(true);
        }
      }
    }
  }

  void setEnabled(bool enabled) => _requestedEnabled = enabled;
}
