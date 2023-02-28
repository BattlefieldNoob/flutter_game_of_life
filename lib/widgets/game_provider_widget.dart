import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_of_life/game_of_life.dart';
import 'package:flutter_game_of_life/widgets/game_params_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider_widget.g.dart';

@riverpod
GameOfLife gameOfLife(GameOfLifeRef ref) {
  final gameParams = ref.watch(gameParamsNotifierProvider);
  return GameOfLife(
      gameParams.gridSize, gameParams.updateInterval, gameParams.seed);
}

class GameProviderWidget extends ConsumerWidget {
  const GameProviderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWidget(game: ref.watch(gameOfLifeProvider));
  }
}
