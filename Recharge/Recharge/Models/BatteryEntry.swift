//
//  BatteryEntry.swift
//  Recharge
//

import Foundation

struct BatteryEntry: Identifiable, Codable {
    let id: UUID
    var level: Int // 0-100
    var activity: SocialActivity?
    var note: String
    var timestamp: Date
    var mood: Mood?
    var location: String?
    
    init(id: UUID = UUID(), level: Int, activity: SocialActivity? = nil, note: String = "", timestamp: Date = Date(), mood: Mood? = nil, location: String? = nil) {
        self.id = id
        self.level = max(0, min(100, level))
        self.activity = activity
        self.note = note
        self.timestamp = timestamp
        self.mood = mood
        self.location = location
    }
}

enum SocialActivity: String, Codable, CaseIterable {
    case party = "Party"
    case smallGathering = "Small Gathering"
    case oneOnOne = "One-on-One"
    case workMeeting = "Work Meeting"
    case familyEvent = "Family Event"
    case dateNight = "Date Night"
    case networking = "Networking"
    case videoCall = "Video Call"
    case phoneCalls = "Phone Calls"
    case shopping = "Shopping"
    case commute = "Commute"
    case aloneTime = "Alone Time"
    case outdoors = "Outdoors"
    case exercise = "Exercise"
    case gaming = "Gaming"
    case reading = "Reading"
    case meditation = "Meditation"
    case nap = "Nap"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .party: return "🎉"
        case .smallGathering: return "👥"
        case .oneOnOne: return "👤"
        case .workMeeting: return "💼"
        case .familyEvent: return "👨‍👩‍👧‍👦"
        case .dateNight: return "❤️"
        case .networking: return "🤝"
        case .videoCall: return "📹"
        case .phoneCalls: return "📞"
        case .shopping: return "🛒"
        case .commute: return "🚇"
        case .aloneTime: return "🧘"
        case .outdoors: return "🌳"
        case .exercise: return "🏃"
        case .gaming: return "🎮"
        case .reading: return "📚"
        case .meditation: return "🧘‍♀️"
        case .nap: return "😴"
        case .other: return "📝"
        }
    }
    
    var isDraining: Bool {
        switch self {
        case .party, .networking, .familyEvent, .workMeeting, .shopping, .commute, .phoneCalls, .videoCall:
            return true
        case .aloneTime, .reading, .meditation, .nap, .gaming:
            return false
        default:
            return false
        }
    }
}

enum Mood: String, Codable, CaseIterable {
    case energized = "Energized"
    case content = "Content"
    case neutral = "Neutral"
    case tired = "Tired"
    case drained = "Drained"
    case overwhelmed = "Overwhelmed"
    case anxious = "Anxious"
    case peaceful = "Peaceful"
    
    var icon: String {
        switch self {
        case .energized: return "⚡️"
        case .content: return "😊"
        case .neutral: return "😐"
        case .tired: return "😴"
        case .drained: return "🪫"
        case .overwhelmed: return "😵"
        case .anxious: return "😰"
        case .peaceful: return "☮️"
        }
    }
    
    var color: String {
        switch self {
        case .energized: return "yellow"
        case .content: return "green"
        case .neutral: return "gray"
        case .tired: return "orange"
        case .drained: return "red"
        case .overwhelmed: return "purple"
        case .anxious: return "pink"
        case .peaceful: return "blue"
        }
    }
}
