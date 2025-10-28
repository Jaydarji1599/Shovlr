//
//  HistoryViewModel.swift
//  Shovlr
//
//  ViewModel for managing job history
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private var cancellables = Set<AnyCancellable>()
    private let orderService = OrderService.shared

    init() {
        setupBindings()
        loadHistory()
    }

    private func setupBindings() {
        // Subscribe to OrderService's job history
        orderService.$jobHistory
            .assign(to: &$jobs)
    }

    func loadHistory() {
        jobs = orderService.jobHistory
    }

    func refreshHistory() async {
        isLoading = true
        await orderService.refreshHistory()
        isLoading = false
    }

    func submitFeedback(for job: Job, feedback: JobFeedback) async {
        do {
            try await orderService.submitFeedback(jobId: job.id, feedback: feedback)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    var completedJobs: [Job] {
        jobs.filter { $0.status == .completed }
    }

    var canceledJobs: [Job] {
        jobs.filter { $0.status == .canceled }
    }

    var totalSpent: Double {
        completedJobs.reduce(0) { $0 + $1.price }
    }

    var formattedTotalSpent: String {
        String(format: "$%.2f", totalSpent)
    }
}
