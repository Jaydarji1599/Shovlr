//
//  SignupView.swift
//  Shovlr
//
//  User signup screen
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAddressSetup = false

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Sign up to get started")
                            .font(.system(size: 16))
                            .foregroundColor(Colors.textSecondary)
                    }
                    .padding(.top, 40)

                    // Input fields
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

                        CustomSecureField(
                            title: "Password",
                            placeholder: "Create a password",
                            text: $password,
                            icon: "lock.fill"
                        )

                        CustomSecureField(
                            title: "Confirm Password",
                            placeholder: "Re-enter password",
                            text: $confirmPassword,
                            icon: "lock.fill"
                        )
                    }
                    .padding(.top, 20)

                    // Password mismatch warning
                    if !confirmPassword.isEmpty && password != confirmPassword {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Passwords do not match")
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Colors.error)
                        .padding(.horizontal, 12)
                    }

                    // Signup button
                    PrimaryButton(
                        title: "Sign Up",
                        action: {
                            Task {
                                await authViewModel.signup(
                                    name: name,
                                    phone: phone,
                                    email: email.isEmpty ? nil : email,
                                    password: password
                                )
                                if authViewModel.isAuthenticated {
                                    showAddressSetup = true
                                }
                            }
                        },
                        isLoading: authViewModel.isLoading,
                        isDisabled: !isFormValid
                    )
                    .padding(.top, 20)

                    // Terms notice
                    Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                        .font(.system(size: 12))
                        .foregroundColor(Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showAddressSetup) {
            AddressSetupView()
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }

    private var isFormValid: Bool {
        !name.isEmpty &&
        !phone.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }
}

#Preview {
    NavigationStack {
        SignupView()
            .environmentObject(AuthViewModel())
    }
}
