//
//  Constants.swift
//  Shovlr
//
//  App-wide constants and configuration
//

import Foundation
import SwiftUI

enum AppConstants {
    // App Info
    static let appName = "Shovlr"
    static let supportPhone = "1-902-555-SNOW"
    static let supportEmail = "support@shovlr.ca"

    // Service Area
    static let defaultCity = "Halifax"
    static let defaultProvince = "NS"

    // Timing (for demo/stub purposes)
    static let statusUpdateDelay: TimeInterval = 10 // seconds between status updates in demo
    static let autoCompleteDelay: TimeInterval = 30 // seconds until auto-complete in demo
}

enum Colors {
    // Winter-themed color palette
    static let primary = Color(red: 0.2, green: 0.5, blue: 0.8) // Winter Blue
    static let secondary = Color(red: 1.0, green: 0.6, blue: 0.2) // Warm Orange
    static let accent = Color(red: 0.3, green: 0.7, blue: 0.9) // Light Blue
    static let background = Color(red: 0.98, green: 0.98, blue: 1.0) // Snow White
    static let cardBackground = Color.white
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.2) // Near Black
    static let textSecondary = Color.gray
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}

enum PricingEngine {
    // Base pricing structure for MVP
    // In production, this would come from backend API

    private static let basePrice: Double = 25.0

    private static let jobTypeMultipliers: [JobType: Double] = [
        .driveway: 1.0,
        .walkway: 0.6,
        .both: 1.5,
        .fullProperty: 2.0
    ]

    private static let snowDepthMultipliers: [SnowDepth: Double] = [
        .light: 1.0,
        .moderate: 1.3,
        .heavy: 1.8
    ]

    static func calculatePrice(jobType: JobType, snowDepth: SnowDepth) -> Double {
        let jobMultiplier = jobTypeMultipliers[jobType] ?? 1.0
        let snowMultiplier = snowDepthMultipliers[snowDepth] ?? 1.0
        let price = basePrice * jobMultiplier * snowMultiplier

        // Round to nearest $5
        return (price / 5.0).rounded() * 5.0
    }

    static func getPriceBreakdown(jobType: JobType, snowDepth: SnowDepth) -> String {
        """
        Base Price: $\(String(format: "%.0f", basePrice))
        Job Type: \(jobType.rawValue) (×\(jobTypeMultipliers[jobType] ?? 1.0))
        Snow Depth: \(snowDepth.rawValue) (×\(snowDepthMultipliers[snowDepth] ?? 1.0))
        """
    }
}
