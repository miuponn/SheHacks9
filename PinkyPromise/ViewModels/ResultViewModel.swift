//
//  ResultViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation
import Combine

class ResultViewModel: ObservableObject {
    private let betManager = BetManager()
    
    @Published var betResult: Bool?
    @Published var betAmount: Double?
    @Published var winAmount: Double?
    @Published var userVote: Bool?
    @Published var voteResult: Bool?
    @Published var error: Error?
    
    func loadBetResult(bet: Bet) {
        guard let userId = AuthManager.shared.userId else { return }
        
        betAmount = bet.amount
        userVote = bet.votes[userId]
        betResult = bet.result
        
        // Calculate win amount if applicable
        if let result = bet.result,
           let userVote = bet.votes[userId],
           userVote == result {
            winAmount = bet.amount * 1.5 // Example multiplier
        }
    }
    
    // Helper computed properties for UI
    var didWin: Bool {
        guard let userVote = userVote,
              let result = betResult else { return false }
        return userVote == result
    }
    
    var displayAmount: String {
        if let amount = winAmount {
            return "$\(Int(amount))"
        } else if let amount = betAmount {
            return "$\(Int(amount))"
        }
        return "$0"
    }
    
    var resultMessage: String {
        if didWin {
            return "You won \(displayAmount) on:"
        } else {
            return "You lost \(displayAmount) on:"
        }
    }
}
