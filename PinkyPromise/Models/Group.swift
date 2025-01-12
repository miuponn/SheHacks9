//
//  Group.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation
import FirebaseFirestore

struct Group: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var name: String
    var creatorId: String // User ID of the group creator
    var members: [String] // Array of User IDs
    var createdAt: Date
    var activeBets: [String] // Array of Bet IDs
}
