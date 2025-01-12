//
//  GroupViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import Foundation

class GroupViewModel: ObservableObject {
    private let groupManager = GroupManager()
    
    @Published var groups: [Group] = []
    @Published var selectedGroup: Group?
    @Published var groupStats: (wins: Int, losses: Int)?
    @Published var error: AppError?
    @Published var isLoading = false
    
    // For group creation
    @Published var newGroupName = ""
    
    func createGroup() {
        guard !newGroupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            error = GroupError.invalidName
            return
        }
        
        isLoading = true
        Task {
            do {
                let _ = try await groupManager.createGroup(name: newGroupName)
                await loadGroups()
                await MainActor.run {
                    newGroupName = ""
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error as? AppError ?? GroupError.creationFailed(error)
                    isLoading = false
                }
            }
        }
    }
    
    func loadGroups() async {
        isLoading = true
        do {
            let userGroups = try await groupManager.getUserGroups()
            await MainActor.run {
                self.groups = userGroups
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error as? AppError ?? GroupError.notFound
                isLoading = false
            }
        }
    }
    
    func joinGroup(groupId: String) {
        isLoading = true
        Task {
            do {
                try await groupManager.joinGroup(groupId: groupId)
                await loadGroups()
            } catch {
                await MainActor.run {
                    self.error = error as? AppError ?? GroupError.updateFailed(error)
                    isLoading = false
                }
            }
        }
    }
    
    func loadGroupStats(groupId: String) {
        Task {
            do {
                let stats = try await groupManager.getGroupStats(groupId: groupId)
                await MainActor.run {
                    self.groupStats = stats
                }
            } catch {
                await MainActor.run {
                    self.error = error as? AppError ?? GroupError.notFound
                }
            }
        }
    }
}
