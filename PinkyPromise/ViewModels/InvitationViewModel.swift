//
//  InvitationViewModel.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-12.
//
import Foundation
import Combine

class InvitationViewModel: ObservableObject {
    private let invitationManager = InvitationManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var pendingBetInvites: [BetInvitation] = []
    @Published var pendingGroupInvites: [GroupInvitation] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    // Share sheet state
    @Published var showingShareSheet = false
    @Published var inviteLink: String?
    
    init() {
        // Subscribe to invitation manager
        invitationManager.$pendingBetInvites
            .assign(to: &$pendingBetInvites)
        
        invitationManager.$pendingGroupInvites
            .assign(to: &$pendingGroupInvites)
    }
    
    // MARK: - Invitation Actions
    func acceptBetInvitation(inviteId: String) {
        isLoading = true
        Task {
            do {
                try await invitationManager.respondToBetInvite(inviteId: inviteId, accept: true)
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func declineBetInvitation(inviteId: String) {
        Task {
            try? await invitationManager.respondToBetInvite(inviteId: inviteId, accept: false)
        }
    }
    
    // MARK: - Share Functions
    func generateShareLink(for betId: String) {
        // Generate deep link for bet invitation
        inviteLink = "pinkyPromise://bet/\(betId)"
        showingShareSheet = true
    }
    
    func generateGroupShareLink(for groupId: String) {
        // Generate deep link for group invitation
        inviteLink = "pinkyPromise://group/\(groupId)"
        showingShareSheet = true
    }
    
    // MARK: - Local Data
    var hasPendingInvites: Bool {
        !pendingBetInvites.isEmpty || !pendingGroupInvites.isEmpty
    }
}
