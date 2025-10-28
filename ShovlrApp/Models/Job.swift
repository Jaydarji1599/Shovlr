//
//  Job.swift
//  Shovlr
//
//  Model representing a snow removal job/order
//

import Foundation

enum JobStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case inProgress = "In Progress"
    case completed = "Completed"
    case canceled = "Canceled"

    var description: String {
        switch self {
        case .pending:
            return "Looking for a snow remover..."
        case .confirmed:
            return "Confirmed - Snow remover on the way"
        case .inProgress:
            return "Your snow is being cleared now"
        case .completed:
            return "Snow removal completed"
        case .canceled:
            return "Request canceled"
        }
    }

    var icon: String {
        switch self {
        case .pending:
            return "clock.fill"
        case .confirmed:
            return "checkmark.circle.fill"
        case .inProgress:
            return "snowflake"
        case .completed:
            return "checkmark.seal.fill"
        case .canceled:
            return "xmark.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .pending:
            return "orange"
        case .confirmed:
            return "blue"
        case .inProgress:
            return "purple"
        case .completed:
            return "green"
        case .canceled:
            return "red"
        }
    }
}

enum JobFeedback: Int, Codable {
    case none = 0
    case thumbsDown = -1
    case thumbsUp = 1

    var icon: String {
        switch self {
        case .none:
            return ""
        case .thumbsDown:
            return "hand.thumbsdown.fill"
        case .thumbsUp:
            return "hand.thumbsup.fill"
        }
    }
}

struct Job: Codable, Identifiable {
    let id: UUID
    let userId: String
    var address: Address
    var jobType: JobType
    var snowDepth: SnowDepth
    var price: Double
    var status: JobStatus
    var requestedAt: Date
    var confirmedAt: Date?
    var completedAt: Date?
    var canceledAt: Date?
    var providerId: String?
    var providerName: String?
    var notes: String?
    var feedback: JobFeedback

    init(
        id: UUID = UUID(),
        userId: String,
        address: Address,
        jobType: JobType,
        snowDepth: SnowDepth,
        price: Double,
        status: JobStatus = .pending,
        requestedAt: Date = Date(),
        confirmedAt: Date? = nil,
        completedAt: Date? = nil,
        canceledAt: Date? = nil,
        providerId: String? = nil,
        providerName: String? = nil,
        notes: String? = nil,
        feedback: JobFeedback = .none
    ) {
        self.id = id
        self.userId = userId
        self.address = address
        self.jobType = jobType
        self.snowDepth = snowDepth
        self.price = price
        self.status = status
        self.requestedAt = requestedAt
        self.confirmedAt = confirmedAt
        self.completedAt = completedAt
        self.canceledAt = canceledAt
        self.providerId = providerId
        self.providerName = providerName
        self.notes = notes
        self.feedback = feedback
    }

    var formattedPrice: String {
        String(format: "$%.2f", price)
    }

    var isActive: Bool {
        status == .pending || status == .confirmed || status == .inProgress
    }

    var canCancel: Bool {
        status == .pending
    }

    var needsFeedback: Bool {
        status == .completed && feedback == .none
    }
}
