//
//  GroupHistoryView.swift
//  PinkyPromise
//
//  Created by Lauren Hong  on 2025-01-12.
//

import SwiftUI

struct Group: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
    let createdDate: Date
}

struct GroupsView: View {
    let groups = [
        Group(name: "Team Sparkle", emoji: "😟", color: .blue, createdDate: Date()),
        Group(name: "Team Oh-No", emoji: "🤗", color: .pink, createdDate: Date()),
        Group(name: "Team Lemon", emoji: "🤔", color: .cyan, createdDate: Date()),
        Group(name: "Rock", emoji: "👺", color: .yellow, createdDate: Date())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Groups")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ForEach(groups) { group in
                        GroupRow(group: group)
                    }
                }
            }
            .background(Color(white: 0.95))
        }
    }
}

struct GroupRow: View {
    let group: Group
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(group.color)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(group.emoji)
                        .font(.title)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text("Created \(formattedDate(group.createdDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: date)
    }
}

#Preview("Groups") {
    Group {
        GroupsView()
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
        
        GroupsView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        
        GroupsView()
            .previewDevice("iPhone SE (3rd generation)")
            .previewDisplayName("iPhone SE")
        
        NavigationView {
            GroupRow(group: Group(
                name: "Team Sparkle",
                emoji: "😟",
                color: .blue,
                createdDate: Date()
            ))
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Single Row")
    }
}
