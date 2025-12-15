//
//  SettingsView.swift
//  Recharge
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showingOnboarding = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    NavigationLink(destination: ProfileSettingsView()) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                Text(viewModel.userProfile.personalityType.icon)
                                    .font(.title)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.userProfile.name.isEmpty ? "Set Your Name" : viewModel.userProfile.name)
                                    .font(.headline)
                                Text(viewModel.userProfile.personalityType.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Premium Section
                Section {
                    if purchaseManager.isPremium {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Premium Active")
                                .fontWeight(.medium)
                            Spacer()
                            Text("✓")
                                .foregroundColor(.green)
                        }
                    } else {
                        NavigationLink(destination: PremiumView()) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.purple)
                                Text("Upgrade to Premium")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("✨")
                            }
                        }
                    }
                } header: {
                    Text("Subscription")
                }
                
                // Notifications
                Section {
                    Toggle(isOn: $viewModel.userProfile.notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Notifications")
                        }
                    }
                    .onChange(of: viewModel.userProfile.notificationsEnabled) { _ in
                        viewModel.saveData()
                    }
                    
                    NavigationLink(destination: NotificationSettingsView()) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("Reminder Schedule")
                        }
                    }
                } header: {
                    Text("Notifications")
                }
                
                // Data
                Section {
                    NavigationLink(destination: DataExportView()) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.green)
                            Text("Export Data")
                        }
                    }
                    
                    Button(action: { }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.blue)
                            Text("Restore Purchases")
                        }
                    }
                } header: {
                    Text("Data & Purchases")
                }
                
                // About
                Section {
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.purple)
                            Text("About Recharge")
                        }
                    }
                    
                    Link(destination: URL(string: "https://recharge-app.com/privacy")!) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.gray)
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://recharge-app.com/terms")!) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.gray)
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: { showingOnboarding = true }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.purple)
                            Text("How to Use")
                        }
                    }
                } header: {
                    Text("About")
                }
                
                // App Info
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                } footer: {
                    Text("Made with 💜 for introverts, ambiverts, and extroverts everywhere.")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingOnboarding) {
                OnboardingView()
            }
        }
    }
}

struct ProfileSettingsView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @State private var name: String = ""
    @State private var selectedType: PersonalityType = .ambivert
    @State private var dailyGoal: Double = 50
    
    var body: some View {
        Form {
            Section {
                TextField("Your Name", text: $name)
            } header: {
                Text("Name")
            }
            
            Section {
                Picker("Personality Type", selection: $selectedType) {
                    ForEach(PersonalityType.allCases, id: \.self) { type in
                        HStack {
                            Text(type.icon)
                            Text(type.rawValue)
                        }
                        .tag(type)
                    }
                }
                
                Text(selectedType.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Personality")
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Target: \(Int(dailyGoal))%")
                    Slider(value: $dailyGoal, in: 30...90, step: 5)
                }
            } header: {
                Text("Daily Battery Goal")
            } footer: {
                Text("We'll notify you if your battery drops below this level")
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            name = viewModel.userProfile.name
            selectedType = viewModel.userProfile.personalityType
            dailyGoal = Double(viewModel.userProfile.dailyGoal)
        }
        .onDisappear {
            viewModel.userProfile.name = name
            viewModel.userProfile.personalityType = selectedType
            viewModel.userProfile.dailyGoal = Int(dailyGoal)
            viewModel.saveData()
        }
    }
}

struct NotificationSettingsView: View {
    @State private var morningReminder = true
    @State private var eveningReminder = true
    @State private var morningTime = Date()
    @State private var eveningTime = Date()
    @State private var lowBatteryAlerts = true
    
    var body: some View {
        Form {
            Section {
                Toggle("Morning Check-in", isOn: $morningReminder)
                if morningReminder {
                    DatePicker("Time", selection: $morningTime, displayedComponents: .hourAndMinute)
                }
            } header: {
                Text("Morning Reminder")
            }
            
            Section {
                Toggle("Evening Reflection", isOn: $eveningReminder)
                if eveningReminder {
                    DatePicker("Time", selection: $eveningTime, displayedComponents: .hourAndMinute)
                }
            } header: {
                Text("Evening Reminder")
            }
            
            Section {
                Toggle("Low Battery Alerts", isOn: $lowBatteryAlerts)
            } header: {
                Text("Smart Alerts")
            } footer: {
                Text("Get notified when your battery drops below your target level")
            }
        }
        .navigationTitle("Reminders")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataExportView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        VStack(spacing: 24) {
            if purchaseManager.isPremium {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Export Your Data")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Download all your battery entries as a CSV file")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button(action: { }) {
                    Text("Export as CSV")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Premium Feature")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Upgrade to Premium to export your data")
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: PremiumView()) {
                    Text("Upgrade Now")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.top, 60)
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "battery.100.bolt")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                Text("Recharge")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Social Battery Tracker")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text("Track your energy, understand your patterns, and live a more balanced life.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "battery.100", title: "Track Your Battery", description: "Log your social energy throughout the day")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Discover Patterns", description: "See what drains and recharges you")
                    FeatureRow(icon: "lightbulb.fill", title: "Get Insights", description: "Personalized recommendations for your personality type")
                    FeatureRow(icon: "bell.fill", title: "Smart Reminders", description: "Stay on top of your energy levels")
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(BatteryViewModel())
        .environmentObject(PurchaseManager())
}
