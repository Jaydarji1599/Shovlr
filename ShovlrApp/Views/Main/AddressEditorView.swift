//
//  AddressEditorView.swift
//  Shovlr
//
//  View for editing service address
//

import SwiftUI

struct AddressEditorView: View {
    let address: Address?
    let onSave: (Address) -> Void
    let onCancel: () -> Void

    @State private var streetLine1: String
    @State private var streetLine2: String
    @State private var city: String
    @State private var province: String
    @State private var postalCode: String

    init(address: Address?, onSave: @escaping (Address) -> Void, onCancel: @escaping () -> Void) {
        self.address = address
        self.onSave = onSave
        self.onCancel = onCancel

        _streetLine1 = State(initialValue: address?.streetLine1 ?? "")
        _streetLine2 = State(initialValue: address?.streetLine2 ?? "")
        _city = State(initialValue: address?.city ?? "Halifax")
        _province = State(initialValue: address?.province ?? "NS")
        _postalCode = State(initialValue: address?.postalCode ?? "")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.background.ignoresSafeArea()

                ScrollView {
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

                        PrimaryButton(
                            title: "Save Address",
                            action: saveAddress,
                            isDisabled: !isFormValid
                        )
                        .padding(.top, 20)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Address")
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
        !streetLine1.isEmpty &&
        !city.isEmpty &&
        !province.isEmpty &&
        !postalCode.isEmpty
    }

    private func saveAddress() {
        let newAddress = Address(
            id: address?.id ?? UUID(),
            streetLine1: streetLine1,
            streetLine2: streetLine2.isEmpty ? nil : streetLine2,
            city: city,
            province: province,
            postalCode: postalCode
        )
        onSave(newAddress)
    }
}

#Preview {
    AddressEditorView(
        address: nil,
        onSave: { _ in },
        onCancel: {}
    )
}
