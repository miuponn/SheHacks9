import SwiftUI

struct BetDetailView: View {
    let bet: BetItem
    @Environment(\.dismiss) private var dismiss
    
    private let mainColor = Color(red: 0.2, green: 0.4, blue: 0.3)
    private let cardColor = Color(red: 0.4, green: 0.6, blue: 1.0)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with back button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                Text("History of Bet")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            
            // Bet Title
            Text(bet.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(mainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 24)
            
            // Details Card
            VStack(alignment: .leading, spacing: 16) {
                DetailRow(label: "Prompt:", value: "XYZ")
                DetailRow(label: "Bet Amount/Thing:", value: "$200")
                DetailRow(label: "Creator:", value: "XYZ")
                DetailRow(label: "Bet Length:", value: formatDateRange(start: bet.startDate, end: bet.endDate))
                DetailRow(label: "Group:", value: "CHAHAHAH")
                
                // User Status Rows
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                    Text("Your Side:")
                        .foregroundColor(.white)
                    Text("Yes")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .padding(.top, 8)
                
                HStack(spacing: 12) {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.white)
                    Text("Vote Side:")
                        .foregroundColor(.white)
                    Text("Pending")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardColor)
            )
            .padding()
            
            Spacer()
        }
        .withBottomNavBar()
    }
    
    private func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .foregroundColor(.white)
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}
