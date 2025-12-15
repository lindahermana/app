//
//  RechargeActivitiesView.swift
//  Recharge
//

import SwiftUI

struct RechargeActivitiesView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    
    let rechargeActivities: [(activity: SocialActivity, boost: Int, duration: String)] = [
        (.aloneTime, 25, "30 min"),
        (.reading, 20, "20 min"),
        (.meditation, 30, "15 min"),
        (.nap, 35, "30 min"),
        (.outdoors, 20, "20 min"),
        (.exercise, 15, "30 min"),
        (.gaming, 15, "45 min")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    HeaderCard()
                    
                    // Current Level Indicator
                    CurrentLevelCard(level: viewModel.currentBatteryLevel)
                    
                    // Recharge Activities
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recharge Activities")
                            .font(.headline)
                        
                        ForEach(rechargeActivities, id: \.activity) { item in
                            RechargeActivityCard(
                                activity: item.activity,
                                boost: item.boost,
                                duration: item.duration
                            ) {
                                viewModel.quickUpdate(delta: item.boost, activity: item.activity)
                            }
                        }
                    }
                    
                    // Tips Section
                    TipsSection(personalityType: viewModel.userProfile.personalityType)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recharge")
        }
    }
}

struct HeaderCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("⚡️")
                .font(.system(size: 44))
            
            Text("Time to Recharge")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Choose an activity to boost your social battery")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.15), Color.blue.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

struct CurrentLevelCard: View {
    let level: Int
    
    var levelColor: Color {
        switch level {
        case 0..<20: return .red
        case 20..<40: return .orange
        case 40..<60: return .yellow
        case 60..<80: return .green
        default: return .purple
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Level")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(level)%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(levelColor)
            }
            
            Spacer()
            
            // Mini progress bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(levelColor)
                    .frame(width: CGFloat(level), height: 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct RechargeActivityCard: View {
    let activity: SocialActivity
    let boost: Int
    let duration: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text(activity.icon)
                .font(.title)
                .frame(width: 50, height: 50)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.rawValue)
                    .font(.headline)
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(duration)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.caption)
                    Text("\(boost)%")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct TipsSection: View {
    let personalityType: PersonalityType
    
    var tips: [String] {
        switch personalityType {
        case .introvert:
            return [
                "🌙 Quality alone time is your superpower",
                "📚 Reading or quiet hobbies help you recharge",
                "🎧 Use noise-canceling headphones in crowded spaces",
                "⏰ Schedule recovery time after social events",
                "🏠 Create a cozy personal retreat space"
            ]
        case .ambivert:
            return [
                "⚖️ Balance social and solo activities",
                "🔄 Listen to what your body needs today",
                "👥 Small groups often feel better than large ones",
                "🌅 Match activities to your energy levels",
                "📊 Track patterns to optimize your schedule"
            ]
        case .extrovert:
            return [
                "☀️ Social interaction energizes you",
                "📞 Quick calls can boost your mood",
                "👯 Group activities are your sweet spot",
                "🎉 Plan regular social outings",
                "💬 Don't hesitate to reach out to friends"
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(personalityType.icon)
                Text("Tips for \(personalityType.rawValue)s")
                    .font(.headline)
            }
            
            ForEach(tips, id: \.self) { tip in
                Text(tip)
                    .font(.subheadline)
                    .padding(.vertical, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    RechargeActivitiesView()
        .environmentObject(BatteryViewModel())
}
