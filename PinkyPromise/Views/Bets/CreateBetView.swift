//
//  CreateBetView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct CreateBetView: View {
    @State private var betPrompt = ""
    @State private var betAmount = ""
    @State private var duration = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create the Bet")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Bet Prompt")
                TextField("Enter bet prompt", text: $betPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Bet Amount/Thing")
                TextField("Enter amount", text: $betAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Options")
                // Add options button
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                
                Text("Duration")
                DatePicker("Select duration", selection: $duration, displayedComponents: .date)
            }
            .padding()
            
            Spacer()
        }
    }
}
