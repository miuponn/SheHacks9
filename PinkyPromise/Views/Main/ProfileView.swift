//
//  ProfileView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
            
            Button("Sign Out") {
                authViewModel.signOut()
            }
            .foregroundColor(.red)
        }
    }
}
