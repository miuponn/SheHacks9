//
//  DashBoardView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome member!")
                .font(.title)
            
            // Current Bets Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Current Bets")
                    .font(.headline)
                
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.1))
                        .frame(height: 60)
                        .overlay(
                            HStack {
                                Text("Sample Bet")
                                Spacer()
                                Text("Pending")
                            }
                            .padding()
                        )
                }
            }
            
            // Bets Won Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Bets Won")
                    .font(.headline)
                
                ForEach(0..<2) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.1))
                        .frame(height: 60)
                        .overlay(
                            HStack {
                                Text("Won Bet")
                                Spacer()
                                Text("$20")
                            }
                            .padding()
                        )
                }
            }
        }
        .padding()
    }
}

