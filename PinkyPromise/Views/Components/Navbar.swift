import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        HStack(spacing: 40) {
            NavigationButton(iconName: "house")
            NavigationButton(iconName: "person.2")
            
            // Center Button
            Button(action: {}) {
                Circle()
                    .fill(Color(red: 0.9, green: 0.7, blue: 1.0))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "hand.tap")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    )
            }
            .offset(y: -20)
            
            NavigationButton(iconName: "list.clipboard")
            NavigationButton(iconName: "arrow.clockwise")
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color(red: 0.8, green: 0.4, blue: 0.3))
    }
}

struct NavigationButton: View {
    let iconName: String
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
    }
}
