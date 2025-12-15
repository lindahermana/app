//
//  Decision.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import Foundation
import SwiftUI

// MARK: - Decision Model
struct Decision: Identifiable, Codable {
    let id: UUID
    var question: String
    var options: [DecisionOption]
    var createdAt: Date
    var expiresAt: Date?
    var isPublic: Bool
    var category: DecisionCategory
    var totalVotes: Int
    var shareLink: String
    
    init(
        id: UUID = UUID(),
        question: String,
        options: [DecisionOption],
        expiresAt: Date? = nil,
        isPublic: Bool = true,
        category: DecisionCategory = .other
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.createdAt = Date()
        self.expiresAt = expiresAt
        self.isPublic = isPublic
        self.category = category
        self.totalVotes = options.reduce(0) { $0 + $1.votes }
        self.shareLink = "splitdecision://decision/\(id.uuidString)"
    }
    
    var winner: DecisionOption? {
        options.max(by: { $0.votes < $1.votes })
    }
    
    var isActive: Bool {
        guard let expiresAt = expiresAt else { return true }
        return Date() < expiresAt
    }
}

// MARK: - Decision Option
struct DecisionOption: Identifiable, Codable {
    let id: UUID
    var title: String
    var imageURL: String?
    var votes: Int
    
    init(id: UUID = UUID(), title: String, imageURL: String? = nil, votes: Int = 0) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.votes = votes
    }
    
    func votePercentage(totalVotes: Int) -> Double {
        guard totalVotes > 0 else { return 0 }
        return Double(votes) / Double(totalVotes) * 100
    }
}

// MARK: - Decision Category
enum DecisionCategory: String, Codable, CaseIterable {
    case fashion = "Fashion"
    case food = "Food"
    case dating = "Dating"
    case shopping = "Shopping"
    case travel = "Travel"
    case career = "Career"
    case lifestyle = "Lifestyle"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .fashion: return "👗"
        case .food: return "🍔"
        case .dating: return "💕"
        case .shopping: return "🛍️"
        case .travel: return "✈️"
        case .career: return "💼"
        case .lifestyle: return "🌟"
        case .other: return "❓"
        }
    }
    
    var color: Color {
        switch self {
        case .fashion: return .pink
        case .food: return .orange
        case .dating: return .red
        case .shopping: return .purple
        case .travel: return .blue
        case .career: return .green
        case .lifestyle: return .yellow
        case .other: return .gray
        }
    }
}
