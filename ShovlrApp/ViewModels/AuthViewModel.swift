//
//  AuthViewModel.swift
//  Shovlr
//
//  ViewModel for managing authentication state
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    init() {
        checkAuthStatus()
    }

    func checkAuthStatus() {
        if StorageService.shared.isLoggedIn,
           let user = StorageService.shared.loadUser() {
            isAuthenticated = true
            currentUser = user
        }
    }

    func login(phone: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await APIClient.shared.login(phone: phone, password: password)
            StorageService.shared.saveUser(user)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }

    func signup(name: String, phone: String, email: String?, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await APIClient.shared.signup(name: name, phone: phone, email: email, password: password)
            StorageService.shared.saveUser(user)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }

    func logout() {
        StorageService.shared.clearUser()
        currentUser = nil
        isAuthenticated = false
        OrderService.shared.clearCurrentJob()
    }

    func updateUser(_ user: User) async {
        do {
            let updatedUser = try await APIClient.shared.updateUser(user)
            StorageService.shared.saveUser(updatedUser)
            currentUser = updatedUser
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
