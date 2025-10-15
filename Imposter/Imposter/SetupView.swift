//
//  SetupView.swift
//  Imposter
//
//  Purpose: Host picks theme, number of impostors, hints options, and adds player names
//

import SwiftUI

struct SetupView: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router

    @State private var newPlayerName: String = ""
    private let themes = ["Animals", "Food", "Jobs", "Places", "Random"]

    var body: some View {
        // Bindable alias so $game.* works in Pickers/Steppers
        @Bindable var game = game

        Form {
            // --- Section: Game Options ---
            Section("Game Options") {
                Picker("Theme", selection: $game.theme) {
                    ForEach(themes, id: \.self) { theme in
                        Text(theme).tag(theme)
                    }
                }

                Stepper("Impostors: \(game.impostorCount)",
                        value: $game.impostorCount,
                        in: 1...2)
            }

            // --- Section: Hints ---
            Section {
                Toggle("Enable hints for impostors", isOn: $game.hintsEnabled)

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

            // --- Section: Actions ---
            Section {
                Button {
                    game.prepareNewRound()
                    router.push(.deal)      // go to DealView
                } label: {
                    Text("Continue").font(.headline)
                }
                .disabled(game.players.count < 3)

                Button(role: .destructive) {
                    resetSetup()
                } label: {
                    Text("Reset Setup")
                }
            } footer: {
                Text("Tip: 3–12 players is ideal. Try 1 impostor for ≤7 players, 2 for ≥8.")
            }
        }
        // Hide system nav bar; use custom header that slides with the page
        .toolbar(.hidden)
        .safeAreaInset(edge: .top) {
            AppHeader(title: "Setup", showBack: true)
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
        game.hintsEnabled = true
        game.hintCount = 1
        game.resetRound()
        newPlayerName = ""
    }
}

#Preview {
    NavigationStack {
        SetupView()
            .environment(GameState())
            .environment(Router())
    }
}
