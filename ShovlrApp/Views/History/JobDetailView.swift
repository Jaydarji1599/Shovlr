//
//  JobDetailView.swift
//  Shovlr
//
//  Detailed view of a past job with feedback option
//

import SwiftUI

struct JobDetailView: View {
    let job: Job
    @StateObject private var viewModel = HistoryViewModel()

    @State private var showFeedbackSheet = false
    @State private var selectedFeedback: JobFeedback = .none

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Status header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.15))
                            .frame(width: 100, height: 100)

                        Image(systemName: job.status.icon)
                            .font(.system(size: 40))
                            .foregroundColor(statusColor)
                    }

                    StatusBadge(status: job.status)

                    Text(formatFullDate(job.requestedAt))
                        .font(.system(size: 14))
                        .foregroundColor(Colors.textSecondary)
                }
                .padding(.top, 20)

                // Job details
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Service Details")

                    DetailCard {
                        VStack(spacing: 16) {
                            DetailRow(label: "Service Type", value: job.jobType.rawValue)
                            Divider()
                            DetailRow(label: "Snow Depth", value: job.snowDepth.rawValue)
                            Divider()
                            DetailRow(label: "Price", value: job.formattedPrice)
                        }
                    }

                    SectionHeader(title: "Location")

                    DetailCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(Colors.primary)
                                Text(job.address.fullAddress)
                                    .font(.system(size: 16))
                                    .foregroundColor(Colors.textPrimary)
                            }
                        }
                    }

                    if let notes = job.notes, !notes.isEmpty {
                        SectionHeader(title: "Special Instructions")

                        DetailCard {
                            Text(notes)
                                .font(.system(size: 16))
                                .foregroundColor(Colors.textPrimary)
                        }
                    }

                    // Timestamps
                    SectionHeader(title: "Timeline")

                    DetailCard {
                        VStack(spacing: 12) {
                            TimelineRow(
                                label: "Requested",
                                time: formatTime(job.requestedAt)
                            )

                            if let confirmedAt = job.confirmedAt {
                                Divider()
                                TimelineRow(
                                    label: "Confirmed",
                                    time: formatTime(confirmedAt)
                                )
                            }

                            if let completedAt = job.completedAt {
                                Divider()
                                TimelineRow(
                                    label: "Completed",
                                    time: formatTime(completedAt)
                                )
                            }

                            if let canceledAt = job.canceledAt {
                                Divider()
                                TimelineRow(
                                    label: "Canceled",
                                    time: formatTime(canceledAt)
                                )
                            }
                        }
                    }

                    // Feedback section
                    if job.status == .completed {
                        SectionHeader(title: "Service Feedback")

                        if job.feedback == .none {
                            DetailCard {
                                VStack(spacing: 16) {
                                    Text("How was your service?")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Colors.textPrimary)

                                    HStack(spacing: 40) {
                                        FeedbackButton(
                                            icon: "hand.thumbsup.fill",
                                            label: "Good",
                                            color: Colors.success,
                                            action: {
                                                selectedFeedback = .thumbsUp
                                                showFeedbackSheet = true
                                            }
                                        )

                                        FeedbackButton(
                                            icon: "hand.thumbsdown.fill",
                                            label: "Bad",
                                            color: Colors.error,
                                            action: {
                                                selectedFeedback = .thumbsDown
                                                showFeedbackSheet = true
                                            }
                                        )
                                    }
                                }
                            }
                        } else {
                            DetailCard {
                                HStack {
                                    Image(systemName: job.feedback.icon)
                                        .font(.system(size: 30))
                                        .foregroundColor(job.feedback == .thumbsUp ? Colors.success : Colors.error)

                                    Text("You rated this service \(job.feedback == .thumbsUp ? "good" : "bad")")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Colors.textPrimary)

                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .background(Colors.background.ignoresSafeArea())
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showFeedbackSheet) {
            Button("Submit") {
                Task {
                    await viewModel.submitFeedback(for: job, feedback: selectedFeedback)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Thanks for your feedback. It helps us improve our service!")
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

    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DetailCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Colors.cardBackground)
            .cornerRadius(12)
    }
}

struct TimelineRow: View {
    let label: String
    let time: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Colors.textSecondary)
            Spacer()
            Text(time)
                .font(.system(size: 14))
                .foregroundColor(Colors.textPrimary)
        }
    }
}

struct FeedbackButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(color)

                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Colors.textPrimary)
            }
            .frame(width: 100, height: 100)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        JobDetailView(job: Job(
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
            status: .completed,
            completedAt: Date()
        ))
    }
}
