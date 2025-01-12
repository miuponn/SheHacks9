//
//  AppError.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
//
import Foundation

enum AppError: LocalizedError {
    case notAuthenticated
    case userNotFound
    case groupNotFound
    case betNotFound
    case invitationNotFound
    case alreadyVoted
    case firestoreError(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be signed in to perform this action."
        case .userNotFound:
            return "User not found."
        case .groupNotFound:
            return "Group not found."
        case .betNotFound:
            return "Bet not found."
        case .invitationNotFound:
            return "Invitation not found."
        case .alreadyVoted:
            return "You have already voted on this bet."
        case .firestoreError(let error):
            return error.localizedDescription
        }
    }
}

enum UserError: LocalizedError {
    case profileUpdateFailed(Error)
    case userCreationFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .profileUpdateFailed(let error):
            return "Failed to update profile: \(error.localizedDescription)"
        case .userCreationFailed(let error):
            return "Failed to create user: \(error.localizedDescription)"
        }
    }
}

enum GroupError: LocalizedError {
    case invalidName
    case creationFailed(Error)
    case updateFailed(Error)
    case groupCreationFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "Group name cannot be empty."
        case .creationFailed(let error):
            return "Failed to create group: \(error.localizedDescription)"
        case .updateFailed(let error):
            return "Failed to update group: \(error.localizedDescription)"
        case .groupCreationFailed(let error):
            return "Failed to initialize group: \(error.localizedDescription)"
        }
    }
}

enum InvitationError: LocalizedError {
    case invitationNotFound
    case respondFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invitationNotFound:
            return "Invitation not found."
        case .respondFailed(let error):
            return "Failed to respond to invitation: \(error.localizedDescription)"
        }
    }
}
