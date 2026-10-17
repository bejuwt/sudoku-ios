import SwiftUI

struct GameView: View {
    @Bindable var vm: GameViewModel
    var onNewGame: (Difficulty) -> Void

    @Environment(\.scenePhase) private var scenePhase
    @State private var showStats = false

    var body: some View {
        VStack(spacing: 14) {
            GameHeader(vm: vm, onNewGame: onNewGame, showStats: $showStats)

            SudokuGridView(vm: vm)
                .padding(.horizontal, 10)

            Spacer(minLength: 0)

            ControlsRow(vm: vm)
                .padding(.horizontal, 10)

            NumberPad(vm: vm)
                .padding(.horizontal, 10)
                .padding(.bottom, 6)
        }
        .padding(.top, 8)
        .background(Theme.background.ignoresSafeArea())
        .overlay {
            if vm.status == .paused { PauseOverlay(vm: vm) }
        }
        .overlay {
            if vm.status == .won { WinOverlay(vm: vm, onNewGame: onNewGame) }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { vm.pause() }
        }
        .sheet(isPresented: $showStats) {
            StatsView(stats: vm.stats)
        }
        .onAppear { vm.startTimer() }
    }
}
