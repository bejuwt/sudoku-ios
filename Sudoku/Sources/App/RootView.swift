import SwiftUI

struct RootView: View {
    @State private var vm = GameViewModel.loadOrCreate()

    var body: some View {
        GameView(vm: vm) { difficulty in
            vm.pause()
            vm = GameViewModel(difficulty: difficulty)
        }
        .tint(Theme.accent)
    }
}

#Preview {
    RootView()
}
