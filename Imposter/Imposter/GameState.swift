//
//  GameState.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: Holds data the whole app needs (players, theme, imposter count, etc)
//

import SwiftUI

// A single player in the game.
@Observable
final class Player: Identifiable, Hashable {
    // Identifiable lets List/ForEach render unique rows.
    let id = UUID()
    var name: String
    // We'll set this later when dealing cards.
    var isImpostor: Bool = false

    init(name: String) {
        self.name = name
    }

    // Hashable so we can store Players in Sets if needed later.
    static func == (lhs: Player, rhs: Player) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// Difficulty levels for future word selection.
enum Difficulty: String, CaseIterable {
    case easy, medium, hard
}

// Central game state shared across views.
// Because it's @Observable, any SwiftUI View that reads its properties
// will redraw when those properties change.
@Observable
final class GameState {
    // --- Setup values the host chooses ---
    var players: [Player] = []               // list of players for the current session
    var theme: String = "Animals"            // default theme
    var difficulty: Difficulty = .medium     // default difficulty
    var impostorCount: Int = 1               // how many impostors per round (we’ll enforce 1–2 for now)

    // --- Round values (we’ll use in later steps) ---
    var secretWord: String = ""              // chosen at round start
    var roundStarted: Bool = false           // toggled when a round begins

    // Helper to reset per-round flags while keeping player names.
    func resetRound() {
        for p in players {
            p.isImpostor = false
        }
        secretWord = ""
        roundStarted = false
    }
}
