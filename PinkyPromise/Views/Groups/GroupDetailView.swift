//
//  GroupDetailView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct GroupDetailView: View {
    let groupName: String
    
    var body: some View {
        VStack {
            Text(groupName)
                .font(.title)
            
            VStack(alignment: .leading) {
                Text("Creator: Lauren")
                
                Text("Members:")
                ForEach(["Lola", "Lauren", "Fridge", "Carrot"], id: \.self) { member in
                    Text("• \(member)")
                }
                
                HStack {
                    Text("# of Team Bets:")
                    Text("10")
                        .bold()
                }
                
                Text("Your Score")
                Text("3 Loses | 7 Wins")
            }
            .padding()
        }
    }
}
