import Foundation

enum Persistence {
    private static let gameKey = "sudoku.currentGame"
    private static let statsKey = "sudoku.stats"

    static func saveGame(_ snapshot: GameSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: gameKey)
    }

    static func loadGame() -> GameSnapshot? {
        guard let data = UserDefaults.standard.data(forKey: gameKey) else { return nil }
        return try? JSONDecoder().decode(GameSnapshot.self, from: data)
    }

    static func clearGame() {
        UserDefaults.standard.removeObject(forKey: gameKey)
    }

    static func loadStats() -> [String: Stats] {
        guard let data = UserDefaults.standard.data(forKey: statsKey),
              let stats = try? JSONDecoder().decode([String: Stats].self, from: data) else {
            return [:]
        }
        return stats
    }

    static func saveStats(_ stats: [String: Stats]) {
        guard let data = try? JSONEncoder().encode(stats) else { return }
        UserDefaults.standard.set(data, forKey: statsKey)
    }
}
