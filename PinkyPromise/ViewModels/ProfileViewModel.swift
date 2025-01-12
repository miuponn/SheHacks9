//
//  ProfileViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var error: Error?
    
    private let userManager = UserManager()
    
    func loadUserProfile() {
        Task {
            do {
                let user = try await userManager.getCurrentUserProfile()
                let userProfile = UserProfile(from: user) // Convert User to UserProfile
                await MainActor.run {
                    self.profile = userProfile
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func updateProfile() {
        // Add profile update logic if needed
    }
    
    func getBetStatistics() -> (won: Int, lost: Int) {
        guard let profile = profile else { return (0, 0) }
        return (profile.betsWon, profile.betsLost)
    }
}
