import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: GameOfLife(40)));
}

class GameOfLife extends FlameGame with TapDetector {
  final int gridSize;

  late List<PositionComponent> gameGrid;

  double timer = 0;
  final blocksOffset = 10.0;

  GameOfLife(this.gridSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    //generate a 40 x 40 grid of blocks
    gameGrid = List.generate(
      gridSize,
      (x) => List.generate(
        gridSize,
        (y) {
          //add a border around the grid
          if (x == 0 || x == gridSize - 1 || y == 0 || y == gridSize - 1) {
            return Border()
              ..position = Vector2(x * blocksOffset, y * blocksOffset);
          } else {
            return Block(x, y)
              ..position = Vector2(x * blocksOffset, y * blocksOffset)
              ..setEnabled(Random().nextBool());
          }
        },
      ),
    ).expand((e) => e).toList();

    addAll(gameGrid);
  }

  @override
  void update(double dt) {
    super.update(dt);

    //update the game every 0.25 seconds
    timer += dt;
    if (timer < 0.25) {
      return;
    }
    timer = 0;

    applyGameOfLifeRules();
  }

  //read block by grid position (x,y)
  Block getBlockByGridPosition(int x, int y) {
    return gameGrid[x * gridSize + y] as Block;
  }

  //apply the rules of the game of life
  void applyGameOfLifeRules() {
    gameGrid.whereType<Block>().forEach((block) {
      final x = block.gridXPosition;
      final y = block.gridYPosition;

      final enabledNeighbours = activeNeighboursCount(x, y);

      if (block.enabled) {
        if (enabledNeighbours < 2 || enabledNeighbours > 3) {
          block.setEnabled(false);
        }
      } else {
        if (enabledNeighbours == 3) {
          block.setEnabled(true);
        }
      }
    });
  }

  int activeNeighboursCount(int x, int y) {
    // get all neighbours grid positions
    final neighboursGridPositions = [
      GridPosition(x - 1, y - 1), // top left
      GridPosition(x - 1, y), // left
      GridPosition(x - 1, y + 1), // bottom left
      GridPosition(x, y - 1), // bottom
      GridPosition(x, y + 1), // top
      GridPosition(x + 1, y - 1), // top right
      GridPosition(x + 1, y), // right
      GridPosition(x + 1, y + 1), // bottom right
    ];

    // filter out neighbours that are outside the grid
    return neighboursGridPositions
        .where((e) =>
            e.x >= 1 && e.x < gridSize - 1 && e.y >= 1 && e.y < gridSize - 1)
        .map((e) => getBlockByGridPosition(e.x, e.y).enabled ? 1 : 0)
        .reduce((value, element) => value = value + element);
  }

  bool isNotBorderBlock(Block block) {
    //select only blocks that are not on the edge of the grid
    final x = block.gridXPosition;
    final y = block.gridYPosition;
    return x > 0 && x < gridSize - 1 && y > 0 && y < gridSize - 1;
  }

  // enable a block on tap
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    try {
      final block = gameGrid.firstWhere(
        (e) =>
            e is Block &&
            e.toRect().contains(info.eventPosition.game.toOffset()),
      ) as Block?;

      if (block != null) {
        block.setEnabled(true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class Block extends PositionComponent {
  final enabledPaint = Paint()..color = Colors.white;
  final disabledPaint = Paint()..color = Colors.black;

  final int gridXPosition;
  final int gridYPosition;
  final Paint? overridePaint;

  bool _enabled = false;

  bool _requestedEnabled = false;

  bool get enabled => _enabled;

  Block(this.gridXPosition, this.gridYPosition, {this.overridePaint});

  @override
  void render(Canvas canvas) {
    final paint = _enabled ? enabledPaint : disabledPaint;
    canvas.drawCircle(position.toOffset(), 5, overridePaint ?? paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_enabled != _requestedEnabled) {
      _enabled = _requestedEnabled;
    }
  }

  void setEnabled(bool enabled) => _requestedEnabled = enabled;
}

// Represents a Border
class Border extends PositionComponent {
  final Paint paint = Paint()..color = Colors.red;

  Border();

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(position.toOffset(), 5, paint);
  }
}

// Represents a grid position (x,y)
class GridPosition {
  final int x;
  final int y;

  GridPosition(this.x, this.y);
}
