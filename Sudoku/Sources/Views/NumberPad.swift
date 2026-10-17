import SwiftUI

struct NumberPad: View {
    let vm: GameViewModel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...9, id: \.self) { number in
                let remaining = vm.remainingCount(for: number)
                let completed = remaining == 0
                Button {
                    vm.enter(number)
                } label: {
                    VStack(spacing: 1) {
                        Text("\(number)")
                            .font(.system(size: 28, weight: .regular))
                        Text(completed ? " " : "\(remaining)")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(completed ? AnyShapeStyle(Theme.userText.opacity(0.28))
                                               : AnyShapeStyle(Theme.userText))
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Theme.padBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(vm.status != .playing)
            }
        }
    }
}
