//
//  RequestFormView.swift
//  Shovlr
//
//  Form for requesting snow removal service
//

import SwiftUI

struct RequestFormView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var orderViewModel: OrderViewModel

    @State private var showPaymentSheet = false
    @State private var showAddressEditor = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Welcome header
                VStack(alignment: .leading, spacing: 8) {
                    if let user = authViewModel.currentUser {
                        Text("Hello, \(user.name.components(separatedBy: " ").first ?? user.name)!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Ready to clear some snow?")
                            .font(.system(size: 16))
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)

                // Address card
                AddressCard(
                    address: authViewModel.currentUser?.defaultAddress,
                    onEdit: { showAddressEditor = true }
                )

                // Job type selector
                JobTypeSelector(selectedType: $orderViewModel.selectedJobType)

                // Snow depth selector
                SnowDepthSelector(selectedDepth: $orderViewModel.selectedSnowDepth)

                // Notes field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Special Instructions (Optional)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.textSecondary)

                    TextEditor(text: $orderViewModel.notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Colors.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Colors.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                }

                // Price display
                PriceDisplay(price: orderViewModel.calculatedPrice)

                // Request button
                PrimaryButton(
                    title: "Request Snow Removal",
                    action: {
                        showPaymentSheet = true
                    },
                    isLoading: orderViewModel.isLoading,
                    isDisabled: !orderViewModel.canRequestService,
                    icon: "snowflake"
                )
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showPaymentSheet) {
            if let user = authViewModel.currentUser,
               let address = user.defaultAddress {
                PaymentSheet(
                    amount: orderViewModel.calculatedPrice,
                    onComplete: { paymentMethod in
                        Task {
                            await orderViewModel.createOrder(
                                userId: user.id,
                                address: address,
                                paymentMethod: paymentMethod
                            )
                            showPaymentSheet = false
                        }
                    },
                    onCancel: {
                        showPaymentSheet = false
                    }
                )
            }
        }
        .sheet(isPresented: $showAddressEditor) {
            if let user = authViewModel.currentUser {
                AddressEditorView(
                    address: user.defaultAddress,
                    onSave: { address in
                        var updatedUser = user
                        updatedUser.defaultAddress = address
                        Task {
                            await authViewModel.updateUser(updatedUser)
                            showAddressEditor = false
                        }
                    },
                    onCancel: {
                        showAddressEditor = false
                    }
                )
            }
        }
        .alert("Success!", isPresented: $orderViewModel.showConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your snow removal request has been submitted!")
        }
        .alert("Error", isPresented: $orderViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = orderViewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

struct AddressCard: View {
    let address: Address?
    let onEdit: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Colors.primary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Service Address")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Colors.textSecondary)

                if let address = address {
                    Text(address.shortAddress)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Colors.textPrimary)
                } else {
                    Text("Add address")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Colors.error)
                }
            }

            Spacer()

            Button(action: onEdit) {
                Text(address == nil ? "Add" : "Edit")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Colors.primary)
            }
        }
        .padding()
        .background(Colors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(address == nil ? Colors.error : Colors.textSecondary.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        RequestFormView()
            .environmentObject(AuthViewModel())
            .environmentObject(OrderViewModel())
    }
}
