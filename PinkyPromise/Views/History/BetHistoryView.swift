import SwiftUI

struct BetHistoryView: View {
    let passedImage: Image?
    @State private var selectedTab = 2
    @State private var bets: [BetItem]
    
    private let mainColor = Color(red: 0.2, green: 0.4, blue: 0.3)
    
    init(passedImage: Image?) {
        self.passedImage = passedImage
        _bets = State(initialValue: [
            BetItem(title: "Ryan won't get at 4.0 GPA",
                   startDate: Date(timeIntervalSinceNow: -86400),
                   endDate: Date(timeIntervalSinceNow: 86400 * 30),
                   displayImage: passedImage),
            BetItem(title: "Kelly won't sleep this weekend",
                   startDate: Date(timeIntervalSinceNow: -86400 * 2),
                   endDate: Date(timeIntervalSinceNow: 86400 * 2),
                   displayImage: passedImage),
            BetItem(title: "Carrie can't touch her toes",
                   startDate: Date(timeIntervalSinceNow: -86400),
                   endDate: Date(timeIntervalSinceNow: 86400 * 7),
                   displayImage: passedImage),
            BetItem(title: "Liam won't play LoL",
                   startDate: Date(timeIntervalSinceNow: -86400 * 3),
                   endDate: Date(timeIntervalSinceNow: 86400 * 14),
                   displayImage: passedImage)
        ])
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                Text("History")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                // All Bets Header
                Text("All Bets")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(mainColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Bet List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(bets) { bet in
                            NavigationLink(destination: BetDetailView(bet: bet)) {
                                HStack(spacing: 12) {
                                    // Profile Circle with passed image
                                    ZStack {
                                        Circle()
                                            .fill(getCircleColor(for: bet))
                                            .frame(width: 50, height: 50)
                                        
                                        if let displayImage = bet.displayImage {
                                            displayImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } else {
                                            Text("🤔")
                                                .font(.system(size: 24))
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bet.title)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        HStack {
                                            Image(systemName: "clock")
                                                .font(.system(size: 12))
                                            Text(formatDateRange(start: bet.startDate, end: bet.endDate))
                                                .font(.system(size: 12))
                                        }
                                        .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 80) // Add padding for nav bar
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .withBottomNavBar()
    }
    
    private func getCircleColor(for bet: BetItem) -> Color {
        let colors: [Color] = [
            .blue,
            .pink,
            .cyan,
            .yellow
        ]
        let index = abs(bet.title.hashValue) % colors.count
        return colors[index]
    }
    
    private func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

