//
//  ProfileView.swift
//  Shovlr
//
//  User profile and settings view
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var profileViewModel: ProfileViewModel

    @State private var showLogoutConfirmation = false

    init() {
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Profile header
                        if let user = authViewModel.currentUser {
                            ProfileHeader(user: user)
                                .padding(.top, 20)

                            // Account section
                            VStack(spacing: 12) {
                                SectionTitle(title: "Account")

                                NavigationLink(destination: EditProfileView(user: user)) {
                                    SettingsRow(
                                        icon: "person.fill",
                                        title: "Personal Information",
                                        value: user.name
                                    )
                                }

                                NavigationLink(destination: AddressManagementView(user: user)) {
                                    SettingsRow(
                                        icon: "house.fill",
                                        title: "Service Address",
                                        value: user.defaultAddress?.shortAddress ?? "Not set"
                                    )
                                }

                                NavigationLink(destination: PaymentMethodView(user: user)) {
                                    SettingsRow(
                                        icon: "creditcard.fill",
                                        title: "Payment Method",
                                        value: user.paymentMethodDisplay ?? "Not set"
                                    )
                                }
                            }

                            // Notifications section
                            VStack(spacing: 12) {
                                SectionTitle(title: "Notifications")

                                NotificationToggleRow(
                                    icon: "bell.fill",
                                    title: "Push Notifications",
                                    isOn: Binding(
                                        get: { user.notifyByPush },
                                        set: { newValue in
                                            profileViewModel.updateNotificationPreferences(
                                                sms: user.notifyBySMS,
                                                push: newValue
                                            )
                                        }
                                    )
                                )

                                NotificationToggleRow(
                                    icon: "message.fill",
                                    title: "SMS Notifications",
                                    isOn: Binding(
                                        get: { user.notifyBySMS },
                                        set: { newValue in
                                            profileViewModel.updateNotificationPreferences(
                                                sms: newValue,
                                                push: user.notifyByPush
                                            )
                                        }
                                    )
                                )
                            }

                            // Support section
                            VStack(spacing: 12) {
                                SectionTitle(title: "Support")

                                Button(action: {
                                    if let url = URL(string: "tel://\(AppConstants.supportPhone)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    SettingsRow(
                                        icon: "phone.fill",
                                        title: "Call Support",
                                        value: AppConstants.supportPhone
                                    )
                                }

                                Button(action: {
                                    if let url = URL(string: "mailto:\(AppConstants.supportEmail)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    SettingsRow(
                                        icon: "envelope.fill",
                                        title: "Email Support",
                                        value: AppConstants.supportEmail
                                    )
                                }
                            }

                            // About section
                            VStack(spacing: 12) {
                                SectionTitle(title: "About")

                                NavigationLink(destination: Text("Terms of Service")) {
                                    SettingsRow(
                                        icon: "doc.text.fill",
                                        title: "Terms of Service",
                                        value: ""
                                    )
                                }

                                NavigationLink(destination: Text("Privacy Policy")) {
                                    SettingsRow(
                                        icon: "lock.shield.fill",
                                        title: "Privacy Policy",
                                        value: ""
                                    )
                                }

                                SettingsRow(
                                    icon: "info.circle.fill",
                                    title: "App Version",
                                    value: "1.0.0"
                                )
                            }

                            // Logout button
                            Button(action: {
                                showLogoutConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square.fill")
                                        .foregroundColor(Colors.error)
                                    Text("Log Out")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Colors.error)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Colors.cardBackground)
                                .cornerRadius(12)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                profileViewModel.user = authViewModel.currentUser
            }
            .confirmationDialog("Log Out", isPresented: $showLogoutConfirmation) {
                Button("Log Out", role: .destructive) {
                    authViewModel.logout()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

struct ProfileHeader: View {
    let user: User

    var body: some View {
        VStack(spacing: 16) {
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

                Text(user.name.prefix(1).uppercased())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }

            // Name
            Text(user.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Colors.textPrimary)

            // Phone
            Text(user.phone)
                .font(.system(size: 16))
                .foregroundColor(Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Colors.cardBackground)
        .cornerRadius(16)
    }
}

struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Colors.textSecondary)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Colors.primary)
                .frame(width: 30)

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Colors.textPrimary)

            Spacer()

            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(Colors.textSecondary)
                    .lineLimit(1)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Colors.textSecondary)
        }
        .padding()
        .background(Colors.cardBackground)
        .cornerRadius(12)
    }
}

struct NotificationToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Colors.primary)
                .frame(width: 30)

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Colors.textPrimary)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Colors.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
