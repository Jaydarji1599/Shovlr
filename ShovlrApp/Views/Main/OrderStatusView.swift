//
//  OrderStatusView.swift
//  Shovlr
//
//  View showing the status of an active snow removal order
//

import SwiftUI

struct OrderStatusView: View {
    let job: Job
    @EnvironmentObject var orderViewModel: OrderViewModel

    @State private var showCancelConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Status header
                VStack(spacing: 16) {
                    // Status icon
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.15))
                            .frame(width: 120, height: 120)

                        Image(systemName: job.status.icon)
                            .font(.system(size: 50))
                            .foregroundColor(statusColor)
                    }
                    .padding(.top, 40)

                    // Status badge
                    StatusBadge(status: job.status, showIcon: false)

                    // Status description
                    Text(job.status.description)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Colors.textPrimary)
                        .multilineTextAlignment(.center)

                    // Timestamp
                    Text(timestampText)
                        .font(.system(size: 14))
                        .foregroundColor(Colors.textSecondary)
                }

                // Progress timeline
                StatusTimeline(job: job)
                    .padding(.horizontal)

                // Job details card
                JobDetailsCard(job: job)
                    .padding(.horizontal)

                Spacer()

                // Action buttons
                VStack(spacing: 12) {
                    if job.canCancel {
                        SecondaryButton(
                            title: "Cancel Request",
                            action: { showCancelConfirmation = true },
                            icon: "xmark.circle"
                        )
                        .padding(.horizontal)
                    }

                    if job.status == .completed {
                        PrimaryButton(
                            title: "Done",
                            action: {
                                orderViewModel.clearCurrentOrder()
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .confirmationDialog("Cancel Request", isPresented: $showCancelConfirmation) {
            Button("Cancel Request", role: .destructive) {
                Task {
                    await orderViewModel.cancelCurrentOrder()
                }
            }
            Button("Keep Request", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this snow removal request?")
        }
    }

    private var statusColor: Color {
        switch job.status {
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

    private var timestampText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        switch job.status {
        case .pending:
            return "Requested at \(formatter.string(from: job.requestedAt))"
        case .confirmed:
            if let confirmedAt = job.confirmedAt {
                return "Confirmed at \(formatter.string(from: confirmedAt))"
            }
            return ""
        case .inProgress:
            return "Started"
        case .completed:
            if let completedAt = job.completedAt {
                return "Completed at \(formatter.string(from: completedAt))"
            }
            return "Completed"
        case .canceled:
            if let canceledAt = job.canceledAt {
                return "Canceled at \(formatter.string(from: canceledAt))"
            }
            return "Canceled"
        }
    }
}

struct StatusTimeline: View {
    let job: Job

    var body: some View {
        VStack(spacing: 0) {
            TimelineItem(
                title: "Request Placed",
                time: formatTime(job.requestedAt),
                isCompleted: true,
                isLast: false
            )

            TimelineItem(
                title: "Confirmed",
                time: job.confirmedAt != nil ? formatTime(job.confirmedAt!) : nil,
                isCompleted: job.status != .pending && job.status != .canceled,
                isLast: false
            )

            TimelineItem(
                title: "In Progress",
                time: nil,
                isCompleted: job.status == .inProgress || job.status == .completed,
                isLast: false
            )

            TimelineItem(
                title: "Completed",
                time: job.completedAt != nil ? formatTime(job.completedAt!) : nil,
                isCompleted: job.status == .completed,
                isLast: true
            )
        }
        .padding()
        .background(Colors.cardBackground)
        .cornerRadius(12)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct TimelineItem: View {
    let title: String
    let time: String?
    let isCompleted: Bool
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(isCompleted ? Colors.success : Colors.textSecondary.opacity(0.3))
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(isCompleted ? Colors.success.opacity(0.3) : Colors.textSecondary.opacity(0.2))
                        .frame(width: 2, height: 40)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isCompleted ? Colors.textPrimary : Colors.textSecondary)

                if let time = time {
                    Text(time)
                        .font(.system(size: 14))
                        .foregroundColor(Colors.textSecondary)
                }
            }

            Spacer()

            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Colors.success)
            }
        }
    }
}

struct JobDetailsCard: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Service Details")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Colors.textPrimary)

            Divider()

            DetailRow(label: "Address", value: job.address.shortAddress)
            DetailRow(label: "Service Type", value: job.jobType.rawValue)
            DetailRow(label: "Snow Depth", value: job.snowDepth.rawValue)
            DetailRow(label: "Price", value: job.formattedPrice)

            if let notes = job.notes, !notes.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Special Instructions")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Colors.textSecondary)
                    Text(notes)
                        .font(.system(size: 14))
                        .foregroundColor(Colors.textPrimary)
                }
            }
        }
        .padding()
        .background(Colors.cardBackground)
        .cornerRadius(12)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Colors.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Colors.textPrimary)
        }
    }
}

#Preview {
    let sampleJob = Job(
        userId: "123",
        address: Address(
            streetLine1: "123 Main St",
            city: "Halifax",
            province: "NS",
            postalCode: "B3H 1A1"
        ),
        jobType: .both,
        snowDepth: .heavy,
        price: 75.0,
        status: .confirmed,
        confirmedAt: Date()
    )

    OrderStatusView(job: sampleJob)
        .environmentObject(OrderViewModel())
}
