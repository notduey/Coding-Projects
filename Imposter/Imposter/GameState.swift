//
//  GameState.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
// Purpose: Holds data the whole app needs (players, theme, impostor count, etc)
//

import SwiftUI

// A single player in the game.
@Observable
final class Player: Identifiable, Hashable {
    // Identifiable lets List/ForEach render unique rows.
    let id = UUID()
    var name: String
    // Set when dealing cards.
    var isImpostor: Bool = false

    init(name: String) {
        self.name = name
    }

    // Hashable so we can store Players in Sets if needed later.
    static func == (lhs: Player, rhs: Player) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// Central game state shared across views.
// Because it's @Observable, any SwiftUI View that reads its properties
// will redraw when those properties change.
@Observable
final class GameState {
    // --- Setup values the host chooses ---
    var players: [Player] = []
    var theme: String = "Animals"
    var impostorCount: Int = 1
    var secretWord: String = ""
    var impostorHints: [String] = []
    var roundStarted: Bool = false

    // Helper to reset per-round flags while keeping player names.
    func resetRound() {
        for p in players { p.isImpostor = false }
        secretWord = ""
        impostorHints.removeAll()
        roundStarted = false
    }
    
    // Pick `count` hint words from the theme's hint list.
    // Ensures hints are not equal to the secret (in case your lists overlap).
    private func makeImpostorHints(from hints: [String], secret: String, count: Int = 1) -> [String] {
        let candidates = hints.filter { $0.caseInsensitiveCompare(secret) != .orderedSame }
        return Array(candidates.shuffled().prefix(count))
    }

    // Call at the start of each round to pick a word and assign impostors.
    func prepareNewRound() {
        guard players.count >= 3 else { return }

        // Get words and hints for the chosen theme
        let poolWords = WordBank.words(for: theme)
        let poolHints = WordBank.hints(for: theme)

        // Pick the secret
        secretWord = poolWords.randomElement() ?? "Pineapple"

        // Make 1 hint for impostors (easy to change to 2–3 later)
        impostorHints = makeImpostorHints(from: poolHints, secret: secretWord, count: 1)

        // Clear old flags
        for p in players { p.isImpostor = false }

        // Ensure at least one non-impostor
        let maxImpostors = max(1, min(impostorCount, players.count - 1))
        impostorCount = maxImpostors

        // Randomly choose impostor indices
        let indices = Array(players.indices).shuffled()
        for i in 0..<maxImpostors {
            let idx = indices[i]
            players[idx].isImpostor = true
        }

        // Shuffle turn order
        players.shuffle()
        roundStarted = true
    }
}
