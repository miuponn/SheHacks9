//
//  User.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI
import Foundation

struct User{
    var id: String
    var email: String
}

struct UserProfile{
    let user: User
    var displayName:String
    var betsWon: Int
    var betsLost: Int
    var currentBets: [String]
    var groups: [String]
    
    
}

