//
//  AddressSetupView.swift
//  Shovlr
//
//  Initial address setup after signup
//

import SwiftUI

struct AddressSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var streetLine1 = ""
    @State private var streetLine2 = ""
    @State private var city = "Halifax"
    @State private var province = "NS"
    @State private var postalCode = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Colors.primary)

                        Text("Service Address")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Where do you need snow removal?")
                            .font(.system(size: 16))
                            .foregroundColor(Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)

                    // Input fields
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Street Address",
                            placeholder: "123 Main St",
                            text: $streetLine1,
                            icon: "mappin.circle.fill"
                        )

                        CustomTextField(
                            title: "Apt/Unit (Optional)",
                            placeholder: "Apt 4B",
                            text: $streetLine2,
                            icon: "building.2.fill"
                        )

                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "City",
                                placeholder: "Halifax",
                                text: $city
                            )

                            CustomTextField(
                                title: "Province",
                                placeholder: "NS",
                                text: $province,
                                autocapitalization: .characters
                            )
                            .frame(maxWidth: 100)
                        }

                        CustomTextField(
                            title: "Postal Code",
                            placeholder: "B3H 1A1",
                            text: $postalCode,
                            autocapitalization: .characters
                        )
                    }
                    .padding(.top, 20)

                    // Save button
                    PrimaryButton(
                        title: "Save Address",
                        action: saveAddress,
                        isLoading: isLoading,
                        isDisabled: !isFormValid
                    )
                    .padding(.top, 20)

                    // Skip for now
                    Button("Skip for now") {
                        dismiss()
                    }
                    .foregroundColor(Colors.textSecondary)
                    .font(.system(size: 14))

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private var isFormValid: Bool {
        !streetLine1.isEmpty &&
        !city.isEmpty &&
        !province.isEmpty &&
        !postalCode.isEmpty
    }

    private func saveAddress() {
        guard var user = authViewModel.currentUser else { return }

        isLoading = true

        let address = Address(
            streetLine1: streetLine1,
            streetLine2: streetLine2.isEmpty ? nil : streetLine2,
            city: city,
            province: province,
            postalCode: postalCode
        )

        user.defaultAddress = address

        Task {
            await authViewModel.updateUser(user)
            isLoading = false
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        AddressSetupView()
            .environmentObject(AuthViewModel())
    }
}
