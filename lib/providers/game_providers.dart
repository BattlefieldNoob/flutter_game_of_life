import 'package:flutter_game_of_life/game_of_life.dart';
import 'package:flutter_game_of_life/models/game_params.dart';
import 'package:riverpod/riverpod.dart';

StateProvider<GameParams> gameParamsProvider = StateProvider((ref) {
  return GameParams(60, 0.125);
});

Provider<GameOfLife> gameOfLifeProvider = Provider((ref) {
  final gameParams = ref.watch(gameParamsProvider);
  return GameOfLife(gameParams.gridSize, gameParams.updateInterval);
});
