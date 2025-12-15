//
//  BatteryViewModel.swift
//  Recharge
//

import Foundation
import SwiftUI
import Combine

class BatteryViewModel: ObservableObject {
    @Published var currentBatteryLevel: Int = 75
    @Published var entries: [BatteryEntry] = []
    @Published var userProfile: UserProfile = UserProfile()
    @Published var todayEntries: [BatteryEntry] = []
    @Published var weeklyStats: WeeklyStats?
    @Published var insights: [Insight] = []
    
    private let userDefaultsKey = "batteryEntries"
    private let profileKey = "userProfile"
    
    init() {
        loadData()
        generateInsights()
    }
    
    // MARK: - Data Persistence
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([BatteryEntry].self, from: data) {
            self.entries = decoded
            updateTodayEntries()
            calculateCurrentLevel()
        }
        
        if let profileData = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: profileData) {
            self.userProfile = decoded
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
        if let profileEncoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(profileEncoded, forKey: profileKey)
        }
    }
    
    // MARK: - Battery Management
    
    func addEntry(level: Int, activity: SocialActivity?, note: String = "", mood: Mood? = nil) {
        let entry = BatteryEntry(level: level, activity: activity, note: note, mood: mood)
        entries.append(entry)
        currentBatteryLevel = level
        updateTodayEntries()
        saveData()
        generateInsights()
    }
    
    func quickUpdate(delta: Int, activity: SocialActivity? = nil) {
        let newLevel = max(0, min(100, currentBatteryLevel + delta))
        addEntry(level: newLevel, activity: activity)
    }
    
    func updateTodayEntries() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        todayEntries = entries.filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
    }
    
    func calculateCurrentLevel() {
        if let lastEntry = entries.sorted(by: { $0.timestamp > $1.timestamp }).first {
            currentBatteryLevel = lastEntry.level
        }
    }
    
    // MARK: - Analytics
    
    func calculateWeeklyStats() -> WeeklyStats {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        let weekEntries = entries.filter { $0.timestamp >= weekAgo }
        
        let average = weekEntries.isEmpty ? 0 : weekEntries.reduce(0) { $0 + $1.level } / weekEntries.count
        
        let activityCounts = Dictionary(grouping: weekEntries.compactMap { $0.activity }) { $0 }
        let mostCommonActivity = activityCounts.max(by: { $0.value.count < $1.value.count })?.key
        
        let drainingActivities = weekEntries.filter { $0.activity?.isDraining == true }
        let mostDraining = drainingActivities.compactMap { $0.activity }.first
        
        let rechargingActivities = weekEntries.filter { $0.activity?.isDraining == false }
        let mostRecharging = rechargingActivities.compactMap { $0.activity }.first
        
        let lowBatteryDays = Set(weekEntries.filter { $0.level < 30 }.map { calendar.startOfDay(for: $0.timestamp) }).count
        
        return WeeklyStats(
            averageBatteryLevel: average,
            totalEntries: weekEntries.count,
            mostDrainingActivity: mostDraining,
            mostRechargingActivity: mostRecharging,
            lowBatteryDays: lowBatteryDays,
            streak: calculateStreak()
        )
    }
    
    func calculateStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        while true {
            let hasEntry = entries.contains { calendar.isDate($0.timestamp, inSameDayAs: currentDate) }
            if hasEntry {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    // MARK: - Insights Generation
    
    func generateInsights() {
        var newInsights: [Insight] = []
        
        // Pattern: Low battery warning
        if currentBatteryLevel < 30 {
            newInsights.append(Insight(
                title: "Low Battery Alert",
                description: "Your social battery is running low. Consider some alone time or a recharging activity.",
                icon: "🪫",
                type: .warning,
                isPremium: false
            ))
        }
        
        // Pattern: High energy
        if currentBatteryLevel >= 80 {
            newInsights.append(Insight(
                title: "Fully Charged!",
                description: "You're at peak energy. Great time for social activities if you choose!",
                icon: "⚡️",
                type: .achievement,
                isPremium: false
            ))
        }
        
        // Weekly pattern (Premium)
        let stats = calculateWeeklyStats()
        if let draining = stats.mostDrainingActivity {
            newInsights.append(Insight(
                title: "Energy Drain Pattern",
                description: "\(draining.icon) \(draining.rawValue) tends to drain your battery the most.",
                icon: "📊",
                type: .pattern,
                isPremium: true
            ))
        }
        
        // Streak achievement
        if stats.streak >= 7 {
            newInsights.append(Insight(
                title: "Week Streak! 🔥",
                description: "You've been tracking for \(stats.streak) days in a row!",
                icon: "🏆",
                type: .achievement,
                isPremium: false
            ))
        }
        
        // Recommendation based on personality
        let recommendation = getPersonalizedRecommendation()
        newInsights.append(Insight(
            title: "Personalized Tip",
            description: recommendation,
            icon: "💡",
            type: .recommendation,
            isPremium: false
        ))
        
        self.insights = newInsights
        self.weeklyStats = stats
    }
    
    func getPersonalizedRecommendation() -> String {
        switch userProfile.personalityType {
        case .introvert:
            if currentBatteryLevel < 50 {
                return "As an introvert, quality alone time is your superpower. Schedule some quiet hours."
            } else {
                return "Your battery is healthy! Small social interactions now won't drain you too much."
            }
        case .ambivert:
            return "Balance is key for you. Try alternating between social and solo activities."
        case .extrovert:
            if currentBatteryLevel < 50 {
                return "You might be isolating too much. Consider reaching out to a friend!"
            } else {
                return "Your social energy is flowing. Enjoy connecting with others!"
            }
        }
    }
    
    // MARK: - History
    
    func getEntriesForDate(_ date: Date) -> [BatteryEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
    }
    
    func getAverageLevelForDate(_ date: Date) -> Int? {
        let dayEntries = getEntriesForDate(date)
        guard !dayEntries.isEmpty else { return nil }
        return dayEntries.reduce(0) { $0 + $1.level } / dayEntries.count
    }
    
    func getLast30DaysData() -> [(Date, Int)] {
        let calendar = Calendar.current
        var result: [(Date, Int)] = []
        
        for i in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            if let avg = getAverageLevelForDate(date) {
                result.append((date, avg))
            }
        }
        
        return result.reversed()
    }
}
