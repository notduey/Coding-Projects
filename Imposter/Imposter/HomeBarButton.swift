//
//  HomeBarButton.swift
//  Imposter
//
//  Created by Duy Tran on 10/14/25.
//
//Purpose: pins home button to top right
//

import SwiftUI

struct HomeBarButton: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router
    @State private var confirm = false

    var body: some View {
        Button { confirm = true } label: {
            // Use a fixed-size symbol instead of a text font to avoid scaling/blur
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)              // fixed size = no growth
                .symbolRenderingMode(.monochrome)          // stable rendering
        }
        // Prevent default toolbar content transitions (iOS 17+)
        .contentTransition(.identity)
        // Also remove any implicit animations on this control
        .transaction { t in t.animation = nil }

        .accessibilityLabel("Home")
        .confirmationDialog("Return to Home?", isPresented: $confirm, titleVisibility: .visible) {
            Button("Go Home", role: .destructive) {
                game.resetRound()
                router.popToRoot()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
