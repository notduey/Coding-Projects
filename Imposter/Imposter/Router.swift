//
//  Router.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: controls the stack history and etc
//

import SwiftUI

@Observable
final class Router {
    var path = NavigationPath()

    enum Route: Hashable {
        case setup
        case deal
        case round
        case vote
        case reveal(votedID: UUID?)  // Player.ID is UUID in your model
        case howToPlay
    }

    func push(_ route: Route) {
        withAnimation(.easeInOut) { path.append(route) }
    }

    func popToRoot() {
        withAnimation(.easeInOut) { path = NavigationPath() }
    }

    /// Replace stack with specific routes (e.g., start fresh at .deal)
    func replace(with routes: [Route]) {
        var new = NavigationPath()
        for r in routes { new.append(r) }
        withAnimation(.easeInOut) { path = new }
    }
    
    func restartForward(to route: Route) {
        withTransaction(Transaction(animation: nil)) { path = NavigationPath() } // clear no anim
        withAnimation(.easeInOut) { path.append(route) }                         // forward push
    }
    
    func pop() {
        if !path.isEmpty { path.removeLast() }
    }
}
