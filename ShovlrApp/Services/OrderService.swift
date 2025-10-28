//
//  OrderService.swift
//  Shovlr
//
//  Service for managing snow removal orders with simulated status updates
//

import Foundation
import Combine

class OrderService: ObservableObject {
    static let shared = OrderService()

    @Published var currentJob: Job?
    @Published var jobHistory: [Job] = []

    private var statusUpdateTimer: Timer?
    private var currentStatusIndex = 0

    private init() {
        loadHistory()
    }

    // MARK: - Job Management

    func createJob(
        userId: String,
        address: Address,
        jobType: JobType,
        snowDepth: SnowDepth,
        notes: String?
    ) async throws -> Job {

        // Calculate price
        let price = PricingEngine.calculatePrice(jobType: jobType, snowDepth: snowDepth)

        // Create job
        var job = Job(
            userId: userId,
            address: address,
            jobType: jobType,
            snowDepth: snowDepth,
            price: price,
            status: .pending,
            notes: notes
        )

        // Submit to API (stubbed)
        job = try await APIClient.shared.createJob(job)

        // Set as current job
        await MainActor.run {
            self.currentJob = job
        }

        // Save to history
        saveJobToHistory(job)

        // Start simulated status updates for demo
        startStatusUpdateSimulation(for: job.id)

        return job
    }

    func cancelCurrentJob() async throws {
        guard let job = currentJob, job.canCancel else {
            throw APIError.serverError("Cannot cancel this job")
        }

        // Cancel via API
        try await APIClient.shared.cancelJob(jobId: job.id)

        // Update status
        await MainActor.run {
            var updatedJob = job
            updatedJob.status = .canceled
            updatedJob.canceledAt = Date()
            self.currentJob = nil
            self.saveJobToHistory(updatedJob)
        }

        stopStatusUpdateSimulation()
    }

    func submitFeedback(jobId: UUID, feedback: JobFeedback) async throws {
        // Submit via API
        try await APIClient.shared.submitFeedback(jobId: jobId, feedback: feedback)

        // Update local job
        await MainActor.run {
            if let index = jobHistory.firstIndex(where: { $0.id == jobId }) {
                jobHistory[index].feedback = feedback
                saveHistory()
            }
        }
    }

    func clearCurrentJob() {
        currentJob = nil
        stopStatusUpdateSimulation()
    }

    // MARK: - Status Update Simulation (for demo purposes)

    private func startStatusUpdateSimulation(for jobId: UUID) {
        stopStatusUpdateSimulation()
        currentStatusIndex = 0

        // Simulate status progression: Pending -> Confirmed -> InProgress -> Completed
        statusUpdateTimer = Timer.scheduledTimer(withTimeInterval: AppConstants.statusUpdateDelay, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            Task { @MainActor in
                guard var job = self.currentJob, job.id == jobId else {
                    timer.invalidate()
                    return
                }

                self.currentStatusIndex += 1

                switch self.currentStatusIndex {
                case 1:
                    // Move to Confirmed
                    job.status = .confirmed
                    job.confirmedAt = Date()
                    self.currentJob = job
                    self.saveJobToHistory(job)
                    self.sendSimulatedNotification(title: "Snow Remover Confirmed", body: "A snow remover is on the way to your location!")

                case 2:
                    // Move to InProgress
                    job.status = .inProgress
                    self.currentJob = job
                    self.saveJobToHistory(job)
                    self.sendSimulatedNotification(title: "Snow Removal Started", body: "Your snow is being cleared now.")

                case 3:
                    // Move to Completed
                    job.status = .completed
                    job.completedAt = Date()
                    self.currentJob = nil // Clear current job when completed
                    self.saveJobToHistory(job)
                    self.sendSimulatedNotification(title: "Job Completed!", body: "Your snow removal is complete. Please rate your service.")
                    timer.invalidate()

                default:
                    timer.invalidate()
                }
            }
        }

        // Fire immediately for first update
        statusUpdateTimer?.fire()
    }

    private func stopStatusUpdateSimulation() {
        statusUpdateTimer?.invalidate()
        statusUpdateTimer = nil
        currentStatusIndex = 0
    }

    private func sendSimulatedNotification(title: String, body: String) {
        // TODO: Integrate with UNUserNotificationCenter for real local notifications
        print("🔔 [Notification] \(title): \(body)")

        // For now, just print to console
        // In production, this would trigger a local notification or receive push notification
    }

    // MARK: - History Management

    private func loadHistory() {
        jobHistory = StorageService.shared.loadJobHistory()
    }

    private func saveHistory() {
        StorageService.shared.saveJobHistory(jobHistory)
    }

    private func saveJobToHistory(_ job: Job) {
        // Update or add to history
        if let index = jobHistory.firstIndex(where: { $0.id == job.id }) {
            jobHistory[index] = job
        } else {
            jobHistory.insert(job, at: 0)
        }
        saveHistory()
        StorageService.shared.addJobToHistory(job)
    }

    func refreshHistory() async {
        // In production, fetch from backend
        // For now, just reload from storage
        await MainActor.run {
            loadHistory()
        }
    }
}
