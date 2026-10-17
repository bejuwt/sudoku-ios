import Foundation

/// Backtracking solver using bit masks for rows, columns and boxes.
enum SudokuSolver {
    static let fullMask = 0x1FF // bits 0...8

    /// Counts solutions up to `limit` and returns the first solution found.
    static func solutions(_ input: [Int], limit: Int = 2) -> (grid: [Int]?, count: Int) {
        var grid = input
        var rowMask = [Int](repeating: 0, count: 9)
        var colMask = [Int](repeating: 0, count: 9)
        var boxMask = [Int](repeating: 0, count: 9)

        for i in 0..<81 {
            let value = grid[i]
            guard value != 0 else { continue }
            let bit = 1 << (value - 1)
            let b = i.sudokuBox
            if rowMask[i.sudokuRow] & bit != 0 || colMask[i.sudokuColumn] & bit != 0 || boxMask[b] & bit != 0 {
                return (nil, 0)
            }
            rowMask[i.sudokuRow] |= bit
            colMask[i.sudokuColumn] |= bit
            boxMask[b] |= bit
        }

        var count = 0
        var firstSolution: [Int]?

        func backtrack() {
            if count >= limit { return }

            var bestIndex = -1
            var bestMask = 0
            var bestCount = 10

            for i in 0..<81 where grid[i] == 0 {
                let used = rowMask[i.sudokuRow] | colMask[i.sudokuColumn] | boxMask[i.sudokuBox]
                let available = ~used & fullMask
                let n = available.nonzeroBitCount
                if n == 0 { return }
                if n < bestCount {
                    bestCount = n
                    bestIndex = i
                    bestMask = available
                    if n == 1 { break }
                }
            }

            guard bestIndex != -1 else {
                count += 1
                if firstSolution == nil { firstSolution = grid }
                return
            }

            let r = bestIndex.sudokuRow
            let c = bestIndex.sudokuColumn
            let b = bestIndex.sudokuBox
            var mask = bestMask
            while mask != 0 {
                let bit = mask & (-mask)
                mask &= mask - 1
                let value = bit.trailingZeroBitCount + 1

                grid[bestIndex] = value
                rowMask[r] |= bit
                colMask[c] |= bit
                boxMask[b] |= bit

                backtrack()

                grid[bestIndex] = 0
                rowMask[r] &= ~bit
                colMask[c] &= ~bit
                boxMask[b] &= ~bit

                if count >= limit { return }
            }
        }

        backtrack()
        return (firstSolution, count)
    }

    static func isUnique(_ grid: [Int]) -> Bool {
        solutions(grid, limit: 2).count == 1
    }
}
