//
//  BetViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation
import Combine

class BetViewModel: ObservableObject {
    private let betManager = BetManager()
    
    @Published var currentBets: [Bet] = []
    @Published var completedBets: [Bet] = []
    @Published var error: Error?
    
    func createNewBet(prompt: String, amount: Double, endDate: Date) {
        Task {
            do {
                let _ = try await betManager.createBet(prompt: prompt, amount: amount, endDate: endDate)
                await loadUserBets()
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func voteBet(betId: String, vote: Bool) {
        Task {
            do {
                try await betManager.voteBet(betId: betId, vote: vote)
                await loadUserBets()
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func loadUserBets() async {
        do {
            let bets = try await betManager.getUserBets()
            await MainActor.run {
                filterBetsByStatus(bets)
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    func filterBetsByStatus(_ bets: [Bet]) {
        currentBets = bets.filter { $0.status != .completed }
        completedBets = bets.filter { $0.status == .completed }
    }
}
