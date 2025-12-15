//
//  CreateDecisionView.swift
//  Split Decision
//
//  Created on 12/15/2024.
//

import SwiftUI

struct CreateDecisionView: View {
    @EnvironmentObject var decisionManager: DecisionManager
    @EnvironmentObject var userManager: UserManager
    
    @State private var question = ""
    @State private var options: [String] = ["", ""]
    @State private var selectedCategory: DecisionCategory = .other
    @State private var isPublic = true
    @State private var hasTimer = false
    @State private var timerHours = 24
    @State private var showingUpgradeSheet = false
    @State private var showingSuccessAlert = false
    
    var canCreate: Bool {
        !question.isEmpty && 
        options.filter({ !$0.isEmpty }).count >= 2 &&
        userManager.currentUser.canCreateDecision
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Decision")) {
                    TextField("What do you need help deciding?", text: $question)
                        .font(.headline)
                }
                
                Section(header: Text("Options (2-4)")) {
                    ForEach(options.indices, id: \.self) { index in
                        HStack {
                            TextField("Option \(index + 1)", text: $options[index])
                            
                            if options.count > 2 {
                                Button(action: {
                                    options.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    if options.count < 4 {
                        Button(action: {
                            options.append("")
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Option")
                            }
                        }
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(DecisionCategory.allCases, id: \.self) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Settings")) {
                    Toggle("Make Public", isOn: $isPublic)
                    Toggle("Add Timer", isOn: $hasTimer)
                    
                    if hasTimer {
                        Stepper("Expires in \(timerHours) hours", value: $timerHours, in: 1...72)
                    }
                }
                
                Section {
                    if !userManager.currentUser.canCreateDecision {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("⚠️ Monthly Limit Reached")
                                .font(.headline)
                                .foregroundColor(.orange)
                            Text("You've used all 10 free decisions this month.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                showingUpgradeSheet = true
                            }) {
                                Text("Upgrade to Premium")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    } else {
                        Button(action: createDecision) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Create Decision")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canCreate ? Color.purple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(!canCreate)
                        
                        if !userManager.currentUser.isPremium {
                            Text("\(userManager.currentUser.remainingDecisions) decisions remaining this month")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .navigationTitle("Create Decision")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingUpgradeSheet) {
                PremiumUpgradeView()
            }
            .alert("Decision Created! 🎉", isPresented: $showingSuccessAlert) {
                Button("Share") {
                    // Share functionality
                }
                Button("View") {
                    // Navigate to decision
                }
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your decision has been created and shared with the community!")
            }
        }
    }
    
    private func createDecision() {
        let validOptions = options.filter { !$0.isEmpty }
        
        let decision = decisionManager.createDecision(
            question: question,
            options: validOptions,
            category: selectedCategory,
            isPublic: isPublic,
            expiresInHours: hasTimer ? timerHours : nil
        )
        
        userManager.createDecision()
        
        // Reset form
        question = ""
        options = ["", ""]
        selectedCategory = .other
        isPublic = true
        hasTimer = false
        
        showingSuccessAlert = true
    }
}
