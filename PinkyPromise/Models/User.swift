//
//  User.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var username: String
    var email: String
    var profilePhotoURL: String?
    var betsWon: Int
    var betsLost: Int
    var groups: [String] // Array of Group IDs the user is part of
    var createdAt: Date
}
