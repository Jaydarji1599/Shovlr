//
//  Payment.swift
//  Shovlr
//
//  Model representing payment information
//

import Foundation

enum PaymentStatus: String, Codable {
    case pending = "Pending"
    case succeeded = "Succeeded"
    case failed = "Failed"
    case refunded = "Refunded"
}

struct PaymentMethod: Codable, Identifiable {
    let id: String
    let type: String // "Visa", "Mastercard", "Apple Pay", etc.
    let last4: String
    let expiryMonth: Int?
    let expiryYear: Int?
    let isDefault: Bool

    var displayName: String {
        "\(type) •••• \(last4)"
    }

    var expiryDisplay: String? {
        guard let month = expiryMonth, let year = expiryYear else { return nil }
        return String(format: "%02d/%02d", month, year % 100)
    }
}

struct Payment: Codable, Identifiable {
    let id: String
    let jobId: String
    let amount: Double
    let status: PaymentStatus
    let paymentMethod: PaymentMethod?
    let processedAt: Date
    let refundedAt: Date?

    var formattedAmount: String {
        String(format: "$%.2f", amount)
    }
}
