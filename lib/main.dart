import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_of_life/game_of_life.dart';

void main() {
  runApp(GameWidget(game: GameOfLife(60, 0.125)));
}
