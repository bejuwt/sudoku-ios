import Foundation

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    /// Number of clues left on the board. Lower means harder.
    var clueCount: Int {
        switch self {
        case .easy: return 45
        case .medium: return 36
        case .hard: return 30
        }
    }

    var next: Difficulty {
        switch self {
        case .easy: return .medium
        case .medium: return .hard
        case .hard: return .easy
        }
    }
}
