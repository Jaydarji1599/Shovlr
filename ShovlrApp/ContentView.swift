//
//  ContentView.swift
//  Shovlr
//
//  Main tab-based navigation
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home tab - Request snow removal
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            // History tab - Past orders
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(1)

            // Profile tab - User settings
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .accentColor(Colors.primary)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
