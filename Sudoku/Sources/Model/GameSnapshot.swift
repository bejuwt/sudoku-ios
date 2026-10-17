import Foundation

/// Serializable state of a game in progress.
struct GameSnapshot: Codable {
    var difficulty: Difficulty
    var givens: [Int]
    var solution: [Int]
    var values: [Int]
    var notes: [[Int]]
    var isGiven: [Bool]
    var elapsed: Int
    var mistakes: Int
}
