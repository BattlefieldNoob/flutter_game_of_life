import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_game_of_life/models/grid.dart';

class GameOfLife extends FlameGame with TapDetector {
  final Grid gameGrid;

  GameOfLife(int gridSize, double updateInterval, int seed)
      : gameGrid = Grid(gridSize, gridSize, updateInterval, seed);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addAll(gameGrid.blockGrid);
    addAll(gameGrid.borderGrid);

    add(FpsTextComponent());
  }

  // enable a block on tap
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    final block = gameGrid.getTappedBlock(info.eventPosition.game);

    if (block != null) {
      block.setEnabled(true);
    }
  }
}
