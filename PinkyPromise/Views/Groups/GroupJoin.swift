import SwiftUI

struct GroupInvitationAcceptanceView: View {
    let groupName: String = "Team Sparkle"
    @State private var selectedTab = 2 // Middle tab selected by default
    
    private let mainColor = Color(red: 0.2, green: 0.4, blue: 0.3)
    private let orangeColor = Color(red: 0.8, green: 0.4, blue: 0.2)
    private let acceptColor = Color(red: 0.4, green: 0.7, blue: 0.4)
    private let declineColor = Color(red: 0.8, green: 0.3, blue: 0.2)
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content
            VStack(spacing: 32) {
                Text("Group Invitation")
                    .font(.customFont(size: 24))
                    .foregroundColor(mainColor)
                
                // Profile Circle
                Circle()
                    .fill(Color(red: 0.95, green: 0.85, blue: 0.95))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text("🤔")
                            .font(.system(size: 40))
                    )
                
                // Welcome Text
                VStack(spacing: 16) {
                    Text("Your are welcome to join...")
                        .font(.customFont(size: 20))
                        .foregroundColor(.gray)
                    
                    Text(groupName)
                        .font(.customFont(size: 32))
                        .foregroundColor(mainColor)
                }
                
                // Action Buttons Container
                VStack(spacing: 16) {
                    // Accept Button
                    Button(action: {
                        // Accept action
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Accept")
                                .font(.customFont(size: 20))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(acceptColor)
                        )
                    }
                    
                    // Decline Button
                    Button(action: {
                        // Decline action
                    }) {
                        HStack {
                            Text("🏃")
                            Text("Decline")
                                .font(.customFont(size: 20))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(declineColor)
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 32)
            
            Spacer()
            .padding(.vertical, 16)
            .background(orangeColor)
        }
        .background(Color(white: 0.95))
    }
    
    private func getIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "person.2.fill"
        case 2: return "hand.point.up.left.and.point.up.right.fill"
        case 3: return "doc.text.fill"
        case 4: return "arrow.clockwise"
        default: return "circle.fill"
        }
    }
}

struct GroupInvitationAcceptanceView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInvitationAcceptanceView()
    }
}
