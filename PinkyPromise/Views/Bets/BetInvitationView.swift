//
//  BetInvitationView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct BetInvitationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Bet Information")
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text("Prompt: XYZ")
                Text("Bet Amount/Thing: $200")
                Text("Options: Yes, No")
                Text("Bet Start: January 10, 2025")
                Text("Bet End: January 13, 2025")
            }
            
            HStack(spacing: 20) {
                Button("Accept") {
                    // Accept action
                }
                .foregroundColor(.green)
                
                Button("Decline") {
                    // Decline action
                }
                .foregroundColor(.red)
            }
        }
        .padding()
    }
}
