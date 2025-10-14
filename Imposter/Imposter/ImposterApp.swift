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
            }
            //apply environments to the NavigationStack itself
            .environment(game)
            .environment(router)
        }
    }
}
