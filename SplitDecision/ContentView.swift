//
//  ContentView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var decisionManager: DecisionManager
    @EnvironmentObject var userManager: UserManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CreateDecisionView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DecisionManager())
            .environmentObject(UserManager())
    }
}
