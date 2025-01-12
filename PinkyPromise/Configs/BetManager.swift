//
//  BetManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class BetManager: ObservableObject {
    // MARK: - Singleton Instance
    static let shared = BetManager()
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var activeBets: [Bet] = []
    @Published var pendingBets: [Bet] = []
    @Published var completedBets: [Bet] = []
    @Published var error: AppError?
    
    private var listeners: [String: ListenerRegistration] = [:]
    
    // MARK: - Initializer
    private init() {
        setupListeners()
    }
    
    deinit {
        removeAllListeners()
    }
    
    // MARK: - Listeners Setup
    private func setupListeners() {
        guard let userId = auth.currentUser?.uid else { return }
        
        // Active Bets Listener
        let activeBetsListener = db.collection("bets")
            .whereField("participants", arrayContains: userId)
            .whereField("status", isEqualTo: BetStatus.active.rawValue)
            .order(by: "endDate", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.error = AppError.firestoreError(error)
                    return
                }
                self.activeBets = snapshot?.documents.compactMap { try? $0.data(as: Bet.self) } ?? []
            }
        listeners["active"] = activeBetsListener
        
        // Pending Bets Listener
        let pendingBetsListener = db.collection("bets")
            .whereField("participants", arrayContains: userId)
            .whereField("status", isEqualTo: BetStatus.pending.rawValue)
            .order(by: "endDate", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.error = AppError.firestoreError(error)
                    return
                }
                self.pendingBets = snapshot?.documents.compactMap { try? $0.data(as: Bet.self) } ?? []
            }
        listeners["pending"] = pendingBetsListener
        
        // Completed Bets Listener
        let completedBetsListener = db.collection("bets")
            .whereField("participants", arrayContains: userId)
            .whereField("status", isEqualTo: BetStatus.completed.rawValue)
            .order(by: "endDate", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.error = AppError.firestoreError(error)
                    return
                }
                self.completedBets = snapshot?.documents.compactMap { try? $0.data(as: Bet.self) } ?? []
            }
        listeners["completed"] = completedBetsListener
    }
    
    // MARK: - Bet Operations
    
    /// Creates a new bet.
    func createBet(prompt: String, amount: Double, endDate: Date, groupId: String? = nil) async throws -> String {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let betRef = db.collection("bets").document()
        let bet = Bet(
            id: betRef.documentID,
            prompt: prompt,
            amount: amount,
            creatorId: userId,
            createdAt: Date(),
            startDate: Date(),
            endDate: endDate,
            participants: [userId],
            votes: [:],
            status: .pending,
            groupId: groupId,
            result: nil,
            lastUpdated: Date(),
            lastChecked: Date()
        )
        
        try await betRef.setData(from: bet)
        
        // If group-based, add bet to group's activeBets and send invitations
        if let groupId = groupId {
            try await db.collection("groups").document(groupId).updateData([
                "activeBets": FieldValue.arrayUnion([betRef.documentID])
            ])
            
            // Send invitations to group members (excluding creator)
            try await InvitationManager.shared.sendBetInvitesToGroup(betId: betRef.documentID, groupId: groupId)
        }
        
        return betRef.documentID
    }
    
    /// Allows a user to vote on a bet.
    func voteBet(betId: String, vote: Bool) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let betRef = db.collection("bets").document(betId)
        
        try await db.runTransaction { transaction, errorPointer in
            let betDoc = try transaction.getDocument(betRef)
            guard var bet = try? betDoc.data(as: Bet.self) else {
                throw AppError.betNotFound
            }
            
            if bet.votes[userId] != nil {
                throw AppError.alreadyVoted
            }
            
            bet.votes[userId] = vote
            bet.status = .active // Update status upon first vote
            bet.lastUpdated = Date()
            
            try transaction.setData(from: bet, forDocument: betRef)
            return
        }
    }
    
    /// Completes a bet by determining the result based on votes.
    func completeBet(_ bet: Bet, withResult result: Bool) async throws {
        guard let betId = bet.id else { return }
        
        try await db.collection("bets").document(betId).updateData([
            "status": BetStatus.completed.rawValue,
            "result": result,
            "lastUpdated": FieldValue.serverTimestamp()
        ])
        
        // Update user stats
        for (userId, vote) in bet.votes {
            try await FirebaseService.shared.updateStats(userId: userId, groupId: bet.groupId, betResult: (vote == result))
        }
    }
    
    /// Fetches all bets associated with the current user.
    func getUserBets() async throws -> [Bet] {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let snapshot = try await db.collection("bets")
            .whereField("participants", arrayContains: userId)
            .order(by: "endDate", descending: true)
            .limit(to: 20)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Bet.self) }
    }
    
    // MARK: - Helper Methods
    
    /// Removes all active Firestore listeners.
    private func removeAllListeners() {
        listeners.values.forEach { $0.remove() }
        listeners.removeAll()
    }
}
