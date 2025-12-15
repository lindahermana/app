//
//  Insight.swift
//  Recharge
//

import Foundation

struct Insight: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: InsightType
    let isPremium: Bool
}

enum InsightType {
    case pattern
    case recommendation
    case achievement
    case warning
}

struct WeeklyStats {
    var averageBatteryLevel: Int
    var totalEntries: Int
    var mostDrainingActivity: SocialActivity?
    var mostRechargingActivity: SocialActivity?
    var lowBatteryDays: Int
    var streak: Int
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let unlockedDate: Date?
    
    var isUnlocked: Bool {
        return unlockedDate != nil
    }
    
    static let allAchievements: [Achievement] = [
        Achievement(id: UUID(), title: "First Check-in", description: "Log your first battery level", icon: "🎯", unlockedDate: nil),
        Achievement(id: UUID(), title: "Week Warrior", description: "Log for 7 days straight", icon: "🔥", unlockedDate: nil),
        Achievement(id: UUID(), title: "Self-Aware", description: "Complete 30 check-ins", icon: "🧠", unlockedDate: nil),
        Achievement(id: UUID(), title: "Battery Master", description: "Maintain 70%+ for a week", icon: "⚡️", unlockedDate: nil),
        Achievement(id: UUID(), title: "Recharge Pro", description: "Use 5 different recharge activities", icon: "🌟", unlockedDate: nil),
        Achievement(id: UUID(), title: "Night Owl", description: "Log after 10 PM", icon: "🦉", unlockedDate: nil),
        Achievement(id: UUID(), title: "Early Bird", description: "Log before 7 AM", icon: "🐦", unlockedDate: nil),
        Achievement(id: UUID(), title: "Social Butterfly", description: "Track 10 social events", icon: "🦋", unlockedDate: nil),
        Achievement(id: UUID(), title: "Zen Master", description: "Reach 100% battery", icon: "🧘", unlockedDate: nil),
        Achievement(id: UUID(), title: "Survivor", description: "Recover from 0% battery", icon: "💪", unlockedDate: nil)
    ]
}
