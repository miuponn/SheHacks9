//
//  LoginView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel() // auth view model
    @State private var isSignUp = false // toggle for login/signup
    
    var body: some View {
        ZStack {
            // Background with rays
            GeometryReader { geometry in
                ZStack {
                    Color("E76F51") // coral background
                        .ignoresSafeArea()
                    
                    // Blue rays
                    ForEach(0..<6) { index in
                        Rectangle()
                            .fill(Color("89C2D9")) // blue color
                            .frame(width: geometry.size.width * 1.5)
                            .rotationEffect(.degrees(Double(index) * 30)) // rotate rays
                            .offset(y: -geometry.size.height * 0.3)
                    }
                }
            }
            
            VStack(spacing: 24) {
                Spacer()
                
                // Logo circle with hands
                Circle()
                    .fill(Color("FFD7E2")) // pink circle
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "hand.point.up.left.fill") // hand icon
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                    )
                
                // App title and subtitle
                VStack(spacing: 8) {
                    Text("Pinky Promise") // app title
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Betting with a twist...") // app tagline
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Login/Signup Form
                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email) // email input
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $viewModel.password) // password input
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if isSignUp { // toggle signup/login
                            viewModel.signUp()
                        } else {
                            viewModel.signIn()
                        }
                    }) {
                        Text(isSignUp ? "Sign Up" : "Login") // button label
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24) // form padding
                
                // Loading and error states
                if viewModel.isLoading {
                    ProgressView() // loading spinner
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                if let error = viewModel.error {
                    Text(error) // error msg
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                // Toggle between Login and Sign Up
                Button(action: {
                    isSignUp.toggle() // toggle form mode
                    viewModel.error = nil // clear error
                }) {
                    Text(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                .padding(.bottom, 32) // bottom spacing
            }
        }
    }
}

// Preview for testing UI
#Preview {
    LoginView()
}
