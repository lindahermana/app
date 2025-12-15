//
//  DecisionDetailView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct DecisionDetailView: View {
    @EnvironmentObject var decisionManager: DecisionManager
    @State private var decision: Decision
    @State private var selectedOptionId: UUID?
    @State private var hasVoted = false
    @State private var showingShareSheet = false
    
    init(decision: Decision) {
        _decision = State(initialValue: decision)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Category Badge
                HStack {
                    Text(decision.category.icon)
                    Text(decision.category.rawValue)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(decision.category.color.opacity(0.2))
                .foregroundColor(decision.category.color)
                .cornerRadius(20)
                
                // Question
                Text(decision.question)
                    .font(.title2)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Stats
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Votes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(decision.totalVotes)")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    if let expiresAt = decision.expiresAt {
                        Divider()
                            .frame(height: 40)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(decision.isActive ? "Ends In" : "Ended")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(timeRemaining(until: expiresAt))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(decision.isActive ? .primary : .red)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Options
                VStack(spacing: 16) {
                    ForEach(decision.options) { option in
                        OptionDetailCard(
                            option: option,
                            totalVotes: decision.totalVotes,
                            isSelected: selectedOptionId == option.id,
                            hasVoted: hasVoted,
                            isWinning: decision.winner?.id == option.id
                        ) {
                            if !hasVoted && decision.isActive {
                                selectedOptionId = option.id
                            }
                        }
                    }
                }
                
                // Vote Button
                if !hasVoted && decision.isActive {
                    Button(action: submitVote) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Submit Vote")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedOptionId != nil ? Color.purple : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(selectedOptionId == nil)
                } else if hasVoted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Thanks for voting!")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(12)
                }
                
                // Share Button
                Button(action: { showingShareSheet = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Decision")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [decision.shareLink])
        }
    }
    
    private func submitVote() {
        guard let optionId = selectedOptionId else { return }
        decisionManager.vote(on: decision, optionId: optionId)
        
        // Update local state
        if let index = decision.options.firstIndex(where: { $0.id == optionId }) {
            decision.options[index].votes += 1
            decision.totalVotes += 1
        }
        
        hasVoted = true
    }
    
    private func timeRemaining(until date: Date) -> String {
        let seconds = date.timeIntervalSince(Date())
        
        if seconds < 0 {
            return "Expired"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            return "\(minutes)m"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            return "\(hours)h"
        } else {
            let days = Int(seconds / 86400)
            return "\(days)d"
        }
    }
}

struct OptionDetailCard: View {
    let option: DecisionOption
    let totalVotes: Int
    let isSelected: Bool
    let hasVoted: Bool
    let isWinning: Bool
    let action: () -> Void
    
    var percentage: Double {
        option.votePercentage(totalVotes: totalVotes)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(option.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        if hasVoted || !isSelected {
                            HStack(spacing: 4) {
                                Text("\(Int(percentage))%")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(isWinning ? .purple : .primary)
                                Text("(\(option.votes) votes)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if isWinning && hasVoted {
                        Text("👑")
                            .font(.title2)
                    } else if isSelected && !hasVoted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                }
                
                // Progress bar (shown after voting)
                if hasVoted {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(isWinning ? Color.purple : Color.gray)
                                .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.purple.opacity(0.1) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
