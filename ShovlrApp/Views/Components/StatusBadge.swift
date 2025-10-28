//
//  StatusBadge.swift
//  Shovlr
//
//  Reusable status badge for job status display
//

import SwiftUI

struct StatusBadge: View {
    let status: JobStatus
    var showIcon: Bool = true

    var body: some View {
        HStack(spacing: 6) {
            if showIcon {
                Image(systemName: status.icon)
                    .font(.system(size: 14, weight: .semibold))
            }

            Text(status.rawValue)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
    }

    private var backgroundColor: Color {
        switch status {
        case .pending:
            return Colors.warning.opacity(0.15)
        case .confirmed:
            return Colors.primary.opacity(0.15)
        case .inProgress:
            return Color.purple.opacity(0.15)
        case .completed:
            return Colors.success.opacity(0.15)
        case .canceled:
            return Colors.error.opacity(0.15)
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .pending:
            return Colors.warning
        case .confirmed:
            return Colors.primary
        case .inProgress:
            return Color.purple
        case .completed:
            return Colors.success
        case .canceled:
            return Colors.error
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        StatusBadge(status: .pending)
        StatusBadge(status: .confirmed)
        StatusBadge(status: .inProgress)
        StatusBadge(status: .completed)
        StatusBadge(status: .canceled)
    }
    .padding()
}
