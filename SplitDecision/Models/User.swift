//
//  User.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var username: String
    var email: String
    var isPremium: Bool
    var decisionsCreated: Int
    var decisionsThisMonth: Int
    var joinedAt: Date
    
    init(
        id: UUID = UUID(),
        username: String,
        email: String,
        isPremium: Bool = false,
        decisionsCreated: Int = 0,
        decisionsThisMonth: Int = 0,
        joinedAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.isPremium = isPremium
        self.decisionsCreated = decisionsCreated
        self.decisionsThisMonth = decisionsThisMonth
        self.joinedAt = joinedAt
    }
    
    var canCreateDecision: Bool {
        isPremium || decisionsThisMonth < 10
    }
    
    var remainingDecisions: Int {
        isPremium ? -1 : max(0, 10 - decisionsThisMonth)
    }
}
