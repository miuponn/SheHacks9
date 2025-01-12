//
//  Group.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct Group: Codable, Identifiable {
    let id: String
    let name: String
    let creator: String // User ID
    var members: [String] // User IDs
    var activeBets: [String] // Bet IDs
    var completedBets: [String] // Bet IDs
    let createdAt: Date
}
