//
//  FirebaseService.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation
import FirebaseFirestore

class FirebaseService {
    // MARK: - Singleton Instance
    static let shared = FirebaseService()
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - User Statistics
    
    /// Updates user statistics based on the bet result.
    func updateStats(userId: String, groupId: String?, betResult: Bool) async throws {
        let userRef = db.collection("users").document(userId)
        
        if betResult {
            try await userRef.updateData([
                "betsWon": FieldValue.increment(Int64(1))
            ])
        } else {
            try await userRef.updateData([
                "betsLost": FieldValue.increment(Int64(1))
            ])
        }
    }
    
    // MARK: - Batch Operations
    
    /// Performs batch updates for multiple documents.
    func batchUpdate(operations: [(collection: String, documentId: String, data: [String: Any])]) async throws {
        let batch = db.batch()
        
        for operation in operations {
            let docRef = db.collection(operation.collection).document(operation.documentId)
            batch.setData(operation.data, forDocument: docRef, merge: true)
        }
        
        try await batch.commit()
    }
}
