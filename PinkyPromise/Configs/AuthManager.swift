//
//  AuthManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import FirebaseAuth
import FirebaseFirestore

// singleton class to manage authentication and user profiles
class AuthManager: ObservableObject {
    static let shared = AuthManager() // shared instance for global access
    private let auth = Auth.auth() // firebase auth instance
    private let db = Firestore.firestore() // firestore database instance
    
    @Published var currentUser: User? // currently signed-in user
    @Published var error: AuthError? // auth-related error
    
    private init() {
        setupAuthStateListener() // initialize auth state listener
    }
    
    // MARK: - Auth State Listener
    private func setupAuthStateListener() {
        // listen for changes to the auth state (e.g., sign-in, sign-out)
        auth.addStateDidChangeListener { [weak self] (_, user) in
            DispatchQueue.main.async {
                self?.currentUser = user // update current user
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        // create a new user account with email and password
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(.signInFailed)) // return error if sign-up fails
                return
            }
            
            if let user = result?.user {
                // create a profile for the new user in firestore
                self?.createUserProfile(for: user) { success in
                    completion(success ? .success(()) : .failure(.profileUpdateFailed))
                }
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        // sign in an existing user with email and password
        auth.signIn(withEmail: email, password: password) { result, error in
            if let _ = error {
                completion(.failure(.signInFailed)) // return error if sign-in fails
                return
            }
            completion(.success(())) // sign-in successful
        }
    }
    
    // MARK: - User Profile Management
    private func createUserProfile(for user: User, completion: @escaping (Bool) -> Void) {
        // user profile data with default fields
        let userData: [String: Any] = [
            "email": user.email ?? "", // user's email
            "createdAt": FieldValue.serverTimestamp(), // creation timestamp
            "betsWon": 0, // initial bets won count
            "betsLost": 0, // initial bets lost count
            "currentBets": [], // empty array for current bets
            "groups": [] // empty array for groups
        ]
        
        // add the user data to the firestore "users" collection
        db.collection("users").document(user.uid).setData(userData) { error in
            completion(error == nil) // success if no error
        }
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try auth.signOut() // log out the current user
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        // send a password reset email
        auth.sendPasswordReset(withEmail: email) { error in
            if let _ = error {
                completion(.failure(.passwordResetFailed)) // return error if reset fails
            } else {
                completion(.success(())) // reset successful
            }
        }
    }
}

// MARK: - Error Extension
extension AuthManager {
    // custom error types for auth operations
    enum AuthError: LocalizedError {
        case signInFailed // error for failed sign-in
        case noUser // error for no user found
        case profileUpdateFailed // error for failed profile creation
        case passwordResetFailed // error for failed password reset
        
        var errorDescription: String? {
            // error messages for each case
            switch self {
            case .signInFailed:
                return "Failed to sign in. Please try again."
            case .noUser:
                return "No user found. Please sign in."
            case .profileUpdateFailed:
                return "Failed to create profile. Please try again."
            case .passwordResetFailed:
                return "Failed to reset password. Please try again."
            }
        }
    }
}
