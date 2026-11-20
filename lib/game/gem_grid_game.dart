import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:material_ui/material_ui.dart';

/// Flame rendering layer. Draws things only — game rules live in lib/logic/.
class GemGridGame extends FlameGame {
  static const Color background = Color(0xFF12121C);

  late final TextComponent _title;

  @override
  Color backgroundColor() => background;

  @override
  Future<void> onLoad() async {
    _title = TextComponent(
      text: 'Gem Grid',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_title);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _title.position = size / 2;
  }

  @override
  void onMount() {
    super.onMount();
    _title.position = size / 2;
  }
}
