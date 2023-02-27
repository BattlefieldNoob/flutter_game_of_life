// Add Widget with controls for game grid size and update interval
import 'package:flutter/material.dart';
import 'package:flutter_game_of_life/models/game_params.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_params_widget.g.dart';

@riverpod
class GameParamsNotifier extends _$GameParamsNotifier {
  @override
  GameParams build() {
    return GameParams(60, 0.125);
  }

  void updateGameParams(GameParams updated) {
    state = updated;
  }
}

class GameParamsWidget extends HookConsumerWidget {
  const GameParamsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add a column with controls for game grid size and update interval
    final gridSize = useState(60);
    final updateInterval = useState(0.125);

    return Material(
        child: Column(
      children: [
        Text('Game grid size ${gridSize.value}'),
        Slider(
          value: gridSize.value.toDouble(),
          min: 20,
          max: 100,
          onChanged: (value) => gridSize.value = value.toInt(),
        ),
        Text('Update interval : ${updateInterval.value}'),
        Slider(
          value: updateInterval.value,
          min: 0.125,
          max: 2,
          onChanged: (value) => updateInterval.value = value,
        ),
        MaterialButton(
          onPressed: () => ref.read(gameParamsNotifierProvider.notifier).state =
              GameParams(gridSize.value, updateInterval.value),
          child: const Text('Apply'),
        )
      ],
    ));
  }
}
