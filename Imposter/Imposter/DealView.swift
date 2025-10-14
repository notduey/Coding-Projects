//
//  DealView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: One Phone mode. Each player secretly sees their role/word
//

import SwiftUI

struct DealView: View {
    @Environment(GameState.self) private var game

    // Index of the player currently viewing their card
    @State private var currentIndex: Int = 0
    // Whether the current player's card is visible
    @State private var showingCard: Bool = false

    var body: some View {
        VStack(spacing: 32) {
            if currentIndex < game.players.count {
                let player = game.players[currentIndex]

                // Progress + current player's name
                Text("Player \(currentIndex + 1) of \(game.players.count)")
                    .font(.headline)

                Text(player.name)
                    .font(.largeTitle.bold())

                // Card area (either "???" for impostor or the secret word)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(showingCard ? .green.opacity(0.3) : .gray.opacity(0.2))
                        .frame(width: 250, height: 150)
                        .shadow(radius: 4)

                    if showingCard {
                        // If the player is an impostor, show ???, otherwise show the secret word
                        Text(player.isImpostor ? "???" : game.secretWord)
                            .font(.title)
                            .fontWeight(.semibold)
                            .transition(.scale)
                    } else {
                        Text("Tap 'Show my card'")
                            .foregroundStyle(.secondary)
                    }
                }

                // Controls: either show the card, or proceed to next player
                if showingCard {
                    // After reading, the player taps "Next player" and passes the phone
                    Button {
                        // Hide current card and advance to the next player
                        showingCard = false
                        currentIndex += 1
                    } label: {
                        Text("Next player")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 14).fill(.blue))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                } else {
                    Button("Show my card") {
                        showingCard = true
                    }
                    .buttonStyle(.borderedProminent)
                }

            } else {
                // All players have seen their cards
                VStack(spacing: 16) {
                    Text("All cards dealt!")
                        .font(.title2.bold())
                    NavigationLink("Start Round") {
                        // Placeholder until we build RoundView next
                        Text("Round view coming next step.")
                            .font(.title3)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .animation(.easeInOut, value: showingCard)
        .padding()
        .navigationTitle("Deal Cards")
    }
}

#Preview {
    // Preview with one impostor so you can see "???"
    let mock = GameState()
    mock.secretWord = "Banana"
    mock.players = [Player(name: "Alice"), Player(name: "Bob"), Player(name: "Carol")]
    mock.players[1].isImpostor = true
    return NavigationStack { DealView().environment(mock) }
}
