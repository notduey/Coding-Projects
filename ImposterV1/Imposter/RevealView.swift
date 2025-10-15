//
//  RevealView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//  Purpose: Shows whether the voted player was an impostor, reveals everyone,
//  shows the secret word, and offers “Play again” or “Change setup”.
//

import SwiftUI
import UIKit

struct RevealView: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router

    let votedPlayer: Player

    // Convenience
    private var wasImpostor: Bool { votedPlayer.isImpostor }
    private var impostorNames: String {
        game.players.filter(\.isImpostor).map(\.name).joined(separator: ", ")
    }

    var body: some View {
        VStack(spacing: 20) {
            // Result headline
            Text(wasImpostor ? "Correct! 🎉" : "Wrong 🫣")
                .font(.largeTitle.bold())
                .foregroundStyle(wasImpostor ? .green : .red)

            Text("You voted: \(votedPlayer.name)")
                .font(.title3)

            Group {
                if wasImpostor {
                    Text("\(votedPlayer.name) **was** an impostor.")
                } else {
                    Text("\(votedPlayer.name) **was not** an impostor.")
                }
            }
            .font(.title3)
            .padding(.bottom, 4)

            // Reveal details
            VStack(spacing: 8) {
                Text("Secret word: **\(game.secretWord)**")
                Text("Impostor\(impostorNames.contains(",") ? "s" : ""): **\(impostorNames)**")
            }
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.vertical, 6)

            Spacer()

            // Play again → clear history, then push Deal with forward animation
            Button {
                game.prepareNewRound()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                router.restartForward(to: .deal)
            } label: {
                Text("Play again")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(.blue))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)

            // Change options → forward-animate to Setup on a clean stack
            Button("Change setup (players / rules)") {
                router.restartForward(to: .setup)
            }
            .padding(.top, 4)
        }
        .padding()
        // .navigationTitle("Reveal")                 // REMOVE
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden)
        .safeAreaInset(edge: .top) {
            AppHeader(title: "Reveal", showBack: true)
        }
        .onAppear {
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(wasImpostor ? .success : .error)
        }
    }
}

#Preview {
    let mock = GameState()
    mock.secretWord = "Banana"
    mock.players = [Player(name: "Alice"), Player(name: "Bob"), Player(name: "Carol")]
    mock.players[1].isImpostor = true

    let router = Router()
    let path = NavigationPath()

    return NavigationStack(path: .constant(path)) {
        RevealView(votedPlayer: mock.players[1])
            .environment(mock)
            .environment(router)
    }
}
