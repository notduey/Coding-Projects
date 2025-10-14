//
//  VoteView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: one imposter is selected and then confirmed
//

import SwiftUI

struct VoteView: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router

    // Local UI state: which player is currently selected to eliminate
    @State private var selectedID: Player.ID?
    // For navigation to Reveal after confirm
    @State private var goToReveal = false
    // Cache the selected Player for the next screen
    @State private var selectedPlayer: Player?

    var body: some View {
        VStack(spacing: 12) {
            List(selection: $selectedID) {
                Section("Tap who you think is the impostor") {
                    // We display all players; you select exactly one.
                    ForEach(game.players) { p in
                        HStack {
                            Text(p.name)
                            Spacer()
                            if selectedID == p.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                            }
                        }
                        .contentShape(Rectangle())        // Make the whole row tappable
                        .onTapGesture { selectedID = p.id }
                    }
                }
            }
            .listStyle(.insetGrouped)

            // Confirm section
            Button {
                if let id = selectedID {
                    router.push(.reveal(votedID: id))
                }
            } label: {
                Text("Confirm vote")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(selectedID == nil ? .gray.opacity(0.4) : .blue))
                    .foregroundStyle(.white)
            }
            .disabled(selectedID == nil)
            .padding(.horizontal)
        }
        .navigationTitle("Voting")
        .navigationBarTitleDisplayMode(.inline)   // keeps nav height consistent
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HomeBarButton()
            }
        }
    }
}

#Preview {
    let mock = GameState()
    mock.secretWord = "Banana"
    mock.players = [Player(name: "Alice"), Player(name: "Bob"), Player(name: "Carol")]
    mock.players[1].isImpostor = true
    return NavigationStack { VoteView().environment(mock) }
}
