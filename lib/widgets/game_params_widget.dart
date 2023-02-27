import 'package:flutter/material.dart';
import 'package:flutter_game_of_life/models/game_params.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_params_widget.g.dart';

const defaultGridSize = 60;
const defaultUpdateInterval = 0.125;

@riverpod
class GameParamsNotifier extends _$GameParamsNotifier {
  @override
  GameParams build() {
    return GameParams(defaultGridSize, defaultUpdateInterval);
  }

  void updateParams(int gridSize, double updateInterval) {
    state = GameParams(gridSize, updateInterval);
  }
}

class GameParamsWidget extends HookConsumerWidget {
  const GameParamsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add a column with controls for game grid size and update interval
    final gridSize = useState(defaultGridSize);
    final updateInterval = useState(defaultUpdateInterval);

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
          onPressed: () => ref
              .read(gameParamsNotifierProvider.notifier)
              .updateParams(gridSize.value, updateInterval.value),
          child: const Text('Apply'),
        )
      ],
    ));
  }
}
