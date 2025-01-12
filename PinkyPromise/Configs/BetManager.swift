//
//  BetManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import FirebaseFirestore
import FirebaseAuth

class BetManager: ObservableObject {
    private let db = Firestore.firestore()
    @Published var error: Error?
    
    // Create a new bet
    func createBet(prompt: String, amount: Double, endDate: Date, groupId: String? = nil) async throws -> String {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw BetError.notAuthenticated
        }
        
        let betRef = db.collection("bets").document()
        let bet = Bet(
            id: betRef.documentID,
            prompt: prompt,
            amount: amount,
            creator: userId,
            createdAt: Date(),
            startDate: Date(),
            endDate: endDate,
            participants: [userId],
            votes: [:],
            status: .pending,
            groupId: groupId
        )
        
        try await betRef.setData(from: bet)
        
        // If part of a group, update group's active bets
        if let groupId = groupId {
            try await db.collection("groups").document(groupId).updateData([
                "activeBets": FieldValue.arrayUnion([betRef.documentID])
            ])
        }
        
        // Update user's current bets
        try await db.collection("users").document(userId).updateData([
            "currentBets": FieldValue.arrayUnion([betRef.documentID])
        ])
        
        return betRef.documentID
    }
    
    // Vote on a bet
    func voteBet(betId: String, vote: Bool) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw BetError.notAuthenticated
        }
        
        let betRef = db.collection("bets").document(betId)
        
        try await betRef.updateData([
            "votes.\(userId)": vote,
            "participants": FieldValue.arrayUnion([userId]),
            "status": BetStatus.active.rawValue
        ])
    }
    
    // Get user's active bets
    func getUserBets() async throws -> [Bet] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw BetError.notAuthenticated
        }
        
        let snapshot = try await db.collection("bets")
            .whereField("participants", arrayContains: userId)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Bet.self) }
    }
    
    // Complete a bet and update statistics
    func completeBet(betId: String, finalOutcome: Bool) async throws {
        let betRef = db.collection("bets").document(betId)
        let bet = try await betRef.getDocument(as: Bet.self)
        
        // Update bet status
        try await betRef.updateData([
            "status": BetStatus.completed.rawValue
        ])
        
        // Update user statistics
        for (userId, vote) in bet.votes {
            let userRef = db.collection("users").document(userId)
            if vote == finalOutcome {
                try await userRef.updateData([
                    "betsWon": FieldValue.increment(Int64(1)),
                    "currentBets": FieldValue.arrayRemove([betId])
                ])
            } else {
                try await userRef.updateData([
                    "betsLost": FieldValue.increment(Int64(1)),
                    "currentBets": FieldValue.arrayRemove([betId])
                ])
            }
        }
        
        // If part of a group, update group bets
        if let groupId = bet.groupId {
            try await db.collection("groups").document(groupId).updateData([
                "activeBets": FieldValue.arrayRemove([betId]),
                "completedBets": FieldValue.arrayUnion([betId])
            ])
        }
    }
    enum BetError: LocalizedError {
        case notAuthenticated
        case invalidBet
        case betNotFound
        case alreadyVoted
        
        var errorDescription: String? {
            switch self {
            case .notAuthenticated:
                return "User not authenticated"
            case .invalidBet:
                return "Invalid bet data"
            case .betNotFound:
                return "Bet not found"
            case .alreadyVoted:
                return "Already voted on this bet"
            }
        }
    }
}
