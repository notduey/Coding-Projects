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
    @Environment(GameState.self) private var game

    var body: some View {
        VStack(spacing: 24) {
            // App title
            Text("ImpostorWord")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Party game: most players see the secret word—impostors don’t.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            // Start button → SetupView
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

            // How to Play
            NavigationLink("How to Play") {
                Text("Explain rules here (coming soon).")
                    .padding()
                    .navigationTitle("How to Play")
                    // do NOT hide back here; we want to be able to return to Home
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true) // keep Home clean (no back arrow at root)
    }
}

#Preview {
    // Preview needs its own stack, but the real app will provide it at the root.
    NavigationStack { HomeView().environment(GameState()) }
}
