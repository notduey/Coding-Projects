//
//  SetupView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: Host picks theme, number of imposters, and adds player names
//

import SwiftUI

struct SetupView: View {
    // Pull the shared GameState from the environment (provided in ImpostorWordApp)
    @Environment(GameState.self) private var game

    @State private var newPlayerName: String = ""
    private let themes = ["Animals", "Food", "Jobs", "Places", "Random"]

    var body: some View {
        // ↓ This line creates a bindable view of `game` so `$game.*` works.
        @Bindable var game = game

        Form {
            // --- Section: Game Options ---
            Section("Game Options") {
                // Theme picker (String selection)
                Picker("Theme", selection: $game.theme) {
                    ForEach(themes, id: \.self) { theme in
                        Text(theme).tag(theme) // tag is String
                    }
                }

                // 1–2 impostors for now
                Stepper("Impostors: \(game.impostorCount)",
                        value: $game.impostorCount,
                        in: 1...2)
            }
            
            // ---Section: Hints ---
            Section {
                Toggle("Enable hints for impostors", isOn: $game.hintsEnabled)

                // Only adjustable when enabled
                Stepper("Hints per impostor: \(game.hintCount)",
                        value: $game.hintCount,
                        in: 1...3)
                    .disabled(!game.hintsEnabled)
            } header: {
                Text("Hints")
            } footer: {
                Text("Hints are decoy clues shown to impostors. Choose 1–3 hints or turn them off.")
            }

            // --- Section: Players ---
            Section("Players") {
                HStack {
                    TextField("Add player name", text: $newPlayerName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    Button("Add") { addPlayer() }
                        .disabled(newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                if game.players.isEmpty {
                    Text("No players yet. Add at least 3 to start.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(game.players) { player in
                        Text(player.name)
                    }
                    .onDelete(perform: deletePlayers)
                }
            }

            // --- Section: Continue ---
            Section {
                NavigationLink {
                    // Prepare the round (word + impostors) right before dealing
                    DealView()
                        .onAppear {
                            game.prepareNewRound()
                        }
                } label: {
                    Text("Continue")
                        .font(.headline)
                }
                .disabled(game.players.count < 3)
            } footer: {
                Text("Tip: 3–12 players is ideal. Try 1 impostor for ≤6 players, 2 for ≥7.")
            }

        }
        .navigationTitle("Setup")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset") { resetSetup() }
            }
        }
    }

    // --- Helpers ---

    private func addPlayer() {
        let trimmed = newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !game.players.contains(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            newPlayerName = ""
            return
        }
        game.players.append(Player(name: trimmed))
        newPlayerName = ""
    }

    private func deletePlayers(at offsets: IndexSet) {
        game.players.remove(atOffsets: offsets)
    }

    private func resetSetup() {
        game.players.removeAll()
        game.theme = "Animals"
        game.impostorCount = 1
        game.resetRound()
        newPlayerName = ""
    }
}

#Preview {
    NavigationStack {
        SetupView().environment(GameState())
    }
}
