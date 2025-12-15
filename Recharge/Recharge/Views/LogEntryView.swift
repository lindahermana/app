//
//  LogEntryView.swift
//  Recharge
//

import SwiftUI

struct LogEntryView: View {
    @EnvironmentObject var viewModel: BatteryViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var batteryLevel: Double
    @State private var selectedActivity: SocialActivity?
    @State private var selectedMood: Mood?
    @State private var note: String = ""
    
    init() {
        _batteryLevel = State(initialValue: 50)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Battery Level Slider
                    BatterySliderSection(level: $batteryLevel)
                    
                    // Activity Selection
                    ActivitySelectionSection(selectedActivity: $selectedActivity)
                    
                    // Mood Selection
                    MoodSelectionSection(selectedMood: $selectedMood)
                    
                    // Notes
                    NotesSection(note: $note)
                    
                    // Save Button
                    Button(action: saveEntry) {
                        Text("Log Entry")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(14)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Log Battery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            batteryLevel = Double(viewModel.currentBatteryLevel)
        }
    }
    
    func saveEntry() {
        viewModel.addEntry(
            level: Int(batteryLevel),
            activity: selectedActivity,
            note: note,
            mood: selectedMood
        )
        dismiss()
    }
}

struct BatterySliderSection: View {
    @Binding var level: Double
    
    var levelColor: Color {
        switch Int(level) {
        case 0..<20: return .red
        case 20..<40: return .orange
        case 40..<60: return .yellow
        case 60..<80: return .green
        default: return .purple
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(Int(level))%")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundColor(levelColor)
            
            Text(getLevelDescription())
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Slider(value: $level, in: 0...100, step: 5)
                .accentColor(levelColor)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    func getLevelDescription() -> String {
        switch Int(level) {
        case 0..<20: return "Completely drained 🪫"
        case 20..<40: return "Low energy 😔"
        case 40..<60: return "Moderate 😐"
        case 60..<80: return "Good energy 😊"
        case 80..<100: return "Highly charged ⚡️"
        default: return "Maximum power! 🔋"
        }
    }
}

struct ActivitySelectionSection: View {
    @Binding var selectedActivity: SocialActivity?
    
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What affected your battery?")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(SocialActivity.allCases, id: \.self) { activity in
                    ActivityButton(
                        activity: activity,
                        isSelected: selectedActivity == activity
                    ) {
                        if selectedActivity == activity {
                            selectedActivity = nil
                        } else {
                            selectedActivity = activity
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct ActivityButton: View {
    let activity: SocialActivity
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(activity.icon)
                    .font(.title2)
                Text(activity.rawValue)
                    .font(.caption2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(minWidth: 70, minHeight: 60)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .purple : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct MoodSelectionSection: View {
    @Binding var selectedMood: Mood?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How do you feel?")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        MoodButton(
                            mood: mood,
                            isSelected: selectedMood == mood
                        ) {
                            if selectedMood == mood {
                                selectedMood = nil
                            } else {
                                selectedMood = mood
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.icon)
                    .font(.title)
                Text(mood.rawValue)
                    .font(.caption)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .purple : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct NotesSection: View {
    @Binding var note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes (optional)")
                .font(.headline)
            
            TextEditor(text: $note)
                .frame(minHeight: 80)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    LogEntryView()
        .environmentObject(BatteryViewModel())
}
