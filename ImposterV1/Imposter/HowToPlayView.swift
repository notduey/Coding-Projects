//
//  HowToPlayView.swift
//  Imposter
//
//  Created by Duy Tran on 10/14/25.
//
//Purpose: how to play
//

import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("How to Play")
                    .font(.title2.bold())
                Text("• Everyone except the impostor(s) sees the secret word.")
                Text("• Take turns giving a short clue. Don’t be too obvious!")
                Text("• After a few rounds of clues, vote for who you think is an impostor.")
                Text("• If you eliminate all impostors, the others win. Otherwise, impostors win.")
            }
            .padding()
        }
        .toolbar(.hidden)
        .safeAreaInset(edge: .top) {
            AppHeader(title: "How to Play", showBack: true)
        }
    }
}

