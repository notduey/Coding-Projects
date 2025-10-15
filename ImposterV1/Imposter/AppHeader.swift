//
//  AppHeader.swift
//  Imposter
//
//  Created by Duy Tran on 10/14/25.
//
//Purpose: header that slides with page transition
//

import SwiftUI

/// A custom header that lives inside your page content,
/// so it animates with the page (slides with push/pop).
struct AppHeader: View {
    var title: String
    var showBack: Bool = true          // hide on Home, show on most others

    @Environment(Router.self) private var router
    @Environment(GameState.self) private var game
    @State private var showHomeConfirm = false

    var body: some View {
        HStack(spacing: 12) {
            // Back arrow (optional)
            if showBack {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                }
                .accessibilityLabel("Back")
            }

            // Title (inline style)
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            // Home (fixed top-right)
            Button {
                showHomeConfirm = true
            } label: {
                Image(systemName: "house.fill")
                    .font(.system(size: 18, weight: .semibold))
            }
            .accessibilityLabel("Home")
            .confirmationDialog("Return to Home?", isPresented: $showHomeConfirm, titleVisibility: .visible) {
                Button("Go Home", role: .destructive) {
                    game.resetRound()
                    router.popToRoot()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        // optional separator feel
        .background(.ultraThinMaterial)
    }
}

