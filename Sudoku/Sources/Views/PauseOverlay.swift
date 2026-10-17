import SwiftUI

struct PauseOverlay: View {
    let vm: GameViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                Text("Paused")
                    .font(.title.bold())
                    .foregroundStyle(Theme.givenText)

                Button {
                    vm.resume()
                } label: {
                    Text("Resume")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 60)
            }
        }
    }
}
