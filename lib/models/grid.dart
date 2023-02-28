import 'dart:math';

import 'package:flame/components.dart' show Vector2, Vector2Extension;
import 'package:flutter_game_of_life/components/block.dart' show Block;
import 'package:flutter_game_of_life/components/border.dart' show Border;
import 'package:flutter_game_of_life/models/grid_position.dart';

class Grid {
  final int height;
  final int width;
  final double blockUpdateInterval;

  final List<Block> blockGrid;

  final List<Border> borderGrid;

  Grid(this.height, this.width, this.blockUpdateInterval, int seed)
      : blockGrid =
            _initializeGameGrid(width, height, blockUpdateInterval, seed),
        borderGrid = _initializeBorderGrid(width, height);

  //read block by grid position (x,y)
  Block getBlockByGridPosition(int x, int y) {
    return blockGrid[x * width + y];
  }

  Block? getTappedBlock(Vector2 tapPosition) {
    try {
      return blockGrid.firstWhere(
        (e) => e.toRect().contains(tapPosition.toOffset()),
      );
    } catch (e) {
      return null;
    }
  }

  //border grid is used to draw the border
  static List<Border> _initializeBorderGrid(int width, int height) {
    final blocksXOffset = 400 / (width + 2);
    final blocksYOffset = 400 / (height + 2);
    final upperBorder = List.generate(
      width + 4,
      (x) => Border()
        ..position = Vector2(x * blocksXOffset, 0)
        ..size = Vector2(blocksXOffset, blocksYOffset),
    );

    final lowerBorder = List.generate(
      width + 4,
      (x) => Border()
        ..position = Vector2(x * blocksXOffset, (height + 3) * blocksYOffset)
        ..size = Vector2(blocksXOffset, blocksYOffset),
    );

    final leftBorder = List.generate(
      height + 2,
      (x) => Border()
        ..position = Vector2(0, (x + 1) * blocksYOffset)
        ..size = Vector2(blocksXOffset, blocksYOffset),
    );

    final rightBorder = List.generate(
      height + 2,
      (x) => Border()
        ..position =
            Vector2((width + 3) * blocksXOffset, (x + 1) * blocksYOffset)
        ..size = Vector2(blocksXOffset, blocksYOffset),
    );

    return [...upperBorder, ...lowerBorder, ...leftBorder, ...rightBorder];
  }

  static List<Block> _initializeGameGrid(
    int width,
    int height,
    double blockUpdateInterval,
    int seed,
  ) {
    final random = Random(seed);
    final blocksXOffset = 400 / width;
    final blocksYOffset = 400 / height;
    final grid = List.generate(
      width,
      (x) => List.generate(
        height,
        (y) {
          return Block(x, y, blockUpdateInterval)
            ..position = Vector2(blocksXOffset + (x * blocksXOffset),
                blocksYOffset + (y * blocksYOffset))
            ..size = Vector2(blocksXOffset, blocksYOffset)
            ..setEnabled(random.nextBool());
        },
      ),
    ).expand((e) => e).toList();

    //Initialize blocks with neighbours list
    grid.forEach((block) {
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
          .where((e) => e.x >= 0 && e.x < width && e.y >= 0 && e.y < height)
          .map((e) => grid[e.x * width + e.y])
          .toList();
    });

    return grid;
  }
}
