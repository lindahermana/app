//
//  HomeView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var decisionManager: DecisionManager
    @State private var selectedCategory: DecisionCategory?
    
    var filteredDecisions: [Decision] {
        if let category = selectedCategory {
            return decisionManager.publicDecisions.filter { $0.category == category }
        }
        return decisionManager.publicDecisions
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryChip(category: nil, isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        
                        ForEach(DecisionCategory.allCases, id: \.self) { category in
                            CategoryChip(category: category, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                
                // Decisions Feed
                if filteredDecisions.isEmpty {
                    EmptyStateView(message: "No decisions yet. Be the first!")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredDecisions) { decision in
                                NavigationLink(destination: DecisionDetailView(decision: decision)) {
                                    DecisionCard(decision: decision)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Split Decision")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CategoryChip: View {
    let category: DecisionCategory?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let category = category {
                    Text(category.icon)
                    Text(category.rawValue)
                } else {
                    Text("All")
                }
            }
            .font(.subheadline)
            .fontWeight(isSelected ? .bold : .regular)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.purple : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
