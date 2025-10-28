//
//  User.swift
//  Shovlr
//
//  Model representing a user account
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var name: String
    var email: String?
    var phone: String
    var defaultAddress: Address?
    var paymentMethodLast4: String?
    var paymentMethodType: String?
    var notifyBySMS: Bool
    var notifyByPush: Bool
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        name: String,
        email: String? = nil,
        phone: String,
        defaultAddress: Address? = nil,
        paymentMethodLast4: String? = nil,
        paymentMethodType: String? = nil,
        notifyBySMS: Bool = true,
        notifyByPush: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.defaultAddress = defaultAddress
        self.paymentMethodLast4 = paymentMethodLast4
        self.paymentMethodType = paymentMethodType
        self.notifyBySMS = notifyBySMS
        self.notifyByPush = notifyByPush
        self.createdAt = createdAt
    }

    var hasPaymentMethod: Bool {
        paymentMethodLast4 != nil
    }

    var paymentMethodDisplay: String? {
        guard let last4 = paymentMethodLast4 else { return nil }
        let type = paymentMethodType ?? "Card"
        return "\(type) •••• \(last4)"
    }
}
