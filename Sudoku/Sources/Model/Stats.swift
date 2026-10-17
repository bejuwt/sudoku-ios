import Foundation

struct Stats: Codable {
    var started = 0
    var won = 0
    var bestTime: Int?
    var totalTime = 0

    var averageTime: Int? {
        won > 0 ? totalTime / won : nil
    }

    mutating func registerWin(time: Int) {
        won += 1
        totalTime += time
        if let best = bestTime {
            bestTime = min(best, time)
        } else {
            bestTime = time
        }
    }
}

enum StatsFormat {
    static func time(_ seconds: Int?) -> String {
        guard let seconds else { return "—" }
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
