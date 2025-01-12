//
//  BetDetailView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct BetDetailView: View {
    var body: some View {
        VStack {
            Text("Ryan won't get a 4.0 GPA")
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("Prompt: XYZ")
                Text("Bet Amount/Thing: $200")
                Text("Creator: XYZ")
                Text("Bet Length: Jan 10, 2025 - Apr 18, 2025")
                
                HStack {
                    Text("Your Side:")
                    Text("Yes")
                }
                
                HStack {
                    Text("Vote Side:")
                    Text("Pending")
                }
            }
            .padding()
        }
    }
}

