//
//  UserError.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation

enum UserError: LocalizedError {
    case invalidData
    case notAuthenticated
    case profileNotFound
    case updateFailed
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid user data format"
        case .notAuthenticated:
            return "User is not authenticated"
        case .profileNotFound:
            return "User profile not found"
        case .updateFailed:
            return "Failed to update user data"
        case .decodingError:
            return "Failed to decode user data"
        case .networkError:
            return "Network error occurred"
        }
    }
}

