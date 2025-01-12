//
//  GroupManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import FirebaseFirestore
import FirebaseAuth

class GroupManager {
    private let db = Firestore.firestore()
    @Published var userGroups: [Group] = []
    @Published var error: Error?
    
    func createGroup(name: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw UserError.notAuthenticated
        }
        
        let groupRef = db.collection("groups").document()
        let group = Group(
            id: groupRef.documentID,
            name: name,
            creator: userId,
            members: [userId],
            activeBets: [],
            completedBets: [],
            createdAt: Date()
        )
        
        try await groupRef.setData(from: group)
    }
    
    func joinGroup(groupId: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw UserError.notAuthenticated
        }
        
        try await db.collection("groups").document(groupId).updateData([
            "members": FieldValue.arrayUnion([userId])
        ])
    }
    
    func listenToUserGroups() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("groups")
            .whereField("members", arrayContains: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    self?.error = error
                    return
                }
                
                self?.userGroups = querySnapshot?.documents.compactMap { try? $0.data(as: Group.self) } ?? []
            }
    }
    
    func addBetToGroup(groupId: String, betId: String) async throws {
        try await db.collection("groups").document(groupId).updateData([
            "activeBets": FieldValue.arrayUnion([betId])
        ])
    }
    
    func addMember(groupId: String, userId: String) async throws {
        try await db.collection("groups").document(groupId).updateData([
            "members": FieldValue.arrayUnion([userId])
        ])
    }
    
    func getUserGroups() async throws -> [Group] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw UserError.notAuthenticated
        }
        
        let snapshot = try await db.collection("groups")
            .whereField("members", arrayContains: userId)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Group.self) }
    }
}
