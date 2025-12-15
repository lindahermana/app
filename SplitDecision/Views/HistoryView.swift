//
//  HistoryView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var decisionManager: DecisionManager
    @State private var showActiveOnly = false
    
    var filteredDecisions: [Decision] {
        let userDecisions = decisionManager.decisions
        if showActiveOnly {
            return userDecisions.filter { $0.isActive }
        }
        return userDecisions
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Toggle
                Toggle("Active Only", isOn: $showActiveOnly)
                    .padding()
                    .background(Color(.systemGray6))
                
                if filteredDecisions.isEmpty {
                    EmptyStateView(message: "No decisions in your history")
                } else {
                    List {
                        ForEach(filteredDecisions) { decision in
                            NavigationLink(destination: DecisionDetailView(decision: decision)) {
                                HistoryRow(decision: decision)
                            }
                        }
                        .onDelete(perform: deleteDecisions)
                    }
                }
            }
            .navigationTitle("My Decisions")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func deleteDecisions(at offsets: IndexSet) {
        for index in offsets {
            let decision = filteredDecisions[index]
            decisionManager.deleteDecision(decision)
        }
    }
}

struct HistoryRow: View {
    let decision: Decision
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(decision.category.icon)
                Text(decision.question)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                if !decision.isActive {
                    Image(systemName: "clock.badge.xmark")
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                if let winner = decision.winner {
                    Text("Winner: \(winner.title)")
                        .font(.caption)
                        .foregroundColor(.purple)
                        .lineLimit(1)
                } else {
                    Text("No votes yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Label("\(decision.totalVotes)", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
