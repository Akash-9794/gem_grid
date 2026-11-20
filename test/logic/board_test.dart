import 'package:flutter_test/flutter_test.dart';
import 'package:gem_grid/logic/board.dart';

const single = Shape([(0, 0)]);
const row3 = Shape([(0, 0), (0, 1), (0, 2)]);
const col3 = Shape([(0, 0), (1, 0), (2, 0)]);

void main() {
  test('new board is empty with zero score', () {
    final b = Board();
    expect(b.score, 0);
    expect(b.isFilled(4, 4), isFalse);
  });

  test('placing a shape fills cells and adds 1 point per cell', () {
    final b = Board();
    final result = b.place(row3, 0, 0);
    expect(b.isFilled(0, 0) && b.isFilled(0, 1) && b.isFilled(0, 2), isTrue);
    expect(result.pointsGained, 3);
    expect(b.score, 3);
  });

  test('cannot place outside the board or on filled cells', () {
    final b = Board();
    expect(b.canPlace(row3, 0, 7), isFalse);
    b.place(single, 5, 5);
    expect(b.canPlace(single, 5, 5), isFalse);
    expect(() => b.place(single, 5, 5), throwsArgumentError);
  });

  test('a full row is cleared', () {
    final b = Board();
    b.place(row3, 0, 0);
    b.place(row3, 0, 3);
    final result = b.place(row3, 0, 6);
    expect(result.clearedLines, 1);
    for (var c = 0; c < Board.size; c++) {
      expect(b.isFilled(0, c), isFalse);
    }
  });

  test('a full column is cleared', () {
    final b = Board();
    b.place(col3, 0, 4);
    b.place(col3, 3, 4);
    final result = b.place(col3, 6, 4);
    expect(result.clearedLines, 1);
    expect(b.isFilled(8, 4), isFalse);
  });

  test('consecutive clears build a combo that multiplies points', () {
    final b = Board();
    b.place(row3, 0, 0);
    b.place(row3, 0, 3);
    final first = b.place(row3, 0, 6); // clear #1, combo 1
    expect(b.combo, 1);
    expect(first.pointsGained, 3 + 10);

    b.place(row3, 1, 0); // no clear → combo resets
    expect(b.combo, 0);
  });

  test('combo of 2 doubles line points', () {
    final b = Board();
    // Prepare two rows with 6 cells each, completing them back to back.
    b.place(row3, 0, 0);
    b.place(row3, 0, 3);
    b.place(row3, 1, 0);
    b.place(row3, 1, 3);
    b.place(row3, 0, 6); // combo 1
    final second = b.place(row3, 1, 6); // combo 2
    expect(b.combo, 2);
    expect(second.pointsGained, 3 + 10 * 2);
  });

  test('fitsAnywhere is false when there is no room', () {
    final b = Board();
    // Checkerboard: no row or column is ever full, and no 3 empty cells
    // sit next to each other.
    for (var r = 0; r < Board.size; r++) {
      for (var c = 0; c < Board.size; c++) {
        if ((r + c).isEven) b.place(single, r, c);
      }
    }
    expect(b.fitsAnywhere(row3), isFalse);
    expect(b.fitsAnywhere(single), isTrue);
  });
}
