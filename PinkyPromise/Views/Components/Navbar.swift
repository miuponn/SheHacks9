import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        HStack(spacing: 40) {
            BottomNavButton(icon: "house", action: {})
            BottomNavButton(icon: "person.2", action: {})
            
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
            
            BottomNavButton(icon: "list.clipboard", action: {})
            BottomNavButton(icon: "arrow.clockwise", action: {})
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color(red: 0.8, green: 0.4, blue: 0.3))
    }
}

struct BottomNavButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
    }
}
