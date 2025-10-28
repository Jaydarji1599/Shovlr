//
//  PriceDisplay.swift
//  Shovlr
//
//  Component for displaying the calculated price
//

import SwiftUI

struct PriceDisplay: View {
    let price: Double
    var title: String = "Total Price"

    var formattedPrice: String {
        String(format: "$%.2f", price)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.textSecondary)

                    Text("Upfront pricing, no surprises")
                        .font(.system(size: 12))
                        .foregroundColor(Colors.textSecondary.opacity(0.8))
                }

                Spacer()

                Text(formattedPrice)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Colors.primary)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Colors.primary.opacity(0.1), Colors.accent.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Colors.primary.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        PriceDisplay(price: 45.0)
        PriceDisplay(price: 75.0, title: "Estimated Cost")
    }
    .padding()
    .background(Colors.background)
}
