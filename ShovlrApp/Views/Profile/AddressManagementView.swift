//
//  AddressManagementView.swift
//  Shovlr
//
//  View for managing service address
//

import SwiftUI

struct AddressManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    let user: User

    @State private var showAddressEditor = false

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            VStack(spacing: 24) {
                if let address = user.defaultAddress {
                    // Current address card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Current Address")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Colors.primary)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(address.streetLine1)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Colors.textPrimary)

                                    if let line2 = address.streetLine2, !line2.isEmpty {
                                        Text(line2)
                                            .font(.system(size: 14))
                                            .foregroundColor(Colors.textSecondary)
                                    }

                                    Text("\(address.city), \(address.province) \(address.postalCode)")
                                        .font(.system(size: 14))
                                        .foregroundColor(Colors.textSecondary)
                                }

                                Spacer()
                            }
                        }
                        .padding()
                        .background(Colors.cardBackground)
                        .cornerRadius(12)
                    }
                    .padding()

                    PrimaryButton(title: "Edit Address") {
                        showAddressEditor = true
                    }
                    .padding(.horizontal)
                } else {
                    // No address set
                    VStack(spacing: 20) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Colors.textSecondary.opacity(0.5))

                        Text("No address set")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Add your service address to request snow removal")
                            .font(.system(size: 16))
                            .foregroundColor(Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        PrimaryButton(title: "Add Address") {
                            showAddressEditor = true
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Service Address")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddressEditor) {
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
}

#Preview {
    NavigationStack {
        AddressManagementView(user: User(
            name: "John Doe",
            phone: "902-555-1234",
            defaultAddress: Address(
                streetLine1: "123 Main St",
                city: "Halifax",
                province: "NS",
                postalCode: "B3H 1A1"
            )
        ))
        .environmentObject(AuthViewModel())
    }
}
