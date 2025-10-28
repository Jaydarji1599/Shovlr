//
//  EditProfileView.swift
//  Shovlr
//
//  View for editing user profile information
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    let user: User

    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var isLoading = false

    init(user: User) {
        self.user = user
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email ?? "")
        _phone = State(initialValue: user.phone)
    }

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Colors.primary, Colors.accent]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        Text(name.prefix(1).uppercased())
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)

                    // Form fields
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Full Name",
                            placeholder: "John Doe",
                            text: $name,
                            icon: "person.fill",
                            autocapitalization: .words
                        )

                        CustomTextField(
                            title: "Phone Number",
                            placeholder: "902-555-1234",
                            text: $phone,
                            icon: "phone.fill",
                            keyboardType: .phonePad,
                            autocapitalization: .never
                        )

                        CustomTextField(
                            title: "Email (Optional)",
                            placeholder: "john@example.com",
                            text: $email,
                            icon: "envelope.fill",
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )
                    }

                    // Save button
                    PrimaryButton(
                        title: "Save Changes",
                        action: saveChanges,
                        isLoading: isLoading,
                        isDisabled: !isFormValid
                    )
                    .padding(.top, 20)

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isFormValid: Bool {
        !name.isEmpty && !phone.isEmpty
    }

    private func saveChanges() {
        isLoading = true

        Task {
            await authViewModel.updateUserInfo(
                name: name,
                email: email.isEmpty ? nil : email,
                phone: phone
            )
            isLoading = false
            dismiss()
        }
    }
}

extension AuthViewModel {
    func updateUserInfo(name: String, email: String?, phone: String) async {
        guard var user = currentUser else { return }

        user.name = name
        user.email = email
        user.phone = phone

        await updateUser(user)
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: User(
            name: "John Doe",
            email: "john@example.com",
            phone: "902-555-1234"
        ))
        .environmentObject(AuthViewModel())
    }
}
