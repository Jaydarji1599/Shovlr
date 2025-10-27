//
//  ShovlrApp.swift
//  Shovlr
//
//  Main app entry point
//

import SwiftUI

@main
struct ShovlrApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    var body: some Scene {
        WindowGroup {
            ZStack {
                if authViewModel.isAuthenticated {
                    // Main app interface
                    ContentView()
                        .environmentObject(authViewModel)
                } else {
                    // Authentication flow
                    if showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .onDisappear {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            }
                    } else {
                        WelcomeView()
                            .environmentObject(authViewModel)
                    }
                }
            }
            .preferredColorScheme(.light) // Force light mode for winter theme
        }
    }
}
