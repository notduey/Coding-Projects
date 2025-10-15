//
//  ImposterApp.swift
//  Imposter
//
//  Created by Duy Tran on 10/12/25.
//
//Purpose: App entry point. Creates a shared GameState for all screens
//

import SwiftUI

@main
struct ImpostorWordApp: App {
    @State private var game = GameState()
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeView()
                    .navigationDestination(for: Router.Route.self) { route in
                        switch route {
                        case .setup:
                            SetupView()
                        case .deal:
                            DealView()
                        case .round:
                            RoundView()
                        case .vote:
                            VoteView()
                        case .reveal(let id):
                            if let id, let p = game.players.first(where: { $0.id == id }) {
                                RevealView(votedPlayer: p)
                            } else {
                                RevealView(votedPlayer: game.players.first!)
                            }
                        case .howToPlay:
                            HowToPlayView()
                        }
                    }
            }
            .environment(game)     // attach environments to the stack itself
            .environment(router)
        }
    }
}
