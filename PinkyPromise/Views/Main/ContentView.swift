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
        ZStack {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
                    .transition(.opacity)
            } else {
                NavigationView {
                    LoginView()
                        .environmentObject(authViewModel)
                        .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated) // Smooth transition
    }
}
