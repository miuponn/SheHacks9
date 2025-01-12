//
//  User.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import FirebaseAuth
import FirebaseFirestore

// Basic user model that extends Firebase User data
struct User: Codable, Identifiable {
    let id: String      // Firebase Auth UID
    let email: String
    var displayName: String?
    let createdAt: Date
    
    // Initialize from Firebase Auth User
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.displayName = firebaseUser.displayName
        self.createdAt = Date()
    }
}

// Extended profile model for our app's specific user data
struct UserProfile: Codable, Identifiable {
    let id: String          // Same as User.id (Firebase Auth UID)
    let email: String
    var displayName: String?
    var betsWon: Int
    var betsLost: Int
    var currentBets: [String]  // Bet IDs
    var groups: [String]       // Group IDs
    let createdAt: Date
    
    // Initialize new profile from User
    init(from user: User) {
        self.id = user.id
        self.email = user.email
        self.displayName = user.displayName
        self.betsWon = 0
        self.betsLost = 0
        self.currentBets = []
        self.groups = []
        self.createdAt = user.createdAt
    }
    
    // Initialize from Firestore document
    init(from dict: [String: Any]) throws {
        guard let id = dict["id"] as? String,
              let email = dict["email"] as? String,
              let createdAt = (dict["createdAt"] as? Timestamp)?.dateValue() else {
            throw UserError.invalidData
        }
        
        self.id = id
        self.email = email
        self.displayName = dict["displayName"] as? String
        self.betsWon = (dict["betsWon"] as? Int) ?? 0
        self.betsLost = (dict["betsLost"] as? Int) ?? 0
        self.currentBets = (dict["currentBets"] as? [String]) ?? []
        self.groups = (dict["groups"] as? [String]) ?? []
        self.createdAt = createdAt
    }
    
    // Convert to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "displayName": displayName as Any,
            "betsWon": betsWon,
            "betsLost": betsLost,
            "currentBets": currentBets,
            "groups": groups,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
