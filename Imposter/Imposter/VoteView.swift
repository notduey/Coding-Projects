//
//  VoteView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Placeholder
//

import SwiftUI

struct VoteView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        List {
            Section("Tap who you think is the impostor") {
                ForEach(game.players) { p in
                    Text(p.name)
                }
            }
        }
        .navigationTitle("Voting (placeholder)")
    }
}

#Preview {
    let mock = GameState()
    mock.players = [Player(name: "Alice"), Player(name: "Bob"), Player(name: "Carol")]
    return NavigationStack { VoteView().environment(mock) }
}
