//
//  Group.swift
//  PinkyPromise
//

class Group {
    var id: String
    var name: String
    var creator: String
    var members: [String]
    var bets: [String]
    //var createdAt: Date

    init(id: String, name: String, creator: String, members: [String], bets: [String]) {
        self.id = id
        self.name = name
        self.creator = creator
        self.members = members
        self.bets = bets
        //self.createdAt = createdAt
    }
}
