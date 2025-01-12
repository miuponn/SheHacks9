//
//  DashboardViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    private let betManager = BetManager()
    private let groupManager = GroupManager()
    private var cancellables = Set<AnyCancellable>()
    
    // Published properties for UI sections
    @Published var currentBets: [Bet] = []
    @Published var betsWon: [Bet] = []
    @Published var userGroups: [Group] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // Subscribe to active bets
        betManager.$activeBets
            .assign(to: &$currentBets)
        
        // Subscribe to completed bets
        betManager.$completedBets
            .map { $0.filter { $0.result == true } }
            .assign(to: &$betsWon)
        
        // Subscribe to groups
        groupManager.$userGroups
            .assign(to: &$userGroups)
    }
    
    // MARK: - Dashboard Data
    // These methods return local data for immediate display
    var recentBets: [Bet] {
        Array(currentBets.prefix(3))
    }
    
    var recentWins: [Bet] {
        Array(betsWon.prefix(2))
    }
    
    var activeGroups: [Group] {
        Array(userGroups.prefix(2))
    }
    
    // MARK: - Quick Actions
    func resolveQuickBet(_ bet: Bet) {
        Task {
            do {
                try await betManager.completeBet(betId: bet.id ?? "", result: true)
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
