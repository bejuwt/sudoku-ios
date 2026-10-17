import Foundation
import Observation

@MainActor
@Observable
final class GameViewModel {
    enum Status: String, Codable {
        case playing
        case paused
        case won
    }

    private struct Move {
        let index: Int
        let previousValue: Int
        let previousNotes: Set<Int>
        let newValue: Int
        let newNotes: Set<Int>
    }

    // MARK: Board

    private(set) var difficulty: Difficulty
    private(set) var solution: [Int]
    private(set) var isGiven: [Bool]
    private(set) var givens: [Int]

    var values: [Int]
    var notes: [Set<Int>]

    // MARK: Interaction

    var selected: Int?
    var pencilMode = false
    var autoCheck = true
    var status: Status = .playing
    var elapsed = 0
    var mistakes = 0
    var hintsUsed = 0

    var stats: [String: Stats]

    private var undoStack: [Move] = []
    private var timer: Timer?
    private var secondsSinceSave = 0

    // MARK: Init

    init(difficulty: Difficulty) {
        let puzzle = SudokuGenerator.generate(difficulty: difficulty)
        self.difficulty = puzzle.difficulty
        self.solution = puzzle.solution
        self.givens = puzzle.givens
        self.isGiven = puzzle.givens.map { $0 != 0 }
        self.values = puzzle.givens
        self.notes = Array(repeating: [], count: 81)
        self.stats = Persistence.loadStats()
        registerStart()
    }

    init?(restoring snapshot: GameSnapshot) {
        self.difficulty = snapshot.difficulty
        self.solution = snapshot.solution
        self.givens = snapshot.givens
        self.isGiven = snapshot.isGiven
        self.values = snapshot.values
        self.notes = snapshot.notes.map { Set($0) }
        self.elapsed = snapshot.elapsed
        self.mistakes = snapshot.mistakes
        self.stats = Persistence.loadStats()
    }

    static func loadOrCreate(difficulty: Difficulty = .easy) -> GameViewModel {
        if let snapshot = Persistence.loadGame(), snapshot.values.count == 81 {
            return GameViewModel(restoring: snapshot) ?? GameViewModel(difficulty: difficulty)
        }
        return GameViewModel(difficulty: difficulty)
    }

    // MARK: Derived state

    var timeString: String { StatsFormat.time(elapsed) }

    var isSolved: Bool { values == solution }

    func isError(_ index: Int) -> Bool {
        guard autoCheck, !isGiven[index] else { return false }
        let value = values[index]
        return value != 0 && value != solution[index]
    }

    /// Count of each digit currently on the board (index 1...9).
    func remainingCount(for digit: Int) -> Int {
        max(0, 9 - values.filter { $0 == digit }.count)
    }

    // MARK: Actions

    func select(_ index: Int) {
        guard index >= 0 && index < 81 else { return }
        selected = index
    }

    func enter(_ number: Int) {
        guard status == .playing, let index = selected, !isGiven[index] else { return }
        let previousValue = values[index]
        let previousNotes = notes[index]

        if pencilMode {
            if values[index] == 0 {
                if notes[index].contains(number) {
                    notes[index].remove(number)
                } else {
                    notes[index].insert(number)
                }
            } else {
                values[index] = 0
                notes[index] = [number]
            }
        } else {
            if values[index] == number {
                values[index] = 0
            } else {
                values[index] = number
                notes[index] = []
                if number != solution[index] { mistakes += 1 }
            }
        }

        undoStack.append(Move(index: index,
                              previousValue: previousValue,
                              previousNotes: previousNotes,
                              newValue: values[index],
                              newNotes: notes[index]))
        finishTurn()
    }

    func erase() {
        guard status == .playing, let index = selected, !isGiven[index] else { return }
        guard values[index] != 0 || !notes[index].isEmpty else { return }
        undoStack.append(Move(index: index,
                              previousValue: values[index],
                              previousNotes: notes[index],
                              newValue: 0,
                              newNotes: []))
        values[index] = 0
        notes[index] = []
        finishTurn()
    }

    func undo() {
        guard status == .playing, let move = undoStack.popLast() else { return }
        values[move.index] = move.previousValue
        notes[move.index] = move.previousNotes
        selected = move.index
        save()
    }

    func hint() {
        guard status == .playing else { return }
        let target: Int?
        if let index = selected, !isGiven[index], values[index] != solution[index] {
            target = index
        } else {
            target = (0..<81).first { values[$0] != solution[$0] }
        }
        guard let index = target else { return }
        selected = index
        undoStack.append(Move(index: index,
                              previousValue: values[index],
                              previousNotes: notes[index],
                              newValue: solution[index],
                              newNotes: []))
        values[index] = solution[index]
        notes[index] = []
        hintsUsed += 1
        finishTurn()
    }

    func togglePencil() {
        pencilMode.toggle()
    }

    // MARK: Timer

    func startTimer() {
        guard timer == nil, status == .playing else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    private func tick() {
        guard status == .playing else { return }
        elapsed += 1
        secondsSinceSave += 1
        if secondsSinceSave >= 5 {
            secondsSinceSave = 0
            save()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func pause() {
        guard status == .playing else { return }
        status = .paused
        stopTimer()
        save()
    }

    func resume() {
        guard status == .paused else { return }
        status = .playing
        startTimer()
    }

    // MARK: Persistence

    private func finishTurn() {
        if isSolved {
            status = .won
            stopTimer()
            registerWin()
            Persistence.clearGame()
        } else {
            save()
        }
    }

    func save() {
        guard status != .won else { return }
        let snapshot = GameSnapshot(difficulty: difficulty,
                                    givens: givens,
                                    solution: solution,
                                    values: values,
                                    notes: notes.map { Array($0).sorted() },
                                    isGiven: isGiven,
                                    elapsed: elapsed,
                                    mistakes: mistakes)
        Persistence.saveGame(snapshot)
    }

    private func registerStart() {
        var entry = stats[difficulty.rawValue] ?? Stats()
        entry.started += 1
        stats[difficulty.rawValue] = entry
        Persistence.saveStats(stats)
    }

    private func registerWin() {
        var entry = stats[difficulty.rawValue] ?? Stats()
        entry.registerWin(time: elapsed)
        stats[difficulty.rawValue] = entry
        Persistence.saveStats(stats)
    }
}
