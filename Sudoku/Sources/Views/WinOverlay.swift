import SwiftUI

struct WinOverlay: View {
    let vm: GameViewModel
    var onNewGame: (Difficulty) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.accent)

                Text("You solved it!")
                    .font(.title.bold())
                    .foregroundStyle(Theme.givenText)

                Text(vm.difficulty.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(vm.timeString)
                    .font(.system(size: 44, weight: .bold, design: .monospaced))
                    .foregroundStyle(Theme.givenText)

                Text("Mistakes: \(vm.mistakes)   ·   Hints: \(vm.hintsUsed)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 10) {
                    Button {
                        onNewGame(vm.difficulty)
                    } label: {
                        primaryLabel("New \(vm.difficulty.title) Game")
                    }
                    Button {
                        onNewGame(vm.difficulty.next)
                    } label: {
                        primaryLabel("Play \(vm.difficulty.next.title)")
                    }
                }
                .padding(.top, 6)
            }
            .padding(28)
            .background(Theme.cellBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 24, y: 8)
            .padding(.horizontal, 36)
        }
    }

    private func primaryLabel(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(Theme.accent)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
