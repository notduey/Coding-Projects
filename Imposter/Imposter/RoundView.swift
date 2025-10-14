//
//  RoundView.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: Countdown page with start/pause/reset and route to voting
//

import SwiftUI
import UIKit // for haptics
import Combine //for Timer.publish / autoconnect

struct RoundView: View {
    @Environment(GameState.self) private var game
    @Environment(Router.self) private var router

    // --- Timer state (local to this screen) ---
    @State private var duration: Int = 180            // default 3:00 (seconds)
    @State private var remaining: Int = 180
    @State private var isRunning: Bool = false
    @State private var didFireZeroHaptic = false      // prevent multiple haptics at 0

    // A simple 1-second tick using a Timer publisher
    private let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // Format seconds as M:SS
    private var formatted: String {
        let m = remaining / 60
        let s = remaining % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        VStack(spacing: 28) {
            // Theme & word (you may or may not want to show the theme here)
            Text("Theme: \(game.theme)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Big timer
            Text(formatted)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()

            // Controls
            HStack(spacing: 12) {
                Button(isRunning ? "Pause" : "Start") {
                    if remaining == 0 {
                        // If time already hit 0 and user taps start, reset first
                        resetTimer()
                    }
                    isRunning.toggle()
                    if isRunning {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") { resetTimer() }
                    .buttonStyle(.bordered)

                Spacer(minLength: 0)

                // Go to voting 
                Button("Go to Voting") {
                    router.push(.vote)
                }
                .disabled(isRunning)

            }
            .padding(.horizontal)

            // Allow time adjustment BEFORE starting
            VStack(spacing: 8) {
                Text("Adjust time before starting")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                HStack {
                    Button("-30s") { adjust(-30) }
                        .buttonStyle(.bordered)
                    Button("+30s") { adjust(+30) }
                        .buttonStyle(.bordered)
                }
            }
            .opacity(isRunning ? 0.3 : 1)      // discourage changing during run
            .allowsHitTesting(!isRunning)       // disable buttons while running

            Spacer()
        }
        .padding()
        .navigationTitle("Discussion")
        .navigationBarTitleDisplayMode(.inline)   // keeps nav height consistent
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HomeBarButton()
            }
        }
        .onAppear {
            // Ensure we sync remaining with duration when we land here
            remaining = duration
        }
        .onReceive(tick) { _ in
            guard isRunning else { return }
            if remaining > 0 {
                remaining -= 1
                if remaining == 0 {
                    isRunning = false
                    // single strong haptic at 0
                    if !didFireZeroHaptic {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        didFireZeroHaptic = true
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func adjust(_ delta: Int) {
        // clamp between 30s and 10 minutes to keep it reasonable
        duration = max(30, min(600, duration + delta))
        remaining = duration
        didFireZeroHaptic = false
    }

    private func resetTimer() {
        isRunning = false
        remaining = duration
        didFireZeroHaptic = false
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

#Preview {
    NavigationStack {
        RoundView()
            .environment({
                let mock = GameState()
                mock.theme = "Animals"
                mock.players = [Player(name: "A"), Player(name: "B"), Player(name: "C")]
                return mock
            }())
    }
}
