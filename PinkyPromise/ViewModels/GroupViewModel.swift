//
//  GroupViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation

class GroupViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var error: Error?
    
    private let groupManager = GroupManager()
    
    func createNewGroup(name: String) {
        Task {
            do {
                try await groupManager.createGroup(name: name)
                await loadUserGroups()
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func joinExistingGroup(groupId: String) {
        Task {
            do {
                try await groupManager.joinGroup(groupId: groupId)
                await loadUserGroups()
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func loadUserGroups() async {
        do {
            let userGroups = try await groupManager.getUserGroups()
            await MainActor.run {
                self.groups = userGroups
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    func addMemberToGroup(groupId: String, userId: String) {
        Task {
            do {
                try await groupManager.addMember(groupId: groupId, userId: userId)
                await loadUserGroups()
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
