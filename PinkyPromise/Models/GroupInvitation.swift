//
//  GroupInvitation.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation
import FirebaseFirestoreSwift

struct GroupInvitation: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var groupId: String
    var fromUserId: String
    var toUserId: String
    var createdAt: Date
}
enum InvitationType {
    case bet
    case group
}
