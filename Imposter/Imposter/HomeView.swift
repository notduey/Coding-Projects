//
//  HomeView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: Starter page that players can start game on or click how to play
//

import SwiftUI

struct HomeView: View {
    // Read shared game state if needed (not much needed here yet).
    @Environment(GameState.self) private var game

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // App title
                Text("ImpostorWord")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Party game: most players see the secret word—impostors don’t.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                // Start button → goes to SetupView.
                NavigationLink {
                    SetupView()
                } label: {
                    Text("New Game")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(.blue))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)

                // Simple "How to Play" link (we’ll fill this later).
                NavigationLink("How to Play") {
                    Text("Explain rules here (coming soon).")
                        .padding()
                        .navigationTitle("How to Play")
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView().environment(GameState())
}
