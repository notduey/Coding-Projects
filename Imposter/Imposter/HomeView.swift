//
//  HomeView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//  Purpose: Starter page that players can start a game on or read how to play.
//

import SwiftUI

struct HomeView: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router

    var body: some View {
        VStack(spacing: 24) {
            // App title is in the header; this is the hero text
            Text("Party game: most players see the secret word—impostors don’t.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            // Start button → Setup
            Button {
                router.push(.setup)
            } label: {
                Text("New Game")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(.blue))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)

            // How to Play (push a simple screen with its own AppHeader)
            Button("How to Play") {
                router.push(.howToPlay)   // <-- add this route (see note below)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .toolbar(.hidden)  // hide the system nav bar everywhere in this view
        .safeAreaInset(edge: .top) {
            AppHeader(title: "ImpostorWord", showBack: false) // custom header
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(GameState())
            .environment(Router())
    }
}
