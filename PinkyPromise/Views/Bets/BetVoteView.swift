import SwiftUI

struct VotingOptionsView: View {
    let options: [String]
    @Binding var selectedOption: String?
    
    // Colors matching the design
    private let orangeColor = Color(red: 0.89, green: 0.45, blue: 0.31) // #E37450
    private let greenColor = Color(red: 0.23, green: 0.35, blue: 0.30) // #3B584C
    
    // Size constants for the rectangles
    private let boxWidth: CGFloat = UIScreen.main.bounds.width * 0.4
    private let heightRatio: CGFloat = 1.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Pick a side")
                .font(.customFont(size: 24))
                .fontWeight(.semibold)
                .foregroundColor(greenColor)
                .padding(.horizontal)
            
            // Horizontal row of rectangular boxes
            HStack(spacing: 16) {
                ForEach(Array(options.enumerated()), id: \.element) { index, option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        Text(option)
                            .font(.customFont(size: 30))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(width: boxWidth)
                            .frame(height: boxWidth * heightRatio) // Makes boxes taller
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(index == 0 ? orangeColor : greenColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(selectedOption == option ? Color.blue : Color.clear, lineWidth: 4)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

// Custom button style for scaling effect on press
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Preview
struct VotingOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with 2 options
            VotingOptionsView(
                options: ["Yes", "No"],
                selectedOption: .constant(nil)
            )
            
            // Preview with more options
            ScrollView(.horizontal, showsIndicators: false) {
                VotingOptionsView(
                    options: ["Option 1", "Option 2", "Option 3", "Option 4"],
                    selectedOption: .constant("Option 1")
                )
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
