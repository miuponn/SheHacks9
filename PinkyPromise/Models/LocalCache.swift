//
//  LocalCache.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation

struct LocalCache: Codable {
    var userId: String
    var lastSync: Date
    var activeBetIds: Set<String>
    var pendingBetIds: Set<String>
    var groupIds: Set<String>
    
    static func load() -> LocalCache? {
        guard let data = UserDefaults.standard.data(forKey: "localCache"),
              let cache = try? JSONDecoder().decode(LocalCache.self, from: data) else {
            return nil
        }
        return cache
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "localCache")
        }
    }
}
