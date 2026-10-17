import Foundation

struct SudokuPuzzle {
    static let side = 9
    static let cellCount = 81

    /// 81 values, `0` means empty.
    var givens: [Int]
    /// The completed grid.
    var solution: [Int]
    var difficulty: Difficulty
}

extension Int {
    /// Row (0...8) for a linear board index.
    var sudokuRow: Int { self / 9 }
    /// Column (0...8) for a linear board index.
    var sudokuColumn: Int { self % 9 }
    /// Box (0...8) for a linear board index.
    var sudokuBox: Int { (sudokuRow / 3) * 3 + sudokuColumn / 3 }
}
