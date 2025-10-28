//
//  JobTypeSelector.swift
//  Shovlr
//
//  Component for selecting job type
//

import SwiftUI

struct JobTypeSelector: View {
    @Binding var selectedType: JobType

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What needs clearing?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Colors.textPrimary)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(JobType.allCases, id: \.self) { type in
                    JobTypeCard(
                        type: type,
                        isSelected: selectedType == type,
                        action: { selectedType = type }
                    )
                }
            }
        }
    }
}

struct JobTypeCard: View {
    let type: JobType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? Colors.primary : Colors.textSecondary)

                Text(type.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? Colors.primary : Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(isSelected ? Colors.primary.opacity(0.1) : Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Colors.primary : Colors.textSecondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

struct SnowDepthSelector: View {
    @Binding var selectedDepth: SnowDepth

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How much snow?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Colors.textPrimary)

            VStack(spacing: 10) {
                ForEach(SnowDepth.allCases, id: \.self) { depth in
                    SnowDepthRow(
                        depth: depth,
                        isSelected: selectedDepth == depth,
                        action: { selectedDepth = depth }
                    )
                }
            }
        }
    }
}

struct SnowDepthRow: View {
    let depth: SnowDepth
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: depth.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Colors.primary : Colors.textSecondary)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(depth.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Colors.textPrimary)

                    Text(depth.description)
                        .font(.system(size: 13))
                        .foregroundColor(Colors.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Colors.primary)
                        .font(.system(size: 22))
                }
            }
            .padding()
            .background(isSelected ? Colors.primary.opacity(0.1) : Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Colors.primary : Colors.textSecondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        JobTypeSelector(selectedType: .constant(.driveway))
        SnowDepthSelector(selectedDepth: .constant(.moderate))
    }
    .padding()
    .background(Colors.background)
}
