//
//  GroupManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class GroupManager: ObservableObject {
    // MARK: - Singleton Instance
    static let shared = GroupManager()
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var userGroups: [Group] = []
    @Published var error: AppError?
    
    private var listener: ListenerRegistration?
    
    // MARK: - Initializer
    private init() {
        fetchUserGroups()
    }
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - Group Operations
    
    /// Creates a new group with the given name.
    func createGroup(name: String) async throws -> String {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let groupRef = db.collection("groups").document()
        let group = Group(
            id: groupRef.documentID,
            name: name,
            creatorId: userId,
            members: [userId],
            createdAt: Date(),
            activeBets: []
        )
        
        try await groupRef.setData(from: group)
        
        // Update user's group list
        try await db.collection("users").document(userId).updateData([
            "groups": FieldValue.arrayUnion([groupRef.documentID])
        ])
        
        return groupRef.documentID
    }
    
    /// Fetches all groups the current user is a part of.
    func getUserGroups() async throws -> [Group] {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let snapshot = try await db.collection("groups")
            .whereField("members", arrayContains: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Group.self) }
    }
    
    /// Allows a user to join an existing group.
    func joinGroup(groupId: String) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let groupRef = db.collection("groups").document(groupId)
        let userRef = db.collection("users").document(userId)
        
        // Add user to group's members
        try await groupRef.updateData([
            "members": FieldValue.arrayUnion([userId])
        ])
        
        // Add group to user's groups
        try await userRef.updateData([
            "groups": FieldValue.arrayUnion([groupId])
        ])
    }
    
    /// Fetches statistics for a specific group.
    func getGroupStats(groupId: String) async throws -> (wins: Int, losses: Int) {
        let betsSnapshot = try await db.collection("bets")
            .whereField("groupId", isEqualTo: groupId)
            .whereField("status", isEqualTo: BetStatus.completed.rawValue)
            .getDocuments()
        
        var wins = 0
        var losses = 0
        
        for document in betsSnapshot.documents {
            if let bet = try? document.data(as: Bet.self),
               let result = bet.result,
               let userId = auth.currentUser?.uid,
               let userVote = bet.votes[userId] {
                if userVote == result {
                    wins += 1
                } else {
                    losses += 1
                }
            }
        }
        
        return (wins, losses)
    }
    
    // MARK: - Listener Setup
    
    /// Sets up a Firestore listener for the current user's groups.
    private func fetchUserGroups() {
        guard let userId = auth.currentUser?.uid else {
            self.userGroups = []
            return
        }
        
        listener = db.collection("groups")
            .whereField("members", arrayContains: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.error = AppError.firestoreError(error)
                    return
                }
                self.userGroups = snapshot?.documents.compactMap { try? $0.data(as: Group.self) } ?? []
            }
    }
}
