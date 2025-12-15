//
//  SplitDecisionApp.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

@main
struct SplitDecisionApp: App {
    @StateObject private var decisionManager = DecisionManager()
    @StateObject private var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(decisionManager)
                .environmentObject(userManager)
        }
    }
}
