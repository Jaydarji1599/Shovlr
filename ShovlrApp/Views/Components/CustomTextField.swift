//
//  CustomTextField.swift
//  Shovlr
//
//  Reusable styled text field
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Colors.textSecondary)

            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(Colors.textSecondary)
                        .frame(width: 20)
                }

                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .font(.system(size: 16))
            }
            .padding()
            .background(Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.textSecondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct CustomSecureField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Colors.textSecondary)

            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(Colors.textSecondary)
                        .frame(width: 20)
                }

                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 16))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .textInputAutocapitalization(.never)
                }

                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Colors.textSecondary)
                }
            }
            .padding()
            .background(Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.textSecondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(
            title: "Phone Number",
            placeholder: "Enter your phone",
            text: .constant(""),
            icon: "phone.fill",
            keyboardType: .phonePad
        )

        CustomSecureField(
            title: "Password",
            placeholder: "Enter password",
            text: .constant(""),
            icon: "lock.fill"
        )
    }
    .padding()
    .background(Colors.background)
}
