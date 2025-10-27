//
//  StorageService.swift
//  Shovlr
//
//  Service for local data persistence using UserDefaults
//

import Foundation

class StorageService {
    static let shared = StorageService()

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Keys {
        static let currentUser = "currentUser"
        static let isLoggedIn = "isLoggedIn"
        static let jobHistory = "jobHistory"
        static let authToken = "authToken"
    }

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - User Storage

    func saveUser(_ user: User) {
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: Keys.currentUser)
            defaults.set(true, forKey: Keys.isLoggedIn)
        }
    }

    func loadUser() -> User? {
        guard let data = defaults.data(forKey: Keys.currentUser) else { return nil }
        return try? decoder.decode(User.self, from: data)
    }

    func clearUser() {
        defaults.removeObject(forKey: Keys.currentUser)
        defaults.set(false, forKey: Keys.isLoggedIn)
        defaults.removeObject(forKey: Keys.authToken)
    }

    var isLoggedIn: Bool {
        defaults.bool(forKey: Keys.isLoggedIn)
    }

    // MARK: - Job History Storage

    func saveJobHistory(_ jobs: [Job]) {
        if let encoded = try? encoder.encode(jobs) {
            defaults.set(encoded, forKey: Keys.jobHistory)
        }
    }

    func loadJobHistory() -> [Job] {
        guard let data = defaults.data(forKey: Keys.jobHistory) else { return [] }
        return (try? decoder.decode([Job].self, from: data)) ?? []
    }

    func addJobToHistory(_ job: Job) {
        var history = loadJobHistory()
        // Remove existing job with same ID if present (update)
        history.removeAll { $0.id == job.id }
        // Add new/updated job
        history.insert(job, at: 0)
        // Keep only last 50 jobs
        if history.count > 50 {
            history = Array(history.prefix(50))
        }
        saveJobHistory(history)
    }

    func clearJobHistory() {
        defaults.removeObject(forKey: Keys.jobHistory)
    }

    // MARK: - Auth Token Storage (for future backend integration)

    func saveAuthToken(_ token: String) {
        defaults.set(token, forKey: Keys.authToken)
    }

    func loadAuthToken() -> String? {
        defaults.string(forKey: Keys.authToken)
    }

    // MARK: - Clear All Data

    func clearAllData() {
        clearUser()
        clearJobHistory()
    }
}
