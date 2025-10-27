//
//  PrimaryButton.swift
//  Shovlr
//
//  Reusable primary action button
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var icon: String? = nil

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
            .background(isDisabled ? Colors.textSecondary : Colors.secondary)
            .cornerRadius(16)
        }
        .disabled(isDisabled || isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var icon: String? = nil

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(Colors.primary)
            .background(Colors.background)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Colors.primary, lineWidth: 2)
            )
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Request Snow Removal", action: {})
        PrimaryButton(title: "Loading...", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
        SecondaryButton(title: "Cancel", action: {})
        SecondaryButton(title: "With Icon", action: {}, icon: "xmark")
    }
    .padding()
}
