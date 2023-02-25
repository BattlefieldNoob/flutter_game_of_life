import 'dart:math';

import 'package:flame/components.dart' show PositionComponent;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game_of_life/components/block.dart' show Block;
import 'package:flutter_game_of_life/components/border.dart' show Border;
import 'package:flutter_game_of_life/models/grid_position.dart';

class GameOfLife extends FlameGame with TapDetector {
  final int gridSize;

  late List<PositionComponent> gameGrid;

  late final blocksOffset = 400 / gridSize;
  final blockUpdateInterval = 0.125;

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
              ..position = Vector2(x * blocksOffset, y * blocksOffset)
              ..size = Vector2.all(blocksOffset);
          } else {
            return Block(x, y, blockUpdateInterval)
              ..position = Vector2(x * blocksOffset, y * blocksOffset)
              ..size = Vector2.all(blocksOffset)
              ..setEnabled(Random().nextBool());
          }
        },
      ),
    ).expand((e) => e).toList();

    //Initialize blocks with neighbours list
    gameGrid.whereType<Block>().forEach((block) {
      final x = block.gridXPosition;
      final y = block.gridYPosition;

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
      block.neighbours = neighboursGridPositions
          .where((e) =>
              e.x >= 1 && e.x < gridSize - 1 && e.y >= 1 && e.y < gridSize - 1)
          .map((e) => getBlockByGridPosition(e.x, e.y))
          .toList();
    });

    addAll(gameGrid);
  }

  //read block by grid position (x,y)
  Block getBlockByGridPosition(int x, int y) {
    return gameGrid[x * gridSize + y] as Block;
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
