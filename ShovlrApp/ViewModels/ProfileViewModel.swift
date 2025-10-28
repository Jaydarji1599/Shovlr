//
//  ProfileViewModel.swift
//  Shovlr
//
//  ViewModel for managing user profile and settings
//

import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showAddressEditor = false
    @Published var showPaymentEditor = false

    init(user: User? = nil) {
        self.user = user
    }

    func updateAddress(_ address: Address) async {
        guard var user = user else { return }

        isLoading = true
        errorMessage = nil

        do {
            let updatedAddress = try await APIClient.shared.updateAddress(address, for: user.id)
            user.defaultAddress = updatedAddress
            self.user = user
            StorageService.shared.saveUser(user)
            showAddressEditor = false
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }

    func updatePaymentMethod(_ paymentMethod: PaymentMethod) {
        guard var user = user else { return }

        user.paymentMethodLast4 = paymentMethod.last4
        user.paymentMethodType = paymentMethod.type
        self.user = user
        StorageService.shared.saveUser(user)
        showPaymentEditor = false
    }

    func updateNotificationPreferences(sms: Bool, push: Bool) {
        guard var user = user else { return }

        user.notifyBySMS = sms
        user.notifyByPush = push
        self.user = user
        StorageService.shared.saveUser(user)
    }

    func updateUserInfo(name: String, email: String?, phone: String) async {
        guard var user = user else { return }

        isLoading = true
        errorMessage = nil

        user.name = name
        user.email = email
        user.phone = phone

        do {
            let updatedUser = try await APIClient.shared.updateUser(user)
            self.user = updatedUser
            StorageService.shared.saveUser(updatedUser)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }
}
