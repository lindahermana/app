//
//  ProfileView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showingUpgradeSheet = false
    
    var body: some View {
        NavigationView {
            List {
                // User Info Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userManager.currentUser.username)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if userManager.currentUser.isPremium {
                                HStack {
                                    Image(systemName: "crown.fill")
                                    Text("Premium Member")
                                }
                                .font(.caption)
                                .foregroundColor(.yellow)
                            } else {
                                Text("Free Account")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                // Stats Section
                Section(header: Text("Statistics")) {
                    StatRow(icon: "checkmark.circle.fill", title: "Total Decisions", value: "\(userManager.currentUser.decisionsCreated)")
                    StatRow(icon: "calendar", title: "This Month", value: "\(userManager.currentUser.decisionsThisMonth)")
                    
                    if !userManager.currentUser.isPremium {
                        StatRow(
                            icon: "hourglass",
                            title: "Remaining",
                            value: "\(userManager.currentUser.remainingDecisions)/10"
                        )
                    }
                    
                    StatRow(icon: "clock.fill", title: "Member Since", value: memberSince)
                }
                
                // Premium Section
                if !userManager.currentUser.isPremium {
                    Section(header: Text("Upgrade")) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                Text("Split Decision Premium")
                                    .font(.headline)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                FeatureRow(text: "Unlimited decisions")
                                FeatureRow(text: "Private polls")
                                FeatureRow(text: "Advanced analytics")
                                FeatureRow(text: "Custom themes")
                                FeatureRow(text: "No ads")
                            }
                            .font(.subheadline)
                            
                            Button(action: {
                                showingUpgradeSheet = true
                            }) {
                                Text("Upgrade Now")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Settings Section
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock.fill")
                    }
                    NavigationLink(destination: Text("About")) {
                        Label("About", systemImage: "info.circle.fill")
                    }
                }
                
                // Support Section
                Section(header: Text("Support")) {
                    Link(destination: URL(string: "https://splitdecision.app/help")!) {
                        Label("Help Center", systemImage: "questionmark.circle.fill")
                    }
                    Link(destination: URL(string: "https://splitdecision.app/contact")!) {
                        Label("Contact Us", systemImage: "envelope.fill")
                    }
                }
                
                // Version
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingUpgradeSheet) {
                PremiumUpgradeView()
            }
        }
    }
    
    var memberSince: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: userManager.currentUser.joinedAt)
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
        }
    }
}
