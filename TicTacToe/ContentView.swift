import SwiftUI

struct ContentView: View {
    @State private var board: [String] = Array(repeating: "", count: 9)
    @State private var isXTurn = true
    @State private var gameOver = false
    @State private var resultMessage = ""
    @State private var winningCells: Set<Int> = []
    @State private var xScore = 0
    @State private var oScore = 0

    private let winPatterns: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.15),
                         Color(red: 0.12, green: 0.10, blue: 0.22)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Tic Tac Toe")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                HStack(spacing: 40) {
                    ScoreLabel(label: "X", score: xScore, color: .cyan)
                    ScoreLabel(label: "O", score: oScore, color: .pink)
                }

                Text(gameOver ? resultMessage : (isXTurn ? "X's Turn" : "O's Turn"))
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(gameOver ? .yellow : (isXTurn ? .cyan : .pink))
                    .animation(.easeInOut, value: isXTurn)

                // Game Board
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(0..<9, id: \.self) { index in
                        CellView(
                            symbol: board[index],
                            isWinning: winningCells.contains(index)
                        )
                        .onTapGesture {
                            makeMove(at: index)
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                )

                Button(action: resetGame) {
                    Text("New Game")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading, endPoint: .trailing
                                ))
                        )
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
    }

    private func makeMove(at index: Int) {
        guard board[index].isEmpty, !gameOver else { return }

        board[index] = isXTurn ? "X" : "O"

        if let winner = checkWinner() {
            gameOver = true
            resultMessage = "\(winner) Wins!"
            if winner == "X" { xScore += 1 } else { oScore += 1 }
        } else if !board.contains("") {
            gameOver = true
            resultMessage = "It's a Draw!"
        } else {
            isXTurn.toggle()
        }
    }

    private func checkWinner() -> String? {
        for pattern in winPatterns {
            let a = board[pattern[0]]
            let b = board[pattern[1]]
            let c = board[pattern[2]]
            if !a.isEmpty && a == b && b == c {
                winningCells = Set(pattern)
                return a
            }
        }
        return nil
    }

    private func resetGame() {
        board = Array(repeating: "", count: 9)
        isXTurn = true
        gameOver = false
        resultMessage = ""
        winningCells = []
    }
}

struct CellView: View {
    let symbol: String
    let isWinning: Bool

    var body: some View {
        Text(symbol)
            .font(.system(size: 44, weight: .bold, design: .rounded))
            .foregroundColor(symbol == "X" ? .cyan : .pink)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isWinning
                          ? Color.yellow.opacity(0.2)
                          : Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isWinning ? Color.yellow : Color.white.opacity(0.15), lineWidth: isWinning ? 2 : 1)
            )
    }
}

struct ScoreLabel: View {
    let label: String
    let score: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text("\(score)")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}
