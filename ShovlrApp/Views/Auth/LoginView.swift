//
//  LoginView.swift
//  Shovlr
//
//  User login screen
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var phone = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Log in to request snow removal")
                            .font(.system(size: 16))
                            .foregroundColor(Colors.textSecondary)
                    }
                    .padding(.top, 40)

                    // Input fields
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Phone Number",
                            placeholder: "902-555-1234",
                            text: $phone,
                            icon: "phone.fill",
                            keyboardType: .phonePad,
                            autocapitalization: .never
                        )

                        CustomSecureField(
                            title: "Password",
                            placeholder: "Enter your password",
                            text: $password,
                            icon: "lock.fill"
                        )
                    }
                    .padding(.top, 20)

                    // Login button
                    PrimaryButton(
                        title: "Log In",
                        action: {
                            Task {
                                await authViewModel.login(phone: phone, password: password)
                                if authViewModel.isAuthenticated {
                                    dismiss()
                                }
                            }
                        },
                        isLoading: authViewModel.isLoading,
                        isDisabled: !isFormValid
                    )
                    .padding(.top, 20)

                    // Forgot password (placeholder for future)
                    Button("Forgot Password?") {
                        // TODO: Implement password reset
                    }
                    .foregroundColor(Colors.primary)
                    .font(.system(size: 14))

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }

    private var isFormValid: Bool {
        !phone.isEmpty && !password.isEmpty
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
