//
//  SignupView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.title)
            
            TextField("Enter Email", text: $authViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Create Password", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Sign Up") {
                authViewModel.signUp()
            }
            .disabled(authViewModel.isLoading)
            
            NavigationLink("Already have an account? Login", destination: LoginView())
        }
        .padding()
    }
}
