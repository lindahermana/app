//
//  HistoryView.swift
//  Recharge
//

import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Chart
                    ChartSection(viewModel: viewModel)
                    
                    // Weekly Stats
                    if let stats = viewModel.weeklyStats {
                        WeeklyStatsSection(stats: stats)
                    }
                    
                    // Insights Section
                    InsightsSection(insights: viewModel.insights, isPremium: purchaseManager.isPremium)
                    
                    // Upgrade CTA for non-premium
                    if !purchaseManager.isPremium {
                        PremiumUpgradeCard()
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Insights")
        }
    }
}

struct ChartSection: View {
    @ObservedObject var viewModel: BatteryViewModel
    
    var chartData: [(date: Date, level: Int)] {
        viewModel.getLast30DaysData().map { ($0.0, $0.1) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Battery Trend")
                .font(.headline)
            
            if #available(iOS 16.0, *) {
                Chart(chartData, id: \.date) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Level", item.level)
                    )
                    .foregroundStyle(Color.purple.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("Level", item.level)
                    )
                    .foregroundStyle(Color.purple.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
                .chartYScale(domain: 0...100)
                .chartYAxis {
                    AxisMarks(values: [0, 25, 50, 75, 100])
                }
                .frame(height: 200)
            } else {
                // Fallback for iOS 15
                Text("Upgrade to iOS 16 for charts")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct WeeklyStatsSection: View {
    let stats: WeeklyStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatCard(
                    title: "Average",
                    value: "\(stats.averageBatteryLevel)%",
                    icon: "chart.bar.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Streak",
                    value: "\(stats.streak) days",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Entries",
                    value: "\(stats.totalEntries)",
                    icon: "list.bullet",
                    color: .green
                )
                
                StatCard(
                    title: "Low Days",
                    value: "\(stats.lowBatteryDays)",
                    icon: "battery.25",
                    color: .red
                )
            }
            
            if let draining = stats.mostDrainingActivity {
                HStack {
                    Text("Most draining:")
                        .foregroundColor(.secondary)
                    Text("\(draining.icon) \(draining.rawValue)")
                        .fontWeight(.medium)
                }
                .font(.subheadline)
            }
            
            if let recharging = stats.mostRechargingActivity {
                HStack {
                    Text("Best for recharge:")
                        .foregroundColor(.secondary)
                    Text("\(recharging.icon) \(recharging.rawValue)")
                        .fontWeight(.medium)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InsightsSection: View {
    let insights: [Insight]
    let isPremium: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Insights")
                    .font(.headline)
                Spacer()
                if !isPremium {
                    Text("🔒 Unlock all with PRO")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
            
            ForEach(insights) { insight in
                if !insight.isPremium || isPremium {
                    InsightCardView(insight: insight)
                } else {
                    LockedInsightCard(insight: insight)
                }
            }
        }
    }
}

struct LockedInsightCard: View {
    let insight: Insight
    
    var body: some View {
        HStack {
            Text(insight.icon)
                .font(.title2)
                .opacity(0.5)
            
            VStack(alignment: .leading) {
                Text(insight.title)
                    .font(.headline)
                    .opacity(0.5)
                Text("Unlock with Premium")
                    .font(.caption)
                    .foregroundColor(.purple)
            }
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .foregroundColor(.purple)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PremiumUpgradeCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("✨ Unlock Premium")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Get personalized insights, unlimited history, and more!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            NavigationLink(destination: PremiumView()) {
                Text("Learn More")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.purple)
                    .cornerRadius(25)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

#Preview {
    HistoryView()
        .environmentObject(BatteryViewModel())
        .environmentObject(PurchaseManager())
}
