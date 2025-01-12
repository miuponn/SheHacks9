import SwiftUI

struct BetInvitationView: View {
    let betPrompt: String
    let betAmount: String
    let options: [String]
    let startDate: Date
    let endDate: Date
    
    @State private var showShareSheet = false
    @State private var showAirDrop = false
    
    private let backgroundColor = Color(red: 0.2, green: 0.4, blue: 0.3)
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Send a Bet Invitation")
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
                    InfoRow(label: "Options", value: options.joined(separator: ", "))
                    InfoRow(label: "Bet Start", value: formatDate(startDate))
                    InfoRow(label: "Bet End", value: formatDate(endDate))
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(backgroundColor)
                )
                
                // Sharing Options Card
                VStack(spacing: 16) {
                    Button(action: {
                        shareLink()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "link")
                            Text("Send invite link")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .foregroundColor(.black)
                    }
                    
                    Text("or")
                        .foregroundColor(.white)
                        .font(.customFont(size: 18))
                    
                    Button(action: {
                        showAirDrop = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "paperplane.fill")
                            Text("AirDrop")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .foregroundColor(.black)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(backgroundColor)
                )
            }
            .padding(.horizontal, 24)
            
            Text("**Maximum number of 9 people")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [createShareText()])
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func shareLink() {
        showShareSheet = true
    }
    
    private func createShareText() -> String {
        """
        New Bet Invitation!
        Prompt: \(betPrompt)
        Amount: \(betAmount)
        Options: \(options.joined(separator: ", "))
        Start: \(formatDate(startDate))
        End: \(formatDate(endDate))
        """
    }
}

struct InfoRow: View {
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

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview
struct BetInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        BetInvitationView(
            betPrompt: "XYZ",
            betAmount: "$200",
            options: ["Yes", "No"],
            startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 10)) ?? Date(),
            endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 13)) ?? Date()
        )
    }
}
