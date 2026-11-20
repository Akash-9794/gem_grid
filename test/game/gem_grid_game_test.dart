import 'package:flutter_test/flutter_test.dart';
import 'package:gem_grid/game/gem_grid_game.dart';

void main() {
  test('game uses a dark background', () {
    final c = GemGridGame().backgroundColor();
    expect(c.computeLuminance(), lessThan(0.1));
  });
}
