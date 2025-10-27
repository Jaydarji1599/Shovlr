//
//  JobType.swift
//  Shovlr
//
//  Enum representing the type of snow removal job
//

import Foundation

enum JobType: String, Codable, CaseIterable {
    case driveway = "Driveway"
    case walkway = "Walkway"
    case both = "Driveway & Walkway"
    case fullProperty = "Full Property"

    var description: String {
        self.rawValue
    }

    var icon: String {
        switch self {
        case .driveway:
            return "car.fill"
        case .walkway:
            return "figure.walk"
        case .both:
            return "house.fill"
        case .fullProperty:
            return "building.2.fill"
        }
    }
}

enum SnowDepth: String, Codable, CaseIterable {
    case light = "Light"
    case moderate = "Moderate"
    case heavy = "Heavy"

    var description: String {
        switch self {
        case .light:
            return "Light (<5cm)"
        case .moderate:
            return "Moderate (5-15cm)"
        case .heavy:
            return "Heavy (>15cm)"
        }
    }

    var icon: String {
        switch self {
        case .light:
            return "snow"
        case .moderate:
            return "snowflake"
        case .heavy:
            return "wind.snow"
        }
    }
}
