import SwiftUI

struct SudokuGridView: View {
    let vm: GameViewModel

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let cell = size / 9

            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<9, id: \.self) { column in
                                let index = row * 9 + column
                                cellView(index: index, cell: cell)
                                    .frame(width: cell, height: cell)
                                    .background(cellBackground(for: index))
                                    .contentShape(Rectangle())
                                    .onTapGesture { vm.select(index) }
                            }
                        }
                    }
                }
                .background(Theme.cellBackground)

                GridLines(size: size)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .stroke(Theme.gridThick, lineWidth: 2)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func cellView(index: Int, cell: CGFloat) -> some View {
        let value = vm.values[index]
        if value != 0 {
            Text("\(value)")
                .font(.system(size: cell * 0.6,
                              weight: vm.isGiven[index] ? .semibold : .regular))
                .foregroundStyle(valueColor(index: index))
        } else if !vm.notes[index].isEmpty {
            NotesGrid(notes: vm.notes[index], size: cell)
        }
    }

    private func valueColor(index: Int) -> Color {
        if vm.isError(index) { return Theme.errorText }
        if vm.isGiven[index] { return Theme.givenText }
        if let selected = vm.selected,
           vm.values[selected] != 0,
           vm.values[selected] == vm.values[index],
           selected != index {
            return Theme.accent
        }
        return Theme.userText
    }

    private func cellBackground(for index: Int) -> Color {
        guard let selected = vm.selected else { return .clear }
        if index == selected { return Theme.selectedCell }

        if vm.values[selected] != 0, vm.values[index] == vm.values[selected] {
            return Theme.sameNumber
        }

        let sameRow = index.sudokuRow == selected.sudokuRow
        let sameColumn = index.sudokuColumn == selected.sudokuColumn
        let sameBox = index.sudokuBox == selected.sudokuBox
        if sameRow || sameColumn || sameBox { return Theme.peerCell }
        return .clear
    }
}

private struct NotesGrid: View {
    let notes: Set<Int>
    let size: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { column in
                        let number = row * 3 + column + 1
                        Text(notes.contains(number) ? "\(number)" : " ")
                            .font(.system(size: max(6, size * 0.24), weight: .medium))
                            .foregroundStyle(Theme.userText.opacity(0.85))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .padding(size * 0.05)
    }
}

private struct GridLines: View {
    let size: CGFloat

    var body: some View {
        let cell = size / 9
        ZStack {
            Path { path in
                for i in 1..<9 where i % 3 != 0 {
                    let offset = cell * CGFloat(i)
                    path.move(to: CGPoint(x: offset, y: 0))
                    path.addLine(to: CGPoint(x: offset, y: size))
                    path.move(to: CGPoint(x: 0, y: offset))
                    path.addLine(to: CGPoint(x: size, y: offset))
                }
            }
            .stroke(Theme.gridThin, lineWidth: 0.5)

            Path { path in
                for i in [3, 6] {
                    let offset = cell * CGFloat(i)
                    path.move(to: CGPoint(x: offset, y: 0))
                    path.addLine(to: CGPoint(x: offset, y: size))
                    path.move(to: CGPoint(x: 0, y: offset))
                    path.addLine(to: CGPoint(x: size, y: offset))
                }
            }
            .stroke(Theme.gridThick, lineWidth: 1.5)
        }
        .allowsHitTesting(false)
    }
}
