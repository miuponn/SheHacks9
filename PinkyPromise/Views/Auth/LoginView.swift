//
//  LoginView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isSignup = false
    
    var body: some View {
        VStack {
            // Logo
            Image("pinky_promise_logo") // Make sure this asset exists
                .resizable()
                .frame(width: 80, height: 80)
            
            Text("Pinky Promise")
                .font(.title)
            
            Text("Betting with a twist...")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Input fields
            TextField("Enter Email", text: $authViewModel.email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
            
            SecureField("Enter Password", text: $authViewModel.password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            // Login/Signup Button
            Button(action: {
                if isSignup {
                    authViewModel.signUp()
                } else {
                    authViewModel.signIn()
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(isSignup ? "Sign Up" : "Login")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(authViewModel.isLoading)
            
            Button {
                isSignup.toggle()
            } label: {
                Text(isSignup ? "Already have an account? Login" : "Don't have an account? Sign up")
                    .foregroundColor(.blue)
            }
            .padding()
            
            if !isSignup {
                Button("Forgot Password? Reset Now") {
                    // Add reset password functionality if needed
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("SheHacks 9")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
