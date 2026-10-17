import SwiftUI

struct GameHeader: View {
    let vm: GameViewModel
    var onNewGame: (Difficulty) -> Void
    @Binding var showStats: Bool

    var body: some View {
        HStack {
            Menu {
                Section("Difficulty") {
                    ForEach(Difficulty.allCases) { difficulty in
                        Button {
                            onNewGame(difficulty)
                        } label: {
                            if difficulty == vm.difficulty {
                                Label(difficulty.title, systemImage: "checkmark")
                            } else {
                                Text(difficulty.title)
                            }
                        }
                    }
                }
                Divider()
                Toggle("Auto-check", isOn: Binding(get: { vm.autoCheck }, set: { vm.autoCheck = $0 }))
                Button {
                    showStats = true
                } label: {
                    Label("Statistics", systemImage: "chart.bar")
                }
                Button(role: .destructive) {
                    onNewGame(vm.difficulty)
                } label: {
                    Label("New Game", systemImage: "arrow.clockwise")
                }
            } label: {
                HStack(spacing: 4) {
                    Text(vm.difficulty.title)
                        .font(.system(size: 18, weight: .semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Theme.accent)
            }

            Spacer()

            Text(vm.timeString)
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                .foregroundStyle(Theme.givenText)

            Spacer()

            Button {
                if vm.status == .paused { vm.resume() } else { vm.pause() }
            } label: {
                Image(systemName: vm.status == .paused ? "play.circle" : "pause.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(Theme.accent)
            }
            .disabled(vm.status == .won)
            .opacity(vm.status == .won ? 0.3 : 1)
        }
        .padding(.horizontal, 16)
    }
}
