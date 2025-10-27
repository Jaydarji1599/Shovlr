//
//  WelcomeView.swift
//  Shovlr
//
//  Initial welcome screen with login/signup options
//

import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var showSignup = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Colors.primary.opacity(0.1), Colors.background]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // App logo and name
                    VStack(spacing: 20) {
                        Image(systemName: "snowflake")
                            .font(.system(size: 80))
                            .foregroundColor(Colors.primary)

                        Text("Shovlr")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Colors.textPrimary)

                        Text("Snow removal at your fingertips")
                            .font(.system(size: 18))
                            .foregroundColor(Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    // Action buttons
                    VStack(spacing: 16) {
                        PrimaryButton(title: "Create Account") {
                            showSignup = true
                        }

                        SecondaryButton(title: "Log In") {
                            showLogin = true
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $showSignup) {
                SignupView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
