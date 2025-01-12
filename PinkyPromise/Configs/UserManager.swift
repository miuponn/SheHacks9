//
//  UserManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import FirebaseFirestore
import FirebaseAuth

class UserManager: ObservableObject {
    private let db = Firestore.firestore()
    @Published var currentUser: User?
    @Published var error: Error?
    
    // Get current user's profile
    func getCurrentUserProfile() async throws -> User {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw UserError.notAuthenticated
        }
        
        let document = try await db.collection("users").document(userId).getDocument()
        guard let user = try? document.data(as: User.self) else {
            throw UserError.profileNotFound
        }
        
        DispatchQueue.main.async {
            self.currentUser = user
        }
        return user
    }
    
    // Update user stats (called after bet completion)
    func updateUserStats(userId: String, betWon: Bool) async throws {
        let userRef = db.collection("users").document(userId)
        
        if betWon {
            try await userRef.updateData([
                "betsWon": FieldValue.increment(Int64(1))
            ])
        } else {
            try await userRef.updateData([
                "betsLost": FieldValue.increment(Int64(1))
            ])
        }
    }
    
    // Join a group
    func joinGroup(groupId: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw UserError.notAuthenticated
        }
        
        // Add user to group
        try await db.collection("groups").document(groupId).updateData([
            "members": FieldValue.arrayUnion([userId])
        ])
        
        // Add group to user's groups
        try await db.collection("users").document(userId).updateData([
            "groups": FieldValue.arrayUnion([groupId])
        ])
    }
}
