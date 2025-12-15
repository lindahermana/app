//
//  PremiumView.swift
//  Recharge
//

import SwiftUI

struct PremiumView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: PurchaseManager.PremiumPlan = .yearly
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("✨")
                        .font(.system(size: 60))
                    
                    Text("Unlock Premium")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Get the full Recharge experience")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Features List
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(purchaseManager.premiumFeatures, id: \.self) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(feature)
                                .font(.body)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                // Pricing Options
                VStack(spacing: 12) {
                    ForEach(PurchaseManager.PremiumPlan.allCases, id: \.self) { plan in
                        PlanOptionCard(
                            plan: plan,
                            isSelected: selectedPlan == plan
                        ) {
                            selectedPlan = plan
                        }
                    }
                }
                
                // Subscribe Button
                Button(action: {
                    Task {
                        await purchaseManager.purchase(selectedPlan)
                    }
                }) {
                    if purchaseManager.purchaseInProgress {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(14)
                    } else {
                        Text("Subscribe Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(14)
                    }
                }
                .disabled(purchaseManager.purchaseInProgress)
                
                // Restore Purchases
                Button(action: {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                }) {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }
                
                // Legal
                VStack(spacing: 8) {
                    Text("Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 16) {
                        Link("Terms", destination: URL(string: "https://recharge-app.com/terms")!)
                        Link("Privacy", destination: URL(string: "https://recharge-app.com/privacy")!)
                    }
                    .font(.caption)
                }
                .padding(.top, 8)
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await purchaseManager.loadProducts()
        }
    }
}

struct PlanOptionCard: View {
    let plan: PurchaseManager.PremiumPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.displayName)
                            .font(.headline)
                        if plan == .yearly {
                            Text("POPULAR")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    Text(plan.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(plan.price)
                    .font(.headline)
                    .foregroundColor(isSelected ? .purple : .primary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        PremiumView()
            .environmentObject(PurchaseManager())
    }
}
