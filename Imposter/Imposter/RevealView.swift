//
//  RevealView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: show whether the voted player was an imposter, reveals all, shows the word.
//offer to play again or go back
//

import SwiftUI
import UIKit

struct RevealView: View {
    @Environment(GameState.self) private var game

    let votedPlayer: Player

    private var wasImpostor: Bool { votedPlayer.isImpostor }
    private var impostorNames: String {
        let names = game.players.filter { $0.isImpostor }.map(\.name)
        return names.joined(separator: ", ")
    }

    @State private var goDealAgain = false   // navigate to DealView for new round

    var body: some View {
        VStack(spacing: 20) {
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

            // Reveal info
            VStack(spacing: 8) {
                Text("Secret word: **\(game.secretWord)**")
                Text("Impostor\(impostorNames.contains(",") ? "s" : ""): **\(impostorNames)**")
            }
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.vertical, 6)

            Spacer()

            // Play again → set up a fresh round and go deal cards
            Button {
                // New round with same players/options
                game.prepareNewRound()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                goDealAgain = true
            } label: {
                Text("Play again")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(.blue))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)

            // Option to change options (back to Setup)
            NavigationLink("Change setup (players / rules)") {
                SetupView()
            }
            .padding(.top, 4)
        }
        .padding()
        .navigationTitle("Reveal")
        // Navigate to deal cards for the new round
        .navigationDestination(isPresented: $goDealAgain) {
            DealView()
        }
        .onAppear {
            // fun haptic note when result shows
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
    return NavigationStack {
        RevealView(votedPlayer: mock.players[1]).environment(mock)
    }
}
