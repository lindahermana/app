//
//  UserProfile.swift
//  Recharge
//

import Foundation

struct UserProfile: Codable {
    var name: String
    var personalityType: PersonalityType
    var dailyGoal: Int // Target battery level to maintain
    var preferredRechargeActivities: [SocialActivity]
    var notificationsEnabled: Bool
    var isPremium: Bool
    
    init(name: String = "", personalityType: PersonalityType = .ambivert, dailyGoal: Int = 50, preferredRechargeActivities: [SocialActivity] = [], notificationsEnabled: Bool = true, isPremium: Bool = false) {
        self.name = name
        self.personalityType = personalityType
        self.dailyGoal = dailyGoal
        self.preferredRechargeActivities = preferredRechargeActivities
        self.notificationsEnabled = notificationsEnabled
        self.isPremium = isPremium
    }
}

enum PersonalityType: String, Codable, CaseIterable {
    case introvert = "Introvert"
    case ambivert = "Ambivert"
    case extrovert = "Extrovert"
    
    var description: String {
        switch self {
        case .introvert:
            return "You recharge through alone time and find social interactions draining"
        case .ambivert:
            return "You balance between social and alone time for energy"
        case .extrovert:
            return "You gain energy from social interactions"
        }
    }
    
    var icon: String {
        switch self {
        case .introvert: return "🌙"
        case .ambivert: return "⚖️"
        case .extrovert: return "☀️"
        }
    }
    
    var baselineDrainRate: Double {
        switch self {
        case .introvert: return 1.5
        case .ambivert: return 1.0
        case .extrovert: return 0.5
        }
    }
}
