//
//  AuthViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false // auth state
    @Published var isLoading = false // loading state
    @Published var error: String? // error msg
    @Published var email = "" // user email
    @Published var password = "" // user password
    
    private let authManager = AuthManager.shared // shared auth manager
    
    init() {
        authManager.$currentUser // observe current user
            .map { $0 != nil } // map to auth state
            .assign(to: &$isAuthenticated)
        
        authManager.$error // observe errors
            .map { $0?.localizedDescription }
            .assign(to: &$error)
    }
    
    // MARK: - Sign In
    func signIn() {
        isLoading = true // start loading
        authManager.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false // stop loading
                switch result {
                case .success:
                    self?.isAuthenticated = true // set auth state
                    self?.clearFields() // clear inputs
                case .failure(let error):
                    self?.error = error.localizedDescription // handle error
                }
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp() {
        isLoading = true // start loading
        authManager.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false // stop loading
                switch result {
                case .success:
                    self?.isAuthenticated = true // set auth state
                    self?.clearFields() // clear inputs
                case .failure(let error):
                    self?.error = error.localizedDescription // handle error
                }
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try authManager.signOut() // attempt sign out
            isAuthenticated = false // reset auth state
        } catch {
            self.error = error.localizedDescription // handle error
        }
    }
    
    // MARK: - Clear Fields
    private func clearFields() {
        email = "" // reset email
        password = "" // reset password
        error = nil // reset error
    }
}
