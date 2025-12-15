//
//  HomeView.swift
//  Recharge
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @State private var showingLogSheet = false
    @State private var showingQuickActions = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Main Battery Display
                    BatteryDisplayView(level: viewModel.currentBatteryLevel)
                        .frame(height: 280)
                        .padding(.top)
                    
                    // Quick Status Message
                    StatusMessageView(level: viewModel.currentBatteryLevel)
                    
                    // Quick Actions
                    QuickActionsView(showingLogSheet: $showingLogSheet)
                    
                    // Today's Log
                    if !viewModel.todayEntries.isEmpty {
                        TodayLogView(entries: viewModel.todayEntries)
                    }
                    
                    // Quick Insights
                    if let firstInsight = viewModel.insights.first(where: { !$0.isPremium }) {
                        InsightCardView(insight: firstInsight)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recharge")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingLogSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                }
            }
            .sheet(isPresented: $showingLogSheet) {
                LogEntryView()
            }
        }
    }
}

struct BatteryDisplayView: View {
    let level: Int
    
    var batteryColor: Color {
        switch level {
        case 0..<20: return .red
        case 20..<40: return .orange
        case 40..<60: return .yellow
        case 60..<80: return .green
        default: return .purple
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background Circle
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                // Progress Circle
                Circle()
                    .trim(from: 0, to: CGFloat(level) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [batteryColor.opacity(0.7), batteryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: level)
                
                // Center Content
                VStack(spacing: 4) {
                    Text("\(level)%")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(batteryColor)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.caption)
                        Text("Social Battery")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .frame(width: 220, height: 220)
        }
    }
}

struct StatusMessageView: View {
    let level: Int
    
    var message: (text: String, emoji: String) {
        switch level {
        case 0..<10: return ("Critical! Need immediate recharge", "🆘")
        case 10..<25: return ("Running on empty", "🪫")
        case 25..<40: return ("Low energy, be gentle with yourself", "😔")
        case 40..<55: return ("Moderate energy", "😐")
        case 55..<70: return ("Feeling balanced", "😊")
        case 70..<85: return ("Good energy levels!", "😄")
        case 85..<95: return ("Energized and ready!", "⚡️")
        default: return ("Fully charged! 🌟", "🔋")
        }
    }
    
    var body: some View {
        HStack {
            Text(message.emoji)
                .font(.title2)
            Text(message.text)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct QuickActionsView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @Binding var showingLogSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Update")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "arrow.down.circle.fill",
                    label: "-10%",
                    color: .orange
                ) {
                    viewModel.quickUpdate(delta: -10)
                }
                
                QuickActionButton(
                    icon: "arrow.down.circle.fill",
                    label: "-25%",
                    color: .red
                ) {
                    viewModel.quickUpdate(delta: -25)
                }
                
                QuickActionButton(
                    icon: "arrow.up.circle.fill",
                    label: "+10%",
                    color: .green
                ) {
                    viewModel.quickUpdate(delta: 10)
                }
                
                QuickActionButton(
                    icon: "arrow.up.circle.fill",
                    label: "+25%",
                    color: .purple
                ) {
                    viewModel.quickUpdate(delta: 25)
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

struct TodayLogView: View {
    let entries: [BatteryEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Log")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(entries.count) entries")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(entries.suffix(3)) { entry in
                HStack {
                    if let activity = entry.activity {
                        Text(activity.icon)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(entry.level)%")
                            .font(.headline)
                        if let activity = entry.activity {
                            Text(activity.rawValue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(entry.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
        }
    }
}

struct InsightCardView: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(insight.icon)
                    .font(.title2)
                Text(insight.title)
                    .font(.headline)
                Spacer()
                if insight.isPremium {
                    Text("PRO")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
            }
            
            Text(insight.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

#Preview {
    HomeView()
        .environmentObject(BatteryViewModel())
        .environmentObject(PurchaseManager())
}
