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
import UIKit

struct DealView: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router

    // State for dealing flow
    @State private var currentIndex: Int = 0
    @State private var showingCard: Bool = false
    @State private var hasSeenCard: Bool = false

    var body: some View {
        VStack(spacing: 28) {
            if currentIndex < game.players.count {
                let player = game.players[currentIndex]

                Text("Player \(currentIndex + 1) of \(game.players.count)")
                    .font(.headline)

                Text(player.name)
                    .font(.largeTitle.bold())

                // --- CARD ---
                ZStack {
                    let isImp = player.isImpostor

                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            showingCard
                            ? (isImp ? .red.opacity(0.25) : .green.opacity(0.30))
                            : .gray.opacity(0.18)
                        )
                        .frame(width: 260, height: 160)
                        .shadow(radius: 4)

                    if showingCard {
                        if isImp {
                            VStack(spacing: 6) {
                                Text("Imposter")
                                    .font(.title.weight(.bold))
                                    .foregroundStyle(.red)

                                if game.hintsEnabled, !game.impostorHints.isEmpty {
                                    Text("Hint: \(game.impostorHints.joined(separator: ", "))")
                                        .font(.footnote.weight(.semibold))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.secondary)
                                        .transition(.opacity)
                                }
                            }
                            .transition(.scale)
                        } else {
                            Text(game.secretWord)
                                .font(.title)
                                .fontWeight(.semibold)
                                .transition(.scale)
                        }
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
                // Gestures: long-press to reveal (with haptic), drag end to hide on lift
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
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
                            if showingCard { showingCard = false }
                        }
                )

                // Next button appears only after the player has revealed and lifted
                if hasSeenCard && !showingCard {
                    Button {
                        showingCard = false
                        hasSeenCard = false
                        currentIndex += 1
                    } label: {
                        Text("Next player")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 14).fill(.blue))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Text("Hand the phone flat to each player. Press & hold; release to hide.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

            } else {
                // All players have seen their cards
                VStack(spacing: 16) {
                    Text("All cards dealt!")
                        .font(.title2.bold())
                    Button("Start Round") {
                        router.push(.round)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        // Haptic when the Next button first appears (false -> true)
        .onChange(of: hasSeenCard && !showingCard, initial: false) { oldValue, newValue in
            if newValue && !oldValue {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
        .animation(.easeInOut, value: showingCard)
        .animation(.easeInOut, value: hasSeenCard)
        .padding()
        // .navigationTitle("Deal Cards")            // REMOVE
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden)                             // hide system toolbar/nav bar
        .safeAreaInset(edge: .top) {
            AppHeader(title: "Deal Cards", showBack: true)   // back + home, fixed position, slides with page
        }
    }
}

#Preview {
    // Preview with a sample impostor to see the red card
    let mock = GameState()
    mock.secretWord = "Banana"
    mock.hintsEnabled = true
    mock.impostorHints = ["Honey", "Hive"]
    mock.players = [Player(name: "Alice"), Player(name: "Bob"), Player(name: "Carol")]
    mock.players[1].isImpostor = true

    let router = Router()
    let path = NavigationPath()   // ← add this line

    return NavigationStack(path: .constant(path)) {   // ← wrap path in .constant safely
        DealView()
            .environment(mock)
            .environment(router)
    }
}
