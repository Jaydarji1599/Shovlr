//
//  LoadingView.swift
//  Shovlr
//
//  Reusable loading indicator
//

import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Colors.primary))
                .scaleEffect(1.5)

            Text(message)
                .font(.system(size: 16))
                .foregroundColor(Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.background.opacity(0.9))
    }
}

#Preview {
    LoadingView(message: "Processing your request...")
}
