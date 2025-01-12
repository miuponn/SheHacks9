//
//  ContentView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
                    .transition(.opacity) // Smooth transition
            } else {
                NavigationView {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
        .animation(.default, value: authViewModel.isAuthenticated) // Animate transitions
    }
}

