//
//  MainView.swift
//  Shovlr
//
//  Main screen - shows request form or active order status
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var orderViewModel = OrderViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.background.ignoresSafeArea()

                if let currentJob = orderViewModel.currentJob {
                    // Show active order status
                    OrderStatusView(job: currentJob)
                } else {
                    // Show request form
                    RequestFormView()
                }
            }
            .navigationTitle("Shovlr")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(orderViewModel)
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}
