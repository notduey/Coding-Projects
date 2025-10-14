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
    // One shared instance for the whole app lifetime.
    // @State here makes SwiftUI keep it alive across view updates.
    @State private var game = GameState()

    var body: some Scene {
        WindowGroup {
            // Home is the first screen. We pass `game` down via environment.
            HomeView()
                .environment(game)
        }
    }
}
