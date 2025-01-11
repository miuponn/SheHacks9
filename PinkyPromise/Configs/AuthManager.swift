//
//  AuthManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import FirebaseAuth
import FirebaseFirestore

class AuthManager: NSObject { // delegate
    static let shared = AuthManager()
    private let auth = Auth.auth() // inst for handling signin/signout
    private let db = Firestore.firestore() // database inst
    
    @Published var currentUser: User? // properties for current user and error handling
    @Published var error: Error?
    
    override private init() {
        super.init()
        setupAuthStateListener()
    }
    
    // MARK: - Auth State Listener: listener for auth state changes
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] (_, user) in
            self?.currentUser = user
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error)) // pass error back
                return
            }
            
            if let user = result?.user {
                self?.createUserProfile(for: user) // create user profile
                completion(.success(user))
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error)) // pass error back
                return
            }
            
            if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // MARK: - User Profile Management
    private func createUserProfile(for user: User) {
        let userRef = db.collection("users").document(user.uid)
        
        let userData: [String: Any] = [ // default user data
            "uid": user.uid,
            "email": user.email ?? "",
            "createdAt": FieldValue.serverTimestamp(),
            "betsWon": 0,
            "betsLost": 0,
            "currentBets": [],
            "groups": []
        ]
        
        userRef.setData(userData) { [weak self] error in
            if let error = error {
                self?.error = error // store error
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try auth.signOut() // sign out of firebase
    }
}

// MARK: - Error Extension
extension AuthManager {
    enum AuthError: LocalizedError { // custom error
        case signInFailed
        case noUser
        case profileUpdateFailed
        
        var errorDescription: String? {
            switch self {
            case .signInFailed: // signin fail error case
                return "Failed to sign in. Please try again."
            case .noUser: // no logged in user error case
                return "No user found. Please sign in."
            case .profileUpdateFailed: // issue updating user profile
                return "Failed to update profile. Please try again."
            }
        }
    }
}
