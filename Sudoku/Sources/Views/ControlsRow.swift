import SwiftUI

struct ControlsRow: View {
    let vm: GameViewModel

    var body: some View {
        HStack(spacing: 0) {
            control(icon: "arrow.uturn.backward", title: "Undo") { vm.undo() }
            control(icon: "eraser", title: "Erase") { vm.erase() }
            pencilControl
            control(icon: "lightbulb", title: "Hint") { vm.hint() }
        }
    }

    private var pencilControl: some View {
        Button {
            vm.togglePencil()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: vm.pencilMode ? "pencil.circle.fill" : "pencil.circle")
                    .font(.system(size: 22))
                Text("Notes").font(.system(size: 12))
            }
            .foregroundStyle(vm.pencilMode ? Theme.accent : Color.secondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(vm.status != .playing)
    }

    private func control(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 22))
                Text(title).font(.system(size: 12))
            }
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(vm.status != .playing)
    }
}
