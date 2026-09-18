//
//  ContentView.swift
//  DAFT
//
//  Created by Marc Leon Miller on 25.04.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Practice", systemImage: "person")
                }

            ExploreView()
                .tabItem {
                    Label("Match", systemImage: "person.2")
                }

        }
    }
}

struct HomeView: View {
    @State private var scores: [Int] = []
    @State private var inputScore = ""

    private var average: Double {
        scores.isEmpty ? 0 : Double(scores.reduce(0, +)) / Double(scores.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Average")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f", average))
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)

                HStack {
                    TextField("Score", text: $inputScore)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 120)

                    Button("Add") {
                        addScore()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(Int(inputScore) == nil)
                }

                if !scores.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(scores.enumerated()), id: \.offset) { _, score in
                                Text("\(score)")
                                    .font(.callout.monospacedDigit())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule().fill(Color(.secondarySystemBackground))
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Button("Reset") {
                    scores = []
                    inputScore = ""
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Practice")
        }
    }

    private func addScore() {
        guard let score = Int(inputScore), score >= 0, score <= 180 else { return }
        scores.append(score)
        inputScore = ""
    }
}

struct ExploreView: View {
    @State private var player1Score = 501
    @State private var player2Score = 501
    @State private var player1History: [Int] = []
    @State private var player2History: [Int] = []
    @State private var currentTurn = 1
    @State private var inputScore = ""
    @State private var winner: Int? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HStack(spacing: 16) {
                    PlayerScoreCard(
                        name: "Player 1",
                        score: player1Score,
                        isActive: currentTurn == 1 && winner == nil
                    )
                    PlayerScoreCard(
                        name: "Player 2",
                        score: player2Score,
                        isActive: currentTurn == 2 && winner == nil
                    )
                }
                .padding(.horizontal)

                if let winner {
                    Text("Player \(winner) wins!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                } else {
                    VStack(spacing: 12) {
                        Text("Player \(currentTurn)'s turn")
                            .font(.headline)

                        HStack {
                            TextField("Score", text: $inputScore)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 120)

                            Button("Submit") {
                                submitScore()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(Int(inputScore) == nil)
                        }
                    }
                }

                Button("Reset Match") {
                    resetMatch()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Match")
        }
    }

    private func submitScore() {
        guard let score = Int(inputScore), score >= 0, score <= 180 else { return }

        if currentTurn == 1 {
            let newScore = player1Score - score
            if newScore < 0 { inputScore = ""; return }
            player1Score = newScore
            player1History.append(score)
            if newScore == 0 { winner = 1 } else { currentTurn = 2 }
        } else {
            let newScore = player2Score - score
            if newScore < 0 { inputScore = ""; return }
            player2Score = newScore
            player2History.append(score)
            if newScore == 0 { winner = 2 } else { currentTurn = 1 }
        }

        inputScore = ""
    }

    private func resetMatch() {
        player1Score = 501
        player2Score = 501
        player1History = []
        player2History = []
        currentTurn = 1
        inputScore = ""
        winner = nil
    }
}

struct PlayerScoreCard: View {
    let name: String
    let score: Int
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.headline)
            Text("\(score)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(score == 0 ? .green : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isActive ? Color.accentColor.opacity(0.15) : Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? Color.accentColor : .clear, lineWidth: 2)
        )
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Text("History")
                .navigationTitle("History")
        }
    }
}

#Preview {
    ContentView()
}
