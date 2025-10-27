//
//  PaymentMethodView.swift
//  Shovlr
//
//  View for managing payment methods
//

import SwiftUI

struct PaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var profileViewModel: ProfileViewModel

    let user: User

    @State private var showPaymentEditor = false

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            VStack(spacing: 24) {
                if user.hasPaymentMethod {
                    // Current payment method card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Current Payment Method")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        HStack(spacing: 16) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Colors.primary)

                            VStack(alignment: .leading, spacing: 4) {
                                if let display = user.paymentMethodDisplay {
                                    Text(display)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Colors.textPrimary)
                                }

                                Text("Default payment method")
                                    .font(.system(size: 14))
                                    .foregroundColor(Colors.textSecondary)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Colors.cardBackground)
                        .cornerRadius(12)
                    }
                    .padding()

                    PrimaryButton(title: "Update Payment Method") {
                        showPaymentEditor = true
                    }
                    .padding(.horizontal)
                } else {
                    // No payment method
                    VStack(spacing: 20) {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Colors.textSecondary.opacity(0.5))

                        Text("No payment method")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Add a payment method for quick checkout")
                            .font(.system(size: 16))
                            .foregroundColor(Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        PrimaryButton(title: "Add Payment Method") {
                            showPaymentEditor = true
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Payment Method")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaymentEditor) {
            PaymentMethodEditor(
                onSave: { paymentMethod in
                    profileViewModel.updatePaymentMethod(paymentMethod)
                    // Also update the authViewModel's user
                    if var updatedUser = authViewModel.currentUser {
                        updatedUser.paymentMethodLast4 = paymentMethod.last4
                        updatedUser.paymentMethodType = paymentMethod.type
                        Task {
                            await authViewModel.updateUser(updatedUser)
                        }
                    }
                    showPaymentEditor = false
                },
                onCancel: {
                    showPaymentEditor = false
                }
            )
        }
    }
}

struct PaymentMethodEditor: View {
    let onSave: (PaymentMethod) -> Void
    let onCancel: () -> Void

    @State private var cardNumber = ""
    @State private var expiryMonth = ""
    @State private var expiryYear = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Colors.primary)
                            .padding(.top, 20)

                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Card Number",
                                placeholder: "1234 5678 9012 3456",
                                text: $cardNumber,
                                icon: "creditcard",
                                keyboardType: .numberPad,
                                autocapitalization: .never
                            )

                            HStack(spacing: 12) {
                                CustomTextField(
                                    title: "Expiry Month",
                                    placeholder: "MM",
                                    text: $expiryMonth,
                                    keyboardType: .numberPad,
                                    autocapitalization: .never
                                )

                                CustomTextField(
                                    title: "Expiry Year",
                                    placeholder: "YY",
                                    text: $expiryYear,
                                    keyboardType: .numberPad,
                                    autocapitalization: .never
                                )
                            }
                        }

                        PrimaryButton(
                            title: "Save Payment Method",
                            action: savePaymentMethod,
                            isDisabled: !isFormValid
                        )
                        .padding(.top, 20)

                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(Colors.textSecondary)
                }
            }
        }
    }

    private var isFormValid: Bool {
        let cardDigits = cardNumber.filter { $0.isNumber }
        return cardDigits.count >= 13 &&
               expiryMonth.count == 2 &&
               expiryYear.count == 2
    }

    private func savePaymentMethod() {
        let cardDigits = cardNumber.filter { $0.isNumber }
        guard let month = Int(expiryMonth), let year = Int(expiryYear) else { return }

        let paymentMethod = PaymentService.shared.savePaymentMethod(
            cardNumber: cardDigits,
            expiryMonth: month,
            expiryYear: 2000 + year
        )

        onSave(paymentMethod)
    }
}

#Preview {
    NavigationStack {
        PaymentMethodView(user: User(
            name: "John Doe",
            phone: "902-555-1234"
        ))
        .environmentObject(AuthViewModel())
    }
}
