//
//  HistoryView.swift
//  Shovlr
//
//  View showing job history
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.background.ignoresSafeArea()

                if viewModel.jobs.isEmpty {
                    // Empty state
                    EmptyHistoryView()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Summary card
                            if !viewModel.completedJobs.isEmpty {
                                HistorySummaryCard(
                                    totalJobs: viewModel.completedJobs.count,
                                    totalSpent: viewModel.totalSpent
                                )
                                .padding(.horizontal)
                                .padding(.top, 16)
                            }

                            // Job list
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.jobs) { job in
                                    NavigationLink(destination: JobDetailView(job: job)) {
                                        JobHistoryCard(job: job)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                    }
                    .refreshable {
                        await viewModel.refreshHistory()
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(Colors.textSecondary.opacity(0.5))

            Text("No jobs yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Colors.textPrimary)

            Text("Your snow removal history will appear here")
                .font(.system(size: 16))
                .foregroundColor(Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct HistorySummaryCard: View {
    let totalJobs: Int
    let totalSpent: Double

    var body: some View {
        HStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Jobs")
                    .font(.system(size: 14))
                    .foregroundColor(Colors.textSecondary)
                Text("\(totalJobs)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Colors.primary)
            }

            Divider()
                .frame(height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text("Total Spent")
                    .font(.system(size: 14))
                    .foregroundColor(Colors.textSecondary)
                Text(String(format: "$%.2f", totalSpent))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Colors.secondary)
            }

            Spacer()
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
    }
}

struct JobHistoryCard: View {
    let job: Job

    var body: some View {
        HStack(spacing: 16) {
            // Status indicator
            VStack {
                Image(systemName: job.status.icon)
                    .font(.system(size: 24))
                    .foregroundColor(statusColor)
            }
            .frame(width: 50, height: 50)
            .background(statusColor.opacity(0.15))
            .cornerRadius(12)

            // Job info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(job.jobType.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Colors.textPrimary)

                    Spacer()

                    Text(job.formattedPrice)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Colors.textPrimary)
                }

                Text(job.address.shortAddress)
                    .font(.system(size: 14))
                    .foregroundColor(Colors.textSecondary)
                    .lineLimit(1)

                HStack {
                    Text(formatDate(job.requestedAt))
                        .font(.system(size: 12))
                        .foregroundColor(Colors.textSecondary)

                    Spacer()

                    StatusBadge(status: job.status, showIcon: false)
                }
            }

            // Feedback indicator or chevron
            if job.status == .completed {
                if job.feedback != .none {
                    Image(systemName: job.feedback.icon)
                        .foregroundColor(job.feedback == .thumbsUp ? Colors.success : Colors.error)
                        .font(.system(size: 20))
                } else {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(Colors.warning)
                        .font(.system(size: 16))
                }
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(Colors.textSecondary)
                    .font(.system(size: 14))
            }
        }
        .padding()
        .background(Colors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
}
