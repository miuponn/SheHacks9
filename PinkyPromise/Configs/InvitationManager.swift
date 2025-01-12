//
//  InvitationManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

enum InvitationType: String {
    case bet
    case group
}

class InvitationManager: ObservableObject {
    // MARK: - Singleton Instance
    static let shared = InvitationManager()
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var pendingBetInvites: [BetInvitation] = []
    @Published var pendingGroupInvites: [GroupInvitation] = []
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
        
        // Pending Bet Invitations Listener
        let betInvitesListener = db.collection("betInvitations")
            .whereField("toUserId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.error = AppError.firestoreError(error)
                    return
                }
                self.pendingBetInvites = snapshot?.documents.compactMap { try? $0.data(as: BetInvitation.self) } ?? []
            }
        listeners["betInvites"] = betInvitesListener
        
        // Pending Group Invitations Listener
        let groupInvitesListener = db.collection("groupInvitations")
            .whereField("toUserId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    self.error = AppError.firestoreError(error)
                    return
                }
                self.pendingGroupInvites = snapshot?.documents.compactMap { try? $0.data(as: GroupInvitation.self) } ?? []
            }
        listeners["groupInvites"] = groupInvitesListener
    }
    
    // MARK: - Invitation Operations
    
    /// Sends bet invitations to all members of a group except the creator.
    func sendBetInvitesToGroup(betId: String, groupId: String) async throws {
        let groupDoc = try await db.collection("groups").document(groupId).getDocument()
        guard let group = try? groupDoc.data(as: Group.self) else {
            throw AppError.groupNotFound
        }
        
        let creatorId = group.creatorId
        let invitePromises = group.members.filter { $0 != creatorId }.map { memberId -> Task<Void, Error> in
            Task {
                let inviteRef = db.collection("betInvitations").document()
                let invitation = BetInvitation(
                    id: inviteRef.documentID,
                    betId: betId,
                    fromUserId: creatorId,
                    toUserId: memberId,
                    createdAt: Date()
                )
                try await inviteRef.setData(from: invitation)
            }
        }
        
        // Await all invite tasks
        for inviteTask in invitePromises {
            try await inviteTask.value
        }
    }
    
    /// Responds to a bet invitation.
    func respondToBetInvite(inviteId: String, accept: Bool) async throws {
        let inviteRef = db.collection("betInvitations").document(inviteId)
        let inviteDoc = try await inviteRef.getDocument()
        guard let invite = try? inviteDoc.data(as: BetInvitation.self) else {
            throw AppError.invitationNotFound
        }
        
        if accept {
            // Add user to the bet's participants if accepting
            let betRef = db.collection("bets").document(invite.betId)
            try await betRef.updateData([
                "participants": FieldValue.arrayUnion([auth.currentUser!.uid])
            ])
        }
        
        // Remove the invitation regardless of acceptance
        try await inviteRef.delete()
    }
    
    /// Sends group invitations to specific users.
    func sendGroupInvite(toUserIds: [String], groupId: String) async throws {
        let fromUserId = auth.currentUser?.uid ?? ""
        let invitePromises = toUserIds.map { userId -> Task<Void, Error> in
            Task {
                let inviteRef = db.collection("groupInvitations").document()
                let invitation = GroupInvitation(
                    id: inviteRef.documentID,
                    groupId: groupId,
                    fromUserId: fromUserId,
                    toUserId: userId,
                    createdAt: Date()
                )
                try await inviteRef.setData(from: invitation)
            }
        }
        
        // Await all invite tasks
        for inviteTask in invitePromises {
            try await inviteTask.value
        }
    }
    
    // MARK: - Helper Methods
    
    /// Removes all active Firestore listeners.
    private func removeAllListeners() {
        listeners.values.forEach { $0.remove() }
        listeners.removeAll()
    }
}
