//
//  ContentView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
//
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // Current Bets Tab
            CurrentBetsView()
                .tabItem {
                    Label("Current Bets", systemImage: "list.bullet")
                }
            
            // Groups Tab
            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.3")
                }
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

// Placeholder Views
struct CurrentBetsView: View {
    var body: some View {
        NavigationView {
            Text("Current Bets")
                .navigationTitle("Current Bets")
        }
    }
}

struct GroupsView: View {
    var body: some View {
        NavigationView {
            Text("Groups")
                .navigationTitle("Groups")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile")
                
                Button("Sign Out") {
                    authViewModel.signOut()
                }
                .padding()
                .foregroundColor(.red)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ContentView()
}

