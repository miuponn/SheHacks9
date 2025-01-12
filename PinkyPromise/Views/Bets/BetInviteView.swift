import SwiftUI

struct BetAcceptView: View {
    let betPrompt: String
    let betAmount: String
    let creator: String
    let betLength: Date
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let backgroundColor = Color(red: 0.2, green: 0.4, blue: 0.3)
    private let acceptColor = Color(red: 0.4, green: 0.7, blue: 0.3)
    private let declineColor = Color(red: 0.8, green: 0.3, blue: 0.2)
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Bet Invitation")
                .font(.customFont(size: 30))
                .fontWeight(.semibold)
                .foregroundColor(backgroundColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 48)
                .padding(.horizontal, 24)
            
            VStack(spacing: 24) {
                // Bet Information Card
                VStack(alignment: .leading, spacing: 20) {
                    Text("Bet Information")
                        .font(.customFont(size: 24))
                        .foregroundColor(.white)
                    
                    InfoRow(label: "Prompt", value: betPrompt)
                    InfoRow(label: "Bet Amount/Thing", value: betAmount)
                    InfoRow(label: "Creator", value: creator)
                    InfoRow(label: "Bet Length", value: formatDate(betLength))
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(backgroundColor)
                )
                
                // Accept/Decline Card
                VStack(spacing: 16) {
                    Button(action: {
                        handleAccept()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20))
                            Text("Accept")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(acceptColor)
                        .cornerRadius(25)
                        .foregroundColor(.white)
                    }
                    
                    Text("or")
                        .foregroundColor(.white)
                        .font(.customFont(size: 18))
                    
                    Button(action: {
                        handleDecline()
                    }) {
                        HStack(spacing: 12) {
                            Text("🤷‍♂️")
                                .font(.system(size: 20))
                            Text("Decline")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(declineColor)
                        .cornerRadius(25)
                        .foregroundColor(.white)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(backgroundColor)
                )
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Bet Response"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func handleAccept() {
        alertMessage = "Bet accepted!"
        showAlert = true
        // Add your accept logic here
    }
    
    private func handleDecline() {
        alertMessage = "Bet declined"
        showAlert = true
        // Add your decline logic here
    }
}

struct InfomationRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(label + ":")
                .font(.customFont(size: 20))
                .foregroundColor(.white)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.customFont(size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Preview
struct BetAcceptView_Previews: PreviewProvider {
    static var previews: some View {
        BetAcceptView(
            betPrompt: "XYZ",
            betAmount: "$200",
            creator: "XYZ",
            betLength: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 10)) ?? Date()
        )
    }
}
