//
//  PaymentService.swift
//  Shovlr
//
//  Service for handling payment processing
//  TODO: Integrate with Stripe SDK or Apple Pay when backend is ready
//

import Foundation
import PassKit

class PaymentService {
    static let shared = PaymentService()

    private init() {}

    // MARK: - Payment Processing (Stubbed)

    func processPayment(amount: Double, cardNumber: String, expiryMonth: Int, expiryYear: Int, cvv: String) async throws -> Payment {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

        // Validate card number (basic check)
        guard cardNumber.count >= 13 else {
            throw APIError.paymentFailed
        }

        // For MVP, always succeed
        let last4 = String(cardNumber.suffix(4))
        let cardType = determineCardType(cardNumber)

        let paymentMethod = PaymentMethod(
            id: UUID().uuidString,
            type: cardType,
            last4: last4,
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            isDefault: true
        )

        let payment = Payment(
            id: UUID().uuidString,
            jobId: "",
            amount: amount,
            status: .succeeded,
            paymentMethod: paymentMethod,
            processedAt: Date(),
            refundedAt: nil
        )

        print("💳 [Payment] Processed successfully: \(payment.formattedAmount) via \(paymentMethod.displayName)")

        return payment
    }

    func savePaymentMethod(cardNumber: String, expiryMonth: Int, expiryYear: Int) -> PaymentMethod {
        let last4 = String(cardNumber.suffix(4))
        let cardType = determineCardType(cardNumber)

        return PaymentMethod(
            id: UUID().uuidString,
            type: cardType,
            last4: last4,
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            isDefault: true
        )
    }

    private func determineCardType(_ cardNumber: String) -> String {
        let firstDigit = cardNumber.prefix(1)
        switch firstDigit {
        case "4":
            return "Visa"
        case "5":
            return "Mastercard"
        case "3":
            return "Amex"
        case "6":
            return "Discover"
        default:
            return "Card"
        }
    }

    // MARK: - Apple Pay Support (Stub)

    func canMakeApplePayments() -> Bool {
        // Check if device supports Apple Pay
        return PKPaymentAuthorizationController.canMakePayments()
    }

    func processApplePayPayment(amount: Double) async throws -> Payment {
        // TODO: Implement Apple Pay integration
        // For now, simulate success

        try await Task.sleep(nanoseconds: 1_000_000_000)

        let paymentMethod = PaymentMethod(
            id: UUID().uuidString,
            type: "Apple Pay",
            last4: "****",
            expiryMonth: nil,
            expiryYear: nil,
            isDefault: true
        )

        let payment = Payment(
            id: UUID().uuidString,
            jobId: "",
            amount: amount,
            status: .succeeded,
            paymentMethod: paymentMethod,
            processedAt: Date(),
            refundedAt: nil
        )

        print("💳 [Apple Pay] Processed successfully: \(payment.formattedAmount)")

        return payment
    }

    // MARK: - Payment Validation

    func validateCardNumber(_ cardNumber: String) -> Bool {
        let cleaned = cardNumber.replacingOccurrences(of: " ", with: "")
        return cleaned.count >= 13 && cleaned.count <= 19 && cleaned.allSatisfy { $0.isNumber }
    }

    func validateCVV(_ cvv: String) -> Bool {
        return cvv.count >= 3 && cvv.count <= 4 && cvv.allSatisfy { $0.isNumber }
    }

    func validateExpiry(month: Int, year: Int) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)

        if year < currentYear {
            return false
        } else if year == currentYear {
            return month >= currentMonth
        }
        return true
    }
}
