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
    var hintsEnabled: Bool = true
    var hintCount: Int = 1
    var roundStarted: Bool = false

    // Helper to reset per-round flags while keeping player names.
    func resetRound() {
        for p in players { p.isImpostor = false }
        secretWord = ""
        impostorHints = []
        roundStarted = false
        // (optional) reset hint settings
        hintsEnabled = true
        hintCount = 1
    }

    // Call at the start of each round to pick a word and assign impostors.
    func prepareNewRound() {
        guard players.count >= 3 else { return }

        // Get a word and its *specific* hints from the theme
        let entry = WordBank.randomEntry(for: theme)
        secretWord = entry.word

        if hintsEnabled && hintCount > 0 {
            // Use up to `hintCount` hints for THIS word (shuffle to vary)
            impostorHints = Array(entry.hints.shuffled().prefix(hintCount))
        } else {
            impostorHints = []
        }

        // Clear flags
        for p in players { p.isImpostor = false }

        // Ensure at least one non-impostor
        let maxImpostors = max(1, min(impostorCount, players.count - 1))
        impostorCount = maxImpostors

        // Randomly choose impostors
        let indices = Array(players.indices).shuffled()
        for i in 0..<maxImpostors {
            players[indices[i]].isImpostor = true
        }

        players.shuffle()
        roundStarted = true
    }
}
