import SwiftUI

// Colors shared between views
private let orangeColor = Color(red: 0.89, green: 0.45, blue: 0.31) // #E37450
private let greenColor = Color(red: 0.23, green: 0.35, blue: 0.30) // #3B584C

// Winner View
struct WinnerView: View {
    let betPrompt: String
    let amount: Int
    let userSide: String
    let voteSide: String
    var onNewGame: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Result")
                .font(.title2)
                .foregroundColor(greenColor)
                .padding(.horizontal, 16)
            
            // Result Card
            VStack(alignment: .leading, spacing: 12) {
                Text("You won $\(amount) on:")
                    .font(.title3)
                    .foregroundColor(.white)
                
                Text(betPrompt)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
                
                // User side row
                HStack(spacing: 8) {
                    Image(systemName: "person.circle")
                        .foregroundColor(.white)
                    Text("Your Side: ")
                        .foregroundColor(.white)
                    Text(userSide)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                // Vote side row
                HStack(spacing: 8) {
                    Image(systemName: "person.2")
                        .foregroundColor(.white)
                    Text("Vote Side: ")
                        .foregroundColor(.white)
                    Text(voteSide)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                // Reward row
                HStack(spacing: 8) {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                    Text("Reward: ")
                        .foregroundColor(.white)
                    Text("$\(amount)")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(greenColor)
            )
            .padding(.horizontal, 16)
            
            // New Game Button
            Button {
                onNewGame()
            } label: {
                Text("New Game")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(orangeColor)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            Spacer()
        }
    }
}

// Loser View
struct LoserView: View {
    let betPrompt: String
    let amount: Int
    let userSide: String
    let voteSide: String
    var onNewGame: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Loser")
                .font(.title)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Text("Result")
                .font(.title2)
                .foregroundColor(greenColor)
                .padding(.horizontal)
            
            // Result Card
            VStack(alignment: .leading, spacing: 16) {
                Text("You lost $\(amount) on:")
                    .font(.title3)
                    .foregroundColor(.white)
                
                Text(betPrompt)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                // User side row
                HStack(spacing: 12) {
                    Image(systemName: "person.circle")
                        .foregroundColor(.white)
                    Text("Your Side: \(userSide)")
                        .foregroundColor(.white)
                }
                
                // Vote side row
                HStack(spacing: 12) {
                    Image(systemName: "person.2")
                        .foregroundColor(.white)
                    Text("Vote Side: \(voteSide)")
                        .foregroundColor(.white)
                }
                
                // Down row
                HStack(spacing: 12) {
                    Image(systemName: "cloud.rain")
                        .foregroundColor(.white)
                    Text("Down: $\(amount)")
                        .foregroundColor(.white)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(orangeColor)
            )
            .padding(.horizontal)
            
            // New Game Button
            Button {
                onNewGame()
            } label: {
                Text("New Game")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(orangeColor)
                    )
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

// Previews
struct WinnerView_Previews: PreviewProvider {
    static var previews: some View {
        WinnerView(
            betPrompt: "Pinky Promise will win SheHacks!",
            amount: 300,
            userSide: "Yes",
            voteSide: "Yes",
            onNewGame: {}
        )
    }
}

struct LoserView_Previews: PreviewProvider {
    static var previews: some View {
        LoserView(
            betPrompt: "Pinky Promise will win SheHacks!",
            amount: 200,
            userSide: "No",
            voteSide: "Yes",
            onNewGame: {}
        )
    }
}
