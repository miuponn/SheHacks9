//
//  Bet.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation
import FirebaseFirestore

enum BetStatus: String, Codable {
    case pending
    case active
    case completed
}

struct Bet: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var prompt: String
    var amount: Double
    var creatorId: String // User ID of the bet creator
    var createdAt: Date
    var startDate: Date
    var endDate: Date
    var participants: [String] // Array of User IDs
    var votes: [String: Bool] // User ID to vote mapping
    var status: BetStatus
    var groupId: String? // Associated Group ID, if any
    var result: Bool? // Final result of the bet
    var lastUpdated: Date
    var lastChecked: Date
}
