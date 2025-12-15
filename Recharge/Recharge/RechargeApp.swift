//
//  RechargeApp.swift
//  Recharge - Social Battery Tracker
//
//  Track your social energy levels and discover your patterns
//

import SwiftUI

@main
struct RechargeApp: App {
    @StateObject private var batteryViewModel = BatteryViewModel()
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(batteryViewModel)
                .environmentObject(purchaseManager)
        }
    }
}
