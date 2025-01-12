//
//  UserProfile.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation

struct UserProfile: Identifiable {
    var id: String
    var username: String
    var email: String
    var profilePhotoURL: String?
    var betsWon: Int
    var betsLost: Int
    
    init(from user: User) {
        self.id = user.id ?? UUID().uuidString
        self.username = user.username
        self.email = user.email
        self.profilePhotoURL = user.profilePhotoURL
        self.betsWon = user.betsWon
        self.betsLost = user.betsLost
    }
}
