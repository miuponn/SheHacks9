//
//  MainTabView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.2.fill")
                }
            
<<<<<<< HEAD
            BetCreationView()
=======
            BetCreationView() // Updated from CreateBetView
>>>>>>> ec40fdc (Temp changes)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
    }
}
