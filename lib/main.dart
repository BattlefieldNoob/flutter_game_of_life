import 'package:flutter/material.dart';
import 'package:flutter_game_of_life/widgets/game_params_widget.dart';
import 'package:flutter_game_of_life/widgets/game_provider_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
      home: ColoredBox(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox.square(dimension: 820, child: GameProviderWidget()),
            SizedBox(width: 350, height: 820, child: GameParamsWidget()),
          ],
        ),
      ),
    ));
  }
}
