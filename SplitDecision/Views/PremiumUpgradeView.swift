//
//  PremiumUpgradeView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct PremiumUpgradeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    @State private var selectedPlan: PremiumPlan = .yearly
    
    enum PremiumPlan {
        case monthly
        case yearly
        
        var price: String {
            switch self {
            case .monthly: return "$4.99"
            case .yearly: return "$29.99"
            }
        }
        
        var period: String {
            switch self {
            case .monthly: return "/month"
            case .yearly: return "/year"
            }
        }
        
        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "Save 50%"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.yellow)
                        
                        Text("Go Premium")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Unlock unlimited decisions and exclusive features")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        PremiumFeature(icon: "infinity", title: "Unlimited Decisions", description: "Create as many decisions as you want")
                        PremiumFeature(icon: "eye.slash.fill", title: "Private Polls", description: "Keep your decisions completely private")
                        PremiumFeature(icon: "chart.bar.fill", title: "Advanced Analytics", description: "See who voted and detailed demographics")
                        PremiumFeature(icon: "paintbrush.fill", title: "Custom Themes", description: "Personalize your decision cards")
                        PremiumFeature(icon: "star.fill", title: "Priority Support", description: "Get help faster when you need it")
                        PremiumFeature(icon: "tv.slash.fill", title: "No Ads", description: "Enjoy an ad-free experience")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Pricing Options
                    VStack(spacing: 12) {
                        PlanButton(
                            plan: .yearly,
                            isSelected: selectedPlan == .yearly
                        ) {
                            selectedPlan = .yearly
                        }
                        
                        PlanButton(
                            plan: .monthly,
                            isSelected: selectedPlan == .monthly
                        ) {
                            selectedPlan = .monthly
                        }
                    }
                    
                    // Subscribe Button
                    Button(action: subscribe) {
                        Text("Start Free 7-Day Trial")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    // Fine Print
                    VStack(spacing: 8) {
                        Text("7-day free trial, then \(selectedPlan.price)\(selectedPlan.period)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Cancel anytime. Auto-renews.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Terms
                    HStack(spacing: 16) {
                        Button("Terms of Service") { }
                        Text("•")
                        Button("Privacy Policy") { }
                        Text("•")
                        Button("Restore") { }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func subscribe() {
        // In production, this would integrate with StoreKit
        userManager.upgradeToPremium()
        dismiss()
    }
}

struct PremiumFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PlanButton: View {
    let plan: PremiumUpgradeView.PremiumPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan == .monthly ? "Monthly" : "Yearly")
                            .font(.headline)
                        
                        if let savings = plan.savings {
                            Text(savings)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text("\(plan.price)\(plan.period)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
