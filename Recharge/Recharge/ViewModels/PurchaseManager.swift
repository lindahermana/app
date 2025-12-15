//
//  PurchaseManager.swift
//  Recharge
//
//  Handles In-App Purchases for Premium features
//

import Foundation
import StoreKit

class PurchaseManager: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var products: [Product] = []
    @Published var purchaseInProgress: Bool = false
    
    private let productIDs = [
        "com.recharge.premium.monthly",
        "com.recharge.premium.yearly",
        "com.recharge.premium.lifetime"
    ]
    
    enum PremiumPlan: String, CaseIterable {
        case monthly = "com.recharge.premium.monthly"
        case yearly = "com.recharge.premium.yearly"
        case lifetime = "com.recharge.premium.lifetime"
        
        var displayName: String {
            switch self {
            case .monthly: return "Monthly"
            case .yearly: return "Yearly (Save 40%)"
            case .lifetime: return "Lifetime"
            }
        }
        
        var price: String {
            switch self {
            case .monthly: return "$2.99/mo"
            case .yearly: return "$19.99/yr"
            case .lifetime: return "$49.99"
            }
        }
        
        var description: String {
            switch self {
            case .monthly: return "Best for trying out"
            case .yearly: return "Most Popular"
            case .lifetime: return "Best Value"
            }
        }
    }
    
    init() {
        checkPremiumStatus()
    }
    
    func checkPremiumStatus() {
        // Check UserDefaults or Keychain for premium status
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
    }
    
    @MainActor
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ plan: PremiumPlan) async -> Bool {
        purchaseInProgress = true
        defer { purchaseInProgress = false }
        
        guard let product = products.first(where: { $0.id == plan.rawValue }) else {
            return false
        }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(_):
                    isPremium = true
                    UserDefaults.standard.set(true, forKey: "isPremium")
                    return true
                case .unverified(_, _):
                    return false
                }
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkEntitlements()
        } catch {
            print("Restore failed: \(error)")
        }
    }
    
    @MainActor
    func checkEntitlements() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(_):
                isPremium = true
                UserDefaults.standard.set(true, forKey: "isPremium")
            case .unverified(_, _):
                break
            }
        }
    }
    
    // MARK: - Premium Features
    
    var premiumFeatures: [String] {
        [
            "📊 Advanced Analytics & Patterns",
            "🎯 Personalized Recommendations",
            "📅 Unlimited History Access",
            "🔔 Smart Battery Notifications",
            "🎨 Custom Themes & Icons",
            "📤 Export Your Data",
            "🏆 Exclusive Achievements",
            "💫 Priority Support"
        ]
    }
}
