//
//  DecisionManager.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import Foundation
import Combine

class DecisionManager: ObservableObject {
    @Published var decisions: [Decision] = []
    @Published var publicDecisions: [Decision] = []
    
    init() {
        loadSampleData()
    }
    
    // MARK: - Create Decision
    func createDecision(
        question: String,
        options: [String],
        category: DecisionCategory,
        isPublic: Bool,
        expiresInHours: Int? = nil
    ) -> Decision {
        let decisionOptions = options.map { DecisionOption(title: $0) }
        let expiresAt = expiresInHours != nil ? Date().addingTimeInterval(TimeInterval(expiresInHours! * 3600)) : nil
        
        let decision = Decision(
            question: question,
            options: decisionOptions,
            expiresAt: expiresAt,
            isPublic: isPublic,
            category: category
        )
        
        decisions.insert(decision, at: 0)
        if isPublic {
            publicDecisions.insert(decision, at: 0)
        }
        
        return decision
    }
    
    // MARK: - Vote
    func vote(on decision: Decision, optionId: UUID) {
        if let decisionIndex = decisions.firstIndex(where: { $0.id == decision.id }),
           let optionIndex = decisions[decisionIndex].options.firstIndex(where: { $0.id == optionId }) {
            decisions[decisionIndex].options[optionIndex].votes += 1
            decisions[decisionIndex].totalVotes += 1
        }
        
        if let publicIndex = publicDecisions.firstIndex(where: { $0.id == decision.id }),
           let optionIndex = publicDecisions[publicIndex].options.firstIndex(where: { $0.id == optionId }) {
            publicDecisions[publicIndex].options[optionIndex].votes += 1
            publicDecisions[publicIndex].totalVotes += 1
        }
    }
    
    // MARK: - Delete
    func deleteDecision(_ decision: Decision) {
        decisions.removeAll(where: { $0.id == decision.id })
        publicDecisions.removeAll(where: { $0.id == decision.id })
    }
    
    // MARK: - Sample Data
    private func loadSampleData() {
        let sample1 = Decision(
            question: "Which outfit should I wear to the party tonight?",
            options: [
                DecisionOption(title: "Black dress with heels", votes: 24),
                DecisionOption(title: "Jeans and cute top", votes: 18),
                DecisionOption(title: "Casual jumpsuit", votes: 12)
            ],
            category: .fashion
        )
        
        let sample2 = Decision(
            question: "What should I eat for dinner?",
            options: [
                DecisionOption(title: "Pizza 🍕", votes: 42),
                DecisionOption(title: "Sushi 🍣", votes: 38),
                DecisionOption(title: "Tacos 🌮", votes: 31)
            ],
            category: .food
        )
        
        let sample3 = Decision(
            question: "Should I text them first or wait?",
            options: [
                DecisionOption(title: "Text them NOW", votes: 156),
                DecisionOption(title: "Wait for them", votes: 89)
            ],
            category: .dating
        )
        
        decisions = [sample1, sample2, sample3]
        publicDecisions = [sample1, sample2, sample3]
    }
}
