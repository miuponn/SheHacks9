//
//  TimestampedItem.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation

protocol TimestampedItem {
    var lastUpdated: Date { get }
    var needsRefresh: Bool { get }
}

extension TimestampedItem {
    var needsRefresh: Bool {
        Date().timeIntervalSince(lastUpdated) > 300 // 5 minutes default
    }
}
