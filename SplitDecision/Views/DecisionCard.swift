//
//  DecisionCard.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct DecisionCard: View {
    let decision: Decision
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(decision.category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(decision.category.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(decision.category.color)
                    
                    Text(timeAgo(from: decision.createdAt))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if !decision.isActive {
                    Text("ENDED")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(4)
                }
            }
            
            // Question
            Text(decision.question)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(3)
            
            // Options
            VStack(spacing: 8) {
                ForEach(decision.options) { option in
                    OptionBar(
                        option: option,
                        totalVotes: decision.totalVotes,
                        isWinning: decision.winner?.id == option.id
                    )
                }
            }
            
            // Footer
            HStack {
                Label("\(decision.totalVotes)", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let winner = decision.winner, decision.totalVotes > 0 {
                    Text("👑 \(winner.title)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private func timeAgo(from date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        
        if seconds < 60 {
            return "just now"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(seconds / 86400)
            return "\(days)d ago"
        }
    }
}

struct OptionBar: View {
    let option: DecisionOption
    let totalVotes: Int
    let isWinning: Bool
    
    var percentage: Double {
        option.votePercentage(totalVotes: totalVotes)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background
            Rectangle()
                .fill(Color(.systemGray6))
                .frame(height: 44)
                .cornerRadius(8)
            
            // Fill
            Rectangle()
                .fill(isWinning ? Color.purple.gradient : Color.gray.gradient)
                .frame(width: CGFloat(percentage / 100) * (UIScreen.main.bounds.width - 64), height: 44)
                .cornerRadius(8)
            
            // Content
            HStack {
                Text(option.title)
                    .font(.subheadline)
                    .fontWeight(isWinning ? .bold : .regular)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("\(Int(percentage))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("(\(option.votes))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
