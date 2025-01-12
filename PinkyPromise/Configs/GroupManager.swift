//
//  GroupManager.swift
//  PinkyPromise
//
import Foundation
import FirebaseFirestore

class GroupManager {
    private var db: Firestore
    var userGroups: [Group] //stores groups user is part of
    var error: Error?  //error handling

    init() {
        self.db = Firestore.firestore()
        self.userGroups = []
    }

    //creates new group and updates database
    func createGroup(name: String, creator: String, members: [String]) -> Group {
        let groupId = UUID().uuidString //generating an id
        let newGroup = Group(id: groupId, name: name, creator: creator, members: members, bets: [])
        self.userGroups.append(newGroup)

        // Firestore add group code here
        let groupData: [String: Any] = [
            "id": newGroup.id,
            "name": newGroup.name,
            "creator": newGroup.creator,
            "members": newGroup.members,
            "bets": newGroup.bets,
        ]
        db.collection("groups").document(newGroup.id).setData(groupData) { error in
            if let error = error {
                print("Error adding group: \(error)")
                self.error = error
            }
        }
        
        return newGroup
    }

    //if group exists, member is added
    func joinGroup(groupId: String, newMember: String) {
        if let index = self.userGroups.firstIndex(where: { $0.id == groupId }) {
            if !self.userGroups[index].members.contains(newMember) {
                self.userGroups[index].members.append(newMember)
                // Firestore update group members code here
                db.collection("groups").document(groupId).updateData([
                    "members": FieldValue.arrayUnion([newMember])
                ]) { error in
                    if let error = error {
                        print("Error adding member: \(error)")
                        self.error = error
                    }
                }
            }
        }
    }

    //adds bets to group and updates firebase
    func addBetToGroup(groupId: String, bet: String) {
        if let index = self.userGroups.firstIndex(where: { $0.id == groupId }) {
            self.userGroups[index].bets.append(bet)
            // Firestore update group bets code here
            db.collection("groups").document(groupId).updateData([
                "bets": FieldValue.arrayUnion([bet])
            ]) { error in
                if let error = error {
                    print("Error adding bet: \(error)")
                    self.error = error
                }
            }
        }
    }

    //
    func listenToUserGroups(userId: String) {
        // Firestore listening to user's groups code here
        db.collection("groups").whereField("members", arrayContains: userId)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching groups: \(String(describing: error))")
                    self.error = error
                    return
                }
                self.userGroups = snapshot.documents.map { doc -> Group in
                    let data = doc.data()
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let creator = data["creator"] as? String ?? ""
                    let members = data["members"] as? [String] ?? []
                    let bets = data["bets"] as? [String] ?? []
                    let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    return Group(id: id, name: name, creator: creator, members: members, bets: bets)
                }
            }
    }
}
