//
//  OnboardingView.swift
//  Recharge
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    @State private var name = ""
    @State private var selectedType: PersonalityType = .ambivert
    
    var body: some View {
        TabView(selection: $currentPage) {
            // Page 1: Welcome
            WelcomePage()
                .tag(0)
            
            // Page 2: What is Social Battery
            ExplainerPage()
                .tag(1)
            
            // Page 3: Name
            NamePage(name: $name)
                .tag(2)
            
            // Page 4: Personality Type
            PersonalityPage(selectedType: $selectedType)
                .tag(3)
            
            // Page 5: Get Started
            GetStartedPage {
                saveAndDismiss()
            }
            .tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
    
    func saveAndDismiss() {
        viewModel.userProfile.name = name
        viewModel.userProfile.personalityType = selectedType
        viewModel.saveData()
        dismiss()
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "battery.100.bolt")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
            }
            
            Text("Welcome to Recharge")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Track your social energy and live a more balanced life")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Text("Swipe to continue →")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 60)
        }
    }
}

struct ExplainerPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("🔋")
                .font(.system(size: 80))
            
            Text("What's a Social Battery?")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                ExplainerItem(
                    icon: "⚡️",
                    text: "Your social battery represents your energy for social interactions"
                )
                
                ExplainerItem(
                    icon: "📉",
                    text: "Some activities drain your battery (parties, meetings, crowds)"
                )
                
                ExplainerItem(
                    icon: "📈",
                    text: "Other activities recharge it (alone time, hobbies, rest)"
                )
                
                ExplainerItem(
                    icon: "🎯",
                    text: "Understanding your patterns helps you manage energy better"
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct ExplainerItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.title2)
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct NamePage: View {
    @Binding var name: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("👋")
                .font(.system(size: 80))
            
            Text("What should we call you?")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Your name", text: $name)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 60)
            
            Text("This helps personalize your experience")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct PersonalityPage: View {
    @Binding var selectedType: PersonalityType
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Which describes you best?")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                ForEach(PersonalityType.allCases, id: \.self) { type in
                    Button(action: { selectedType = type }) {
                        HStack(spacing: 16) {
                            Text(type.icon)
                                .font(.title)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(type.rawValue)
                                    .font(.headline)
                                Text(type.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            if selectedType == type {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.purple)
                                    .font(.title2)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedType == type ? Color.purple : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

struct GetStartedPage: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("🚀")
                .font(.system(size: 80))
            
            Text("You're all set!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Start tracking your social battery and discover your unique energy patterns")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: action) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(BatteryViewModel())
}
