//
//  BetViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import Foundation
import Combine

@MainActor  // Ensures all published changes happen on the main thread
class BetViewModel: ObservableObject {
    // MARK: - Published Properties for Form Input
    @Published var betPrompt: String = ""
    @Published var betAmount: String = ""
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var options: [String] = [""]
    
    // MARK: - Published Properties for State Management
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    // MARK: - Published Properties for Bet Lists
    @Published var currentBets: [Bet] = []
    @Published var completedBets: [Bet] = []
    
    // MARK: - Dependencies
    private let betManager = BetManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init() {
        // Subscribe to BetManager's published bet lists
        betManager.$activeBets
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentBets, on: self)
            .store(in: &cancellables)
        
        betManager.$completedBets
            .receive(on: DispatchQueue.main)
            .assign(to: \.completedBets, on: self)
            .store(in: &cancellables)
        
        // Optionally handle errors from BetManager
        betManager.$error
            .compactMap { $0?.localizedDescription }
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Input Validation
    private func validateInput() -> String? {
        // Check for empty prompt
        if betPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Bet prompt cannot be empty."
        }
        
        // Check for valid amount
        guard let amount = Double(betAmount), amount > 0 else {
            return "Please enter a valid bet amount."
        }
        
        // Check for valid end date
        guard let end = endDate else {
            return "End date is required."
        }
        
        // Ensure end date is in the future
        if end < Date() {
            return "End date must be in the future."
        }
        
        // Ensure at least two valid options
        let validOptions = options.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        if validOptions.count < 2 {
            return "Please provide at least two betting options."
        }
        
        return nil
    }
    
    // MARK: - Public Methods
    
    /// Creates a new bet. If `groupId` is provided, the bet is associated with that group.
    func createNewBet(groupId: String? = nil) {
        // Validate input
        if let validationError = validateInput() {
            error = validationError
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                // Extract validated inputs
                let amount = Double(betAmount)!
                let end = endDate!
                
                // Create the bet using BetManager
                let betId = try await betManager.createBet(
                    prompt: betPrompt,
                    amount: amount,
                    endDate: end,
                    groupId: groupId
                )
                
                // Optionally handle post-creation logic (e.g., navigate to bet details)
                
                // Clear form fields
                clearFields()
                
                isLoading = false
            } catch let error as BetError {
                self.error = error.localizedDescription
                isLoading = false
            } catch {
                self.error = "Failed to create bet. Please try again."
                isLoading = false
            }
        }
    }
    
    /// Votes on a specific bet.
    /// - Parameters:
    ///   - betId: The ID of the bet to vote on.
    ///   - vote: `true` for a positive vote, `false` for a negative vote.
    func voteBet(betId: String, vote: Bool) {
        isLoading = true
        error = nil
        
        Task {
            do {
                try await betManager.vote(betId: betId, vote: vote)
                
                // handle post-voting logic (e.g., display a success message)
                
                isLoading = false
            } catch let error as BetError {
                self.error = error.localizedDescription
                isLoading = false
            } catch {
                self.error = "Failed to cast vote. Please try again."
                isLoading = false
            }
        }
    }
    
    // MARK: - Private Helpers
    
    /// Clears all form input fields.
    private func clearFields() {
        betPrompt = ""
        betAmount = ""
        startDate = nil
        endDate = nil
        options = [""]
        error = nil
    }
}
