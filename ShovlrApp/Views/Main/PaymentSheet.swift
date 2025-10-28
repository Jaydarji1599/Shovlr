//
//  PaymentSheet.swift
//  Shovlr
//
//  Payment entry sheet for processing orders
//

import SwiftUI

struct PaymentSheet: View {
    let amount: Double
    let onComplete: (PaymentMethod?) -> Void
    let onCancel: () -> Void

    @State private var cardNumber = ""
    @State private var expiryMonth = ""
    @State private var expiryYear = ""
    @State private var cvv = ""
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Colors.primary)

                            Text("Payment")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Colors.textPrimary)

                            Text("Total: \(formattedAmount)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Colors.secondary)
                        }
                        .padding(.top, 20)

                        // Payment form
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Card Number",
                                placeholder: "1234 5678 9012 3456",
                                text: $cardNumber,
                                icon: "creditcard",
                                keyboardType: .numberPad,
                                autocapitalization: .never
                            )
                            .onChange(of: cardNumber) { oldValue, newValue in
                                // Format card number with spaces
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count <= 16 {
                                    let formatted = filtered.enumerated().map { index, char -> String in
                                        if index > 0 && index % 4 == 0 {
                                            return " \(char)"
                                        }
                                        return String(char)
                                    }.joined()
                                    if formatted != newValue {
                                        cardNumber = formatted
                                    }
                                }
                            }

                            HStack(spacing: 12) {
                                CustomTextField(
                                    title: "Expiry Month",
                                    placeholder: "MM",
                                    text: $expiryMonth,
                                    keyboardType: .numberPad,
                                    autocapitalization: .never
                                )
                                .onChange(of: expiryMonth) { oldValue, newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    expiryMonth = String(filtered.prefix(2))
                                }

                                CustomTextField(
                                    title: "Expiry Year",
                                    placeholder: "YY",
                                    text: $expiryYear,
                                    keyboardType: .numberPad,
                                    autocapitalization: .never
                                )
                                .onChange(of: expiryYear) { oldValue, newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    expiryYear = String(filtered.prefix(2))
                                }

                                CustomTextField(
                                    title: "CVV",
                                    placeholder: "123",
                                    text: $cvv,
                                    icon: "lock.fill",
                                    keyboardType: .numberPad,
                                    autocapitalization: .never
                                )
                                .onChange(of: cvv) { oldValue, newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    cvv = String(filtered.prefix(4))
                                }
                            }
                        }

                        // Security note
                        HStack(spacing: 8) {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(Colors.success)
                            Text("Your payment information is secure and encrypted")
                                .font(.system(size: 12))
                                .foregroundColor(Colors.textSecondary)
                        }
                        .padding()
                        .background(Colors.success.opacity(0.1))
                        .cornerRadius(8)

                        // Pay button
                        PrimaryButton(
                            title: "Pay \(formattedAmount)",
                            action: processPayment,
                            isLoading: isProcessing,
                            isDisabled: !isFormValid,
                            icon: "checkmark.circle.fill"
                        )
                        .padding(.top, 10)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(Colors.textSecondary)
                }
            }
            .alert("Payment Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var formattedAmount: String {
        String(format: "$%.2f", amount)
    }

    private var isFormValid: Bool {
        let cardDigits = cardNumber.filter { $0.isNumber }
        return cardDigits.count >= 13 &&
               expiryMonth.count == 2 &&
               expiryYear.count == 2 &&
               cvv.count >= 3 &&
               validateExpiry()
    }

    private func validateExpiry() -> Bool {
        guard let month = Int(expiryMonth), let year = Int(expiryYear) else {
            return false
        }

        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())

        if month < 1 || month > 12 {
            return false
        }

        if year < currentYear {
            return false
        } else if year == currentYear && month < currentMonth {
            return false
        }

        return true
    }

    private func processPayment() {
        isProcessing = true

        Task {
            do {
                let cardDigits = cardNumber.filter { $0.isNumber }
                guard let month = Int(expiryMonth), let year = Int(expiryYear) else {
                    throw APIError.paymentFailed
                }

                _ = try await PaymentService.shared.processPayment(
                    amount: amount,
                    cardNumber: cardDigits,
                    expiryMonth: month,
                    expiryYear: 2000 + year,
                    cvv: cvv
                )

                let paymentMethod = PaymentService.shared.savePaymentMethod(
                    cardNumber: cardDigits,
                    expiryMonth: month,
                    expiryYear: 2000 + year
                )

                await MainActor.run {
                    isProcessing = false
                    onComplete(paymentMethod)
                }
            } catch {
                await MainActor.run {
                    isProcessing = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

#Preview {
    PaymentSheet(
        amount: 45.0,
        onComplete: { _ in },
        onCancel: {}
    )
}
