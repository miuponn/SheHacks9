//
//  AuthViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    
    private let authManager = AuthManager.shared
    
    init() {
        // Check if user is already signed in
        authManager.$currentUser
            .map { $0 != nil }
            .assign(to: &$isAuthenticated)
    }
    
    func signIn() {
        isLoading = true
        error = nil
        
        authManager.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAuthenticated = true
                    self?.clearFields()
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
    
    func signUp() {
        isLoading = true
        error = nil
        
        authManager.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAuthenticated = true
                    self?.clearFields()
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            isAuthenticated = false
            clearFields()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
        error = nil
    }
}
