//
//  APIClient.swift
//  Shovlr
//
//  Stubbed API client for backend communication
//  TODO: Replace with real API calls when backend is ready
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case networkError
    case invalidResponse
    case serverError(String)
    case unauthorized
    case notFound
    case paymentFailed

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed. Please check your internet connection."
        case .invalidResponse:
            return "Invalid response from server."
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Please log in again."
        case .notFound:
            return "Resource not found."
        case .paymentFailed:
            return "Payment processing failed. Please check your payment method."
        }
    }
}

class APIClient {
    static let shared = APIClient()

    private init() {}

    // MARK: - Authentication APIs (Stubbed)

    func login(phone: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        // For MVP, accept any login and create a user
        let user = User(
            id: UUID().uuidString,
            name: "Demo User",
            email: nil,
            phone: phone
        )

        return user
    }

    func signup(name: String, phone: String, email: String?, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // For MVP, create a new user
        let user = User(
            id: UUID().uuidString,
            name: name,
            email: email,
            phone: phone
        )

        return user
    }

    func verifyPhone(phone: String, code: String) async throws -> Bool {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // For MVP, accept any code
        return true
    }

    // MARK: - User APIs (Stubbed)

    func updateUser(_ user: User) async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)
        return user
    }

    func updateAddress(_ address: Address, for userId: String) async throws -> Address {
        try await Task.sleep(nanoseconds: 500_000_000)
        return address
    }

    // MARK: - Job APIs (Stubbed)

    func createJob(_ job: Job) async throws -> Job {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Return the job with pending status
        var createdJob = job
        createdJob.status = .pending

        // In a real scenario, this would send to backend/dispatch system
        print("📤 [API] Job created: \(job.id)")
        print("   Address: \(job.address.fullAddress)")
        print("   Type: \(job.jobType.rawValue)")
        print("   Snow Depth: \(job.snowDepth.rawValue)")
        print("   Price: \(job.formattedPrice)")

        return createdJob
    }

    func getJobStatus(jobId: UUID) async throws -> JobStatus {
        try await Task.sleep(nanoseconds: 500_000_000)

        // For demo, return a status (in real app, this would query backend)
        return .pending
    }

    func cancelJob(jobId: UUID) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)

        print("📤 [API] Job canceled: \(jobId)")
    }

    func submitFeedback(jobId: UUID, feedback: JobFeedback) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)

        print("📤 [API] Feedback submitted for job \(jobId): \(feedback)")
    }

    func getJobHistory(userId: String) async throws -> [Job] {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // In real app, fetch from backend
        // For now, return empty array (storage service handles local history)
        return []
    }
}
