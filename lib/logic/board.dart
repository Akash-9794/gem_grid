// Pure Dart game logic — no Flutter or Flame imports allowed in lib/logic/.

/// A shape is a list of (row, col) cells relative to its top-left corner.
class Shape {
  final List<(int, int)> cells;
  const Shape(this.cells);
}

/// What happened after placing a shape.
class PlaceResult {
  final int clearedLines;
  final int pointsGained;
  const PlaceResult(this.clearedLines, this.pointsGained);
}

/// The 9x9 board. `true` means the cell is filled.
class Board {
  static const int size = 9;

  final List<List<bool>> _cells =
      List.generate(size, (_) => List.filled(size, false));

  int score = 0;

  /// How many placements in a row have cleared at least one line.
  int combo = 0;

  bool isFilled(int row, int col) => _cells[row][col];

  bool canPlace(Shape shape, int row, int col) {
    for (final (r, c) in shape.cells) {
      final rr = row + r, cc = col + c;
      if (rr < 0 || rr >= size || cc < 0 || cc >= size) return false;
      if (_cells[rr][cc]) return false;
    }
    return true;
  }

  /// Places [shape] with its top-left at ([row], [col]), clears full rows
  /// and columns, and updates score and combo.
  PlaceResult place(Shape shape, int row, int col) {
    if (!canPlace(shape, row, col)) {
      throw ArgumentError('Shape does not fit at ($row, $col)');
    }
    for (final (r, c) in shape.cells) {
      _cells[row + r][col + c] = true;
    }

    final fullRows = [
      for (var r = 0; r < size; r++)
        if (_cells[r].every((f) => f)) r,
    ];
    final fullCols = [
      for (var c = 0; c < size; c++)
        if (List.generate(size, (r) => _cells[r][c]).every((f) => f)) c,
    ];
    for (final r in fullRows) {
      for (var c = 0; c < size; c++) {
        _cells[r][c] = false;
      }
    }
    for (final c in fullCols) {
      for (var r = 0; r < size; r++) {
        _cells[r][c] = false;
      }
    }

    final lines = fullRows.length + fullCols.length;
    combo = lines > 0 ? combo + 1 : 0;
    // 1 point per cell placed, 10 per line, multiplied by the combo streak.
    final points = shape.cells.length + lines * 10 * (combo == 0 ? 1 : combo);
    score += points;
    return PlaceResult(lines, points);
  }

  /// True if [shape] fits anywhere on the board.
  bool fitsAnywhere(Shape shape) {
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        if (canPlace(shape, r, c)) return true;
      }
    }
    return false;
  }
}
