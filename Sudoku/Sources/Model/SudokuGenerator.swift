import Foundation

enum SudokuGenerator {
    static func generate(difficulty: Difficulty) -> SudokuPuzzle {
        let solution = generateSolved()
        let givens = dig(from: solution, targetClues: difficulty.clueCount)
        return SudokuPuzzle(givens: givens, solution: solution, difficulty: difficulty)
    }

    /// Produces a random, fully solved board.
    static func generateSolved() -> [Int] {
        var grid = [Int](repeating: 0, count: 81)
        var rowMask = [Int](repeating: 0, count: 9)
        var colMask = [Int](repeating: 0, count: 9)
        var boxMask = [Int](repeating: 0, count: 9)
        _ = fill(&grid, &rowMask, &colMask, &boxMask)
        return grid
    }

    private static func fill(_ grid: inout [Int],
                             _ rowMask: inout [Int],
                             _ colMask: inout [Int],
                             _ boxMask: inout [Int]) -> Bool {
        guard let index = grid.firstIndex(of: 0) else { return true }
        let r = index.sudokuRow
        let c = index.sudokuColumn
        let b = index.sudokuBox
        let used = rowMask[r] | colMask[c] | boxMask[b]
        var available = ~used & SudokuSolver.fullMask

        var choices: [Int] = []
        while available != 0 {
            let bit = available & (-available)
            available &= available - 1
            choices.append(bit)
        }
        choices.shuffle()

        for bit in choices {
            let value = bit.trailingZeroBitCount + 1
            grid[index] = value
            rowMask[r] |= bit
            colMask[c] |= bit
            boxMask[b] |= bit

            if fill(&grid, &rowMask, &colMask, &boxMask) { return true }

            grid[index] = 0
            rowMask[r] &= ~bit
            colMask[c] &= ~bit
            boxMask[b] &= ~bit
        }
        return false
    }

    /// Removes clues one at a time, keeping the puzzle uniquely solvable.
    private static func dig(from solution: [Int], targetClues: Int) -> [Int] {
        var givens = solution
        var clues = 81
        for index in (0..<81).shuffled() {
            if clues <= targetClues { break }
            let backup = givens[index]
            guard backup != 0 else { continue }
            givens[index] = 0
            if SudokuSolver.isUnique(givens) {
                clues -= 1
            } else {
                givens[index] = backup
            }
        }
        return givens
    }
}
