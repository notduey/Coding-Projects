//
//  HomeButton.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: home button so user can go back to home screen whenever
//

import SwiftUI

struct HomeButton: View {
    @Environment(Router.self) private var router
    @Environment(GameState.self) private var game
    @State private var confirm = false

    var body: some View {
        Button {
            confirm = true
        } label: {
            Image(systemName: "house.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(10)
                .background(Circle().fill(Color.blue))
                .shadow(radius: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Home")
        .alert("Return to Home?", isPresented: $confirm) {
            Button("Cancel", role: .cancel) {}
            Button("Go Home", role: .destructive) {
                // optional: clear round state
                game.resetRound()
                // pop to root with rightward animation
                router.popToRoot()
            }
        } message: {
            Text("This will end the current game.")
        }
    }
}
