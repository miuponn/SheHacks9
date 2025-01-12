//
//  UserManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class UserManager: ObservableObject {
    // MARK: - Singleton Instance
    static let shared = UserManager()
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var currentUser: User?
    @Published var error: AppError?
    
    private var listener: ListenerRegistration?
    
    // MARK: - Initializer
    private init() {
        fetchCurrentUser()
    }
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - User Operations
    
    /// Fetches the current authenticated user's profile.
    func getCurrentUserProfile() async throws -> User {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let document = try await db.collection("users").document(userId).getDocument()
        guard let user = try? document.data(as: User.self) else {
            throw AppError.userNotFound
        }
        return user
    }
    
    /// Updates the current user's profile.
    func updateUserProfile(_ updatedProfile: UserProfile) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw AppError.notAuthenticated
        }
        
        let userRef = db.collection("users").document(userId)
        try await userRef.updateData([
            "username": updatedProfile.username,
            "email": updatedProfile.email,
            "profilePhotoURL": updatedProfile.profilePhotoURL ?? "",
            "betsWon": updatedProfile.betsWon,
            "betsLost": updatedProfile.betsLost
        ])
    }
    
    // MARK: - Listener Setup
    
    /// Sets up a Firestore listener for the current user's document.
    private func fetchCurrentUser() {
        guard let userId = auth.currentUser?.uid else {
            self.currentUser = nil
            return
        }
        
        listener = db.collection("users").document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error = AppError.firestoreError(error)
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                self.error = AppError.userNotFound
                return
            }
            
            self.currentUser = try? document.data(as: User.self)
        }
    }
}
