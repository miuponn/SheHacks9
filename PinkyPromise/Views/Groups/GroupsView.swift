//
//  GroupsView.swift
//  PinkyPromise
//
//  Created by Kelly Gao on 2025-01-11.
//
import SwiftUI

struct GroupsView: View {
    var body: some View {
        VStack {
            Text("Groups")
                .font(.title)
            
            List {
                ForEach(["Team Sparkle", "Team Oh-No", "Team Lemon", "Rock"], id: \.self) { group in
                    NavigationLink(destination: GroupDetailView(groupName: group)) {
                        HStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Text(group)
                            Text("Created 1/11/2025")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}
