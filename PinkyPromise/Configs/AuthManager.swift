//
//  AuthManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
// Managers/AuthManager.swift
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let service = FirebaseService.shared
    private var listeners: [String: ListenerRegistration] = [:]
    
    @Published var currentUser: User?
    @Published var userProfile: UserProfile?
    @Published var error: AuthError?
    @Published var isLoading = false
    
    private init() {
        setupAuthStateListener()
    }
    
    // MARK: - Auth State Management
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] (_, firebaseUser) in
            if let firebaseUser = firebaseUser {
                self?.fetchUserProfile(userId: firebaseUser.uid)
            } else {
                DispatchQueue.main.async {
                    self?.currentUser = nil
                    self?.userProfile = nil
                    self?.removeAllListeners()
                }
            }
        }
    }
    
    // MARK: - Authentication
    func signUp(email: String, password: String, displayName: String? = nil) async throws -> User {
        do {
            isLoading = true
            let result = try await auth.createUser(withEmail: email, password: password)
            
            let user = User(
                id: result.user.uid,
                email: email,
                displayName: displayName,
                createdAt: Date(),
                lastActive: Date()
            )
            
            try await createUserProfile(user)
            
            await MainActor.run {
                self.currentUser = user
                self.isLoading = false
            }
            
            return user
        } catch {
            await MainActor.run {
                self.error = .signUpFailed(error)
                self.isLoading = false
            }
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            isLoading = true
            let result = try await auth.signIn(withEmail: email, password: password)
            try await fetchUserProfile(userId: result.user.uid)
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = .signInFailed(error)
                self.isLoading = false
            }
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try auth.signOut()
            await MainActor.run {
                self.currentUser = nil
                self.userProfile = nil
                removeAllListeners()
            }
        } catch {
            self.error = .signOutFailed(error)
            throw error
        }
    }
    
    // MARK: - Profile Management
    private func createUserProfile(_ user: User) async throws {
        let userRef = db.collection(FirestoreKeys.users).document(user.id ?? "")
        try await userRef.setData(from: user)
        
        await MainActor.run {
            self.currentUser = user
        }
        
        setupUserListeners(userId: user.id ?? "")
    }
    
    private func fetchUserProfile(userId: String) async throws {
        let docRef = db.collection(FirestoreKeys.users).document(userId)
        let snapshot = try await docRef.getDocument()
        
        guard let user = try? snapshot.data(as: User.self) else {
            throw AuthError.profileNotFound
        }
        
        await MainActor.run {
            self.currentUser = user
        }
        
        setupUserListeners(userId: userId)
        
        // Refresh local cache
        try await service.refreshCache(userId: userId)
    }
    
    // MARK: - Listeners
    private func setupUserListeners(userId: String) {
        // Listen for user profile updates
        let userListener = db.collection(FirestoreKeys.users)
            .document(userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let document = snapshot else { return }
                
                if let error = error {
                    self?.error = .profileUpdateFailed(error)
                    return
                }
                
                if let updatedUser = try? document.data(as: User.self) {
                    DispatchQueue.main.async {
                        self?.currentUser = updatedUser
                    }
                }
            }
        
        listeners["userProfile"] = userListener
    }
    
    // MARK: - Updates
    func updateProfile(displayName: String?) async throws {
        guard let userId = currentUser?.id else {
            throw AuthError.notAuthenticated
        }
        
        let userRef = db.collection(FirestoreKeys.users).document(userId)
        try await userRef.updateData([
            "displayName": displayName as Any,
            "lastUpdated": FieldValue.serverTimestamp()
        ])
    }
    
    func updateLastActive() async throws {
        guard let userId = currentUser?.id else { return }
        
        try await db.collection(FirestoreKeys.users).document(userId).updateData([
            "lastActive": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            self.error = .passwordResetFailed(error)
            throw error
        }
    }
    
    // MARK: - Clean up
    private func removeAllListeners() {
        listeners.values.forEach { $0.remove() }
        listeners.removeAll()
    }
}

// MARK: - Helper Extensions
extension AuthManager {
    var isAuthenticated: Bool {
        currentUser != nil && Auth.auth().currentUser != nil
    }
    
    var userId: String? {
        currentUser?.id
    }
}
