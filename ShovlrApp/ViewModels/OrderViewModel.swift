//
//  OrderViewModel.swift
//  Shovlr
//
//  ViewModel for managing order creation and tracking
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OrderViewModel: ObservableObject {
    @Published var selectedJobType: JobType = .driveway
    @Published var selectedSnowDepth: SnowDepth = .moderate
    @Published var notes: String = ""
    @Published var selectedAddress: Address?

    @Published var calculatedPrice: Double = 0.0
    @Published var currentJob: Job?

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showPaymentSheet = false
    @Published var showConfirmation = false

    private var cancellables = Set<AnyCancellable>()
    private let orderService = OrderService.shared

    init() {
        calculatePrice()
        setupBindings()
    }

    private func setupBindings() {
        // Subscribe to OrderService's current job
        orderService.$currentJob
            .assign(to: &$currentJob)

        // Recalculate price when job type or snow depth changes
        Publishers.CombineLatest($selectedJobType, $selectedSnowDepth)
            .sink { [weak self] _, _ in
                self?.calculatePrice()
            }
            .store(in: &cancellables)
    }

    func calculatePrice() {
        calculatedPrice = PricingEngine.calculatePrice(jobType: selectedJobType, snowDepth: selectedSnowDepth)
    }

    func createOrder(userId: String, address: Address, paymentMethod: PaymentMethod?) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            // Process payment first
            if let paymentMethod = paymentMethod {
                _ = try await PaymentService.shared.processPayment(
                    amount: calculatedPrice,
                    cardNumber: "4242424242424242", // Stub - in real app this would be tokenized
                    expiryMonth: paymentMethod.expiryMonth ?? 12,
                    expiryYear: paymentMethod.expiryYear ?? 2025,
                    cvv: "123"
                )
            }

            // Create the job
            let job = try await orderService.createJob(
                userId: userId,
                address: address,
                jobType: selectedJobType,
                snowDepth: selectedSnowDepth,
                notes: notes.isEmpty ? nil : notes
            )

            currentJob = job
            showConfirmation = true

            // Reset form
            notes = ""

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }

    func cancelCurrentOrder() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await orderService.cancelCurrentJob()
            currentJob = nil
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }

    func clearCurrentOrder() {
        currentJob = nil
        orderService.clearCurrentJob()
    }

    var canRequestService: Bool {
        selectedAddress != nil
    }

    var formattedPrice: String {
        String(format: "$%.2f", calculatedPrice)
    }
}
