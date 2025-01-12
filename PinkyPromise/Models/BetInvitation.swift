//
//  BetInvitation.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation
import FirebaseFirestoreSwift

struct BetInvitation: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var betId: String
    var fromUserId: String
    var toUserId: String
    var createdAt: Date
}
