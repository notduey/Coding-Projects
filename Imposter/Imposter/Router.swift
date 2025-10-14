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
    // Holds the nav history for the whole app
    var path = NavigationPath()
    
    // Pop everything → back to Home (right-swipe animation)
    func popToRoot() {
        withAnimation(.easeInOut) {
            path = NavigationPath()
        }
    }
}
