//
//  AuthManager.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    @Published var currentUser: User?
    @Published var userProfile: UserProfile?
    @Published var error: AuthError?
    
    private init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] (_, firebaseUser) in
            if let firebaseUser = firebaseUser {
                let user = User(from: firebaseUser)
                self?.currentUser = user
                self?.fetchUserProfile(userId: user.id)
            } else {
                self?.currentUser = nil
                self?.userProfile = nil
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<UserProfile, AuthError>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(.signUpFailed(error)))
                return
            }
            
            if let firebaseUser = result?.user {
                let user = User(from: firebaseUser)
                self?.createUserProfile(from: user) { result in
                    completion(result)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserProfile, AuthError>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(.signInFailed(error)))
                return
            }
            
            if let firebaseUser = result?.user {
                self?.fetchUserProfile(userId: firebaseUser.uid) { result in
                    switch result {
                    case .success(let profile):
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func createUserProfile(from user: User, completion: @escaping (Result<UserProfile, AuthError>) -> Void) {
        let profile = UserProfile(from: user)
        let userRef = db.collection("users").document(user.id)
        
        do {
            try userRef.setData(from: profile) { error in
                if let error = error {
                    completion(.failure(.profileCreationFailed(error)))
                } else {
                    completion(.success(profile))
                }
            }
        } catch {
            completion(.failure(.profileCreationFailed(error)))
        }
    }
    
    private func fetchUserProfile(userId: String, completion: ((Result<UserProfile, AuthError>) -> Void)? = nil) {
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                completion?(.failure(.profileFetchFailed(error)))
                return
            }
            
            if let data = document?.data() {
                do {
                    let profile = try UserProfile(from: data)
                    self?.userProfile = profile
                    completion?(.success(profile))
                } catch {
                    completion?(.failure(.profileDecodingFailed(error)))
                }
            } else {
                completion?(.failure(.profileNotFound))
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
        userProfile = nil
    }
}

enum AuthError: LocalizedError {
    case signUpFailed(Error)
    case signInFailed(Error)
    case profileCreationFailed(Error)
    case profileFetchFailed(Error)
    case profileDecodingFailed(Error)
    case profileNotFound
    case notAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .signUpFailed(let error): return "Failed to sign up: \(error.localizedDescription)"
        case .signInFailed(let error): return "Failed to sign in: \(error.localizedDescription)"
        case .profileCreationFailed(let error): return "Failed to create profile: \(error.localizedDescription)"
        case .profileFetchFailed(let error): return "Failed to fetch profile: \(error.localizedDescription)"
        case .profileDecodingFailed(let error): return "Failed to decode profile: \(error.localizedDescription)"
        case .profileNotFound: return "User profile not found"
        case .notAuthenticated: return "User not authenticated"
        }
    }
}
