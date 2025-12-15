# Split Decision - Xcode Project

## Opening the Project

This is a SwiftUI-based iOS application. To open and run:

1. **Open in Xcode:**
   - Open Xcode (version 13.0 or later recommended)
   - File > Open > Select the `SplitDecision` folder
   - Or double-click `SplitDecision.xcworkspace` (once created)

2. **Build Settings:**
   - Target: iOS 15.0+
   - Language: Swift 5.5+
   - Framework: SwiftUI

3. **Run the App:**
   - Select a simulator (iPhone 13 or later)
   - Press ⌘R or click the Play button

## Project Structure

```
SplitDecision/
├── SplitDecisionApp.swift       # @main entry point
├── ContentView.swift             # Tab bar navigation
├── Models/
│   ├── Decision.swift            # Core data model
│   └── User.swift                # User model
├── ViewModels/
│   ├── DecisionManager.swift    # ObservableObject for decisions
│   └── UserManager.swift         # ObservableObject for user state
└── Views/
    ├── HomeView.swift
    ├── CreateDecisionView.swift
    ├── DecisionCard.swift
    ├── DecisionDetailView.swift
    ├── HistoryView.swift
    ├── ProfileView.swift
    └── PremiumUpgradeView.swift
```

## Key Features Implemented

✅ **Core Functionality:**
- Create decisions with 2-4 options
- Public/private decision toggle
- Category selection (Fashion, Food, Dating, etc.)
- Optional decision timer
- Real-time voting simulation
- Decision history

✅ **UI Components:**
- Tab-based navigation
- Category filtering
- Decision cards with progress bars
- Detailed decision view
- Profile and statistics
- Premium upgrade flow

✅ **Business Logic:**
- Free tier: 10 decisions/month
- Premium tier: Unlimited decisions
- Sample data included for demo

## Next Steps for Production

### 1. Backend Integration
Currently using local storage. Add:
- Firebase Authentication
- Cloud Firestore for decisions
- Real-time database sync
- Push notifications

### 2. Monetization
- Integrate RevenueCat for subscriptions
- Add Google AdMob for ads
- Implement in-app purchase flow

### 3. Social Features
- User accounts and authentication
- Follow/unfollow users
- Comments on decisions
- Share functionality (currently placeholder)

### 4. App Store Submission
- Add app icons (1024x1024)
- Create launch screen
- Privacy policy and terms
- App Store screenshots
- Metadata and descriptions

### 5. Analytics
- Firebase Analytics
- Track user behavior
- A/B testing framework
- Conversion tracking

## Dependencies (Future)

When setting up for production, add via Swift Package Manager:

```
- Firebase iOS SDK
- RevenueCat SDK  
- Google Mobile Ads SDK
```

## Build & Run

Currently this is a pure SwiftUI app with no external dependencies, so it should run immediately in Xcode.

**Minimum Requirements:**
- Xcode 13.0+
- iOS 15.0+
- macOS 11.0+ (for development)

## Testing

The app includes sample data to test all features:
- 3 pre-loaded decisions
- Sample user account
- All UI states (empty, loading, populated)

## Notes

This is an MVP implementation demonstrating:
- Clean SwiftUI architecture
- MVVM pattern
- Reusable components
- Professional UI/UX
- Scalable structure

Ready for TestFlight beta testing and iteration based on user feedback!
