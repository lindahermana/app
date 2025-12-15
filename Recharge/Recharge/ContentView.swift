//
//  ContentView.swift
//  Recharge
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var batteryViewModel: BatteryViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "battery.100")
                    Text("Battery")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Insights")
                }
                .tag(1)
            
            RechargeActivitiesView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("Recharge")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
        .environmentObject(BatteryViewModel())
        .environmentObject(PurchaseManager())
}
