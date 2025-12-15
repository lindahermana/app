//
//  UserManager.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    @Published var currentUser: User
    
    init() {
        // Sample user - in production, this would load from UserDefaults or authentication
        self.currentUser = User(
            username: "decisionmaker",
            email: "user@splitdecision.app",
            isPremium: false,
            decisionsCreated: 3,
            decisionsThisMonth: 3
        )
    }
    
    func createDecision() {
        currentUser.decisionsCreated += 1
        currentUser.decisionsThisMonth += 1
    }
    
    func upgradeToPremium() {
        currentUser.isPremium = true
    }
    
    func resetMonthlyLimit() {
        currentUser.decisionsThisMonth = 0
    }
}
