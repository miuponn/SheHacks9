//
//  Bet.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation

enum BetStatus: String, Codable {
    case pending   // Just created
    case active    // All participants joined
    case completed // Time ended, result determined
}

struct Bet: Codable, Identifiable {
    let id: String
    let prompt: String
    let amount: Double
    let creator: String // User ID
    let createdAt: Date
    let startDate: Date
    let endDate: Date
    var participants: [String] // User IDs
    var votes: [String: Bool] // [UserID: Vote]
    var status: BetStatus
    let groupId: String? // Optional group association
}
