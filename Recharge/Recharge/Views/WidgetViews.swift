//
//  WidgetViews.swift
//  Recharge
//
//  Widget support for iOS Home Screen and Lock Screen
//

import SwiftUI
import WidgetKit

// MARK: - Widget Entry
struct BatteryWidgetEntry: TimelineEntry {
    let date: Date
    let batteryLevel: Int
    let lastActivity: SocialActivity?
}

// MARK: - Small Widget View
struct SmallWidgetView: View {
    let entry: BatteryWidgetEntry
    
    var batteryColor: Color {
        switch entry.batteryLevel {
        case 0..<20: return .red
        case 20..<40: return .orange
        case 40..<60: return .yellow
        case 60..<80: return .green
        default: return .purple
        }
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(.systemBackground))
            
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(entry.batteryLevel) / 100)
                        .stroke(batteryColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(entry.batteryLevel)%")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(batteryColor)
                }
                
                Text("Social Battery")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Medium Widget View
struct MediumWidgetView: View {
    let entry: BatteryWidgetEntry
    
    var batteryColor: Color {
        switch entry.batteryLevel {
        case 0..<20: return .red
        case 20..<40: return .orange
        case 40..<60: return .yellow
        case 60..<80: return .green
        default: return .purple
        }
    }
    
    var statusMessage: String {
        switch entry.batteryLevel {
        case 0..<20: return "Time to recharge!"
        case 20..<40: return "Running low"
        case 40..<60: return "Moderate energy"
        case 60..<80: return "Good energy"
        default: return "Fully charged!"
        }
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(.systemBackground))
            
            HStack(spacing: 20) {
                // Battery Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(entry.batteryLevel) / 100)
                        .stroke(batteryColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(entry.batteryLevel)%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(batteryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Social Battery")
                        .font(.headline)
                    
                    Text(statusMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let activity = entry.lastActivity {
                        HStack(spacing: 4) {
                            Text(activity.icon)
                            Text(activity.rawValue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Lock Screen Widget View
struct LockScreenWidgetView: View {
    let entry: BatteryWidgetEntry
    
    var body: some View {
        Gauge(value: Double(entry.batteryLevel), in: 0...100) {
            Image(systemName: "battery.100.bolt")
        } currentValueLabel: {
            Text("\(entry.batteryLevel)%")
        }
        .gaugeStyle(.accessoryCircular)
    }
}

// MARK: - Inline Lock Screen Widget
struct InlineLockScreenWidgetView: View {
    let entry: BatteryWidgetEntry
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "battery.100.bolt")
            Text("\(entry.batteryLevel)% Social Battery")
        }
    }
}
