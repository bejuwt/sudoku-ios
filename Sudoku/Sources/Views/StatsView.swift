import SwiftUI

struct StatsView: View {
    let stats: [String: Stats]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(Difficulty.allCases) { difficulty in
                    let entry = stats[difficulty.rawValue] ?? Stats()
                    Section(difficulty.title) {
                        row("Games played", "\(entry.started)")
                        row("Games won", "\(entry.won)")
                        row("Best time", StatsFormat.time(entry.bestTime))
                        row("Average time", StatsFormat.time(entry.averageTime))
                    }
                }
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }
}
