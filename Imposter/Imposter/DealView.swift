//
//  DealView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: One Phone mode. Each player secretly sees their role/word.
//Reveal starts after user presses and holds on the card.
//Card hides when they release, haptic feedback plays when the card appears.
//

import SwiftUI
import UIKit // for haptics

struct DealView: View {
    @Environment(GameState.self) private var game

    // Index of the player currently viewing their card
    @State private var currentIndex: Int = 0
    // Whether the current player's card is visible right now
    @State private var showingCard: Bool = false
    // Whether this player has successfully revealed at least once
    @State private var hasSeenCard: Bool = false

    var body: some View {
        VStack(spacing: 28) {
            if currentIndex < game.players.count {
                let player = game.players[currentIndex]

                // Progress + current player's name
                Text("Player \(currentIndex + 1) of \(game.players.count)")
                    .font(.headline)

                Text(player.name)
                    .font(.largeTitle.bold())

                // --- CARD AREA ---
                ZStack {
                    // Base card background (changes tint when revealed)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(showingCard ? .green.opacity(0.3) : .gray.opacity(0.18))
                        .frame(width: 260, height: 160)
                        .shadow(radius: 4)

                    // Content switches between instruction and the secret
                    if showingCard {
                        // If impostor -> ??? otherwise secret word
                        Text(player.isImpostor ? "???" : game.secretWord)
                            .font(.title)
                            .fontWeight(.semibold)
                            .transition(.scale)
                    } else {
                        VStack(spacing: 8) {
                            Text("Press & hold to reveal")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text("Release to hide")
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                // Attach two gestures:
                // 1) LongPress starts the reveal (after 0.5s), fires a haptic once.
                // 2) A zero-distance Drag ends when the finger lifts, which hides the card.
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            // Only trigger when it wasn't already showing (prevents duplicate haptics)
                            if !showingCard {
                                showingCard = true
                                hasSeenCard = true
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            // Lifting the finger should hide the card instantly
                            if showingCard {
                                showingCard = false
                            }
                        }
                )

                // --- CONTROLS ---
                // Next player is only enabled AFTER the player has successfully revealed once
                Button {
                    // Reset per-player reveal flags and move on
                    showingCard = false
                    hasSeenCard = false
                    currentIndex += 1
                } label: {
                    Text("Next player")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14)
                            .fill(hasSeenCard && !showingCard ? .blue : .gray.opacity(0.4)))
                        .foregroundStyle(.white)
                }
                .disabled(!(hasSeenCard && !showingCard))
                .padding(.horizontal)

                // Tiny tip to reduce accidental peeking
                Text("Hand the phone flat to each player. Don’t tap—hold the card.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

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
    // Preview with a sample impostor to see "???"
    let mock = GameState()
    mock.secretWord = "Banana"
    mock.players = [Player(name: "Alice"), Player(name: "Bob"), Player(name: "Carol")]
    mock.players[1].isImpostor = true
    return NavigationStack { DealView().environment(mock) }
}
