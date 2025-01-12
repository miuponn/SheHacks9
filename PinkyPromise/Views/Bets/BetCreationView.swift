import SwiftUI
import PhotosUI

<<<<<<< HEAD
extension Font {
    static func customFont(size: CGFloat) -> Font {
        return Font.custom("NewYorkMedium-Regular", size: size)
    }
}

=======
>>>>>>> ec40fdc (Temp changes)
struct BetCreationView: View {
    @StateObject private var viewModel = BetViewModel()
    
    // Keep original @State properties for view-specific state
    @State private var betPrompt: String = ""
    @State private var betAmount: String = ""
    @State private var options: [String] = [""]
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var displayImage: Image? = nil
    @State private var showCalendar = false
    @State private var isSelectingEndDate = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Main content container
                    VStack(spacing: 24) {
                    Text("Create the Bet")
                        .font(.customFont(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                    
                    // Profile Picture Button
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.2, green: 0.4, blue: 0.3))
                                .frame(width: 80, height: 80)
                            
                            if let displayImage = displayImage {
                                displayImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .onChange(of: selectedImage) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                displayImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                    
                    // Form Content
                    VStack(spacing: 32) {
                        // Bet Prompt Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Bet Prompt")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                            TextField("Enter bet prompt", text: $betPrompt)
                                .textFieldStyle(UnderlinedTextFieldStyle())
                                .onChange(of: betPrompt) { newValue in
                                    viewModel.betPrompt = newValue
                                }
                        }
                        
                        // Bet Amount Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Bet Amount/Thing")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                            TextField("Enter bet amount", text: $betAmount)
                                .textFieldStyle(UnderlinedTextFieldStyle())
                                .onChange(of: betAmount) { newValue in
                                    viewModel.betAmount = newValue
                                }
                        }
                        
                        // Options Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .center) {
                                Text("Options")
                                    .font(.customFont(size: 20))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Button(action: {
                                    options.append("")
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                                }
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                            }
                            .padding(.trailing, -8) // Align with other content
                            
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(0..<options.count, id: \.self) { index in
                                        TextField("Enter option", text: $options[index])
                                            .textFieldStyle(UnderlinedTextFieldStyle())
                                    }
                                }
                            }
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.3) // Limit height to 30% of screen height
                        }
                        
                        // Duration Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Duration")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                            
                            Button(action: {
                                showCalendar = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        if let start = startDate {
                                            Text("Start: \(formatDate(start))")
                                                .foregroundColor(.primary)
                                        } else {
                                            Text("Select dates")
                                                .foregroundColor(.gray)
                                        }
                                        
                                        if let end = endDate {
                                            Text("End: \(formatDate(end))")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                                }
                                .padding(.vertical, 8)
                            }
                            .textFieldStyle(UnderlinedTextFieldStyle())
                        }
                        
                        // Create Button
                        Button(action: {
                            // Update viewModel with current values
                            viewModel.options = options
                            viewModel.startDate = startDate
                            viewModel.endDate = endDate
                            viewModel.createNewBet()
                        }) {
                            Text("Create Bet")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.2, green: 0.4, blue: 0.3))
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.top, 20)
                    }
                }
                .padding(.horizontal, max(geometry.size.width * 0.1, 20))
                .padding(.bottom, 50)
                .frame(minHeight: geometry.size.height)
            }
            .sheet(isPresented: $showCalendar) {
                NavigationView {
                    CustomDatePicker(startDate: $startDate,
                                   endDate: $endDate,
                                   isSelectingEndDate: $isSelectingEndDate,
                                   showCalendar: $showCalendar)
                    .navigationTitle("Select Dates")
                    .navigationBarItems(
                        trailing: Button("Done") {
                            showCalendar = false
                        }
                    )
                }
            }
<<<<<<< HEAD
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Form Status"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
=======
            .onChange(of: startDate) { newValue in
                viewModel.startDate = newValue
            }
            .onChange(of: endDate) { newValue in
                viewModel.endDate = newValue
            }
            .errorAlert(error: $viewModel.error)
>>>>>>> ec40fdc (Temp changes)
        }
    }
    
    private func handleSubmit() {
        // Validate form
        if betPrompt.isEmpty {
            alertMessage = "Please enter a bet prompt"
            showAlert = true
            return
        }
        
        if betAmount.isEmpty {
            alertMessage = "Please enter a bet amount"
            showAlert = true
            return
        }
        
        if options.filter({ !$0.isEmpty }).count < 2 {
            alertMessage = "Please enter at least two options"
            showAlert = true
            return
        }
        
        if startDate == nil || endDate == nil {
            alertMessage = "Please select both start and end dates"
            showAlert = true
            return
        }
        
        // If all validations pass, proceed with submission
        // Here you would typically call your API or handle the data
        let betData: [String: Any] = [
            "prompt": betPrompt,
            "amount": betAmount,
            "options": options.filter { !$0.isEmpty },
            "startDate": startDate as Any,
            "endDate": endDate as Any,
            // Add image data if needed
        ]
        
        // For demonstration, show success message
        alertMessage = "Bet created successfully!"
        showAlert = true
        
        // You can add your API call or data handling here
        print("Submitted bet data:", betData)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Keep original CustomDatePicker and UnderlinedTextFieldStyle
struct CustomDatePicker: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Binding var isSelectingEndDate: Bool
    @Binding var showCalendar: Bool
    
    var body: some View {
        VStack {
            Text(isSelectingEndDate ? "Select End Date" : "Select Start Date")
                .font(.headline)
                .padding()
            
            DatePicker(
                "",
                selection: Binding(
                    get: { startDate ?? Date() },
                    set: { date in
                        if !isSelectingEndDate {
                            startDate = date
                            if endDate == nil || endDate! < date {
                                endDate = date
                            }
                            isSelectingEndDate = true
                        } else {
                            if date >= startDate! {
                                endDate = date
                                showCalendar = false
                                isSelectingEndDate = false
                            }
                        }
                    }
                ),
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            if isSelectingEndDate {
                Button("Same Day") {
                    endDate = startDate
                    showCalendar = false
                    isSelectingEndDate = false
                }
                .padding()
            }
        }
    }
}

struct UnderlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
}

struct BetCreationView_Previews: PreviewProvider {
    static var previews: some View {
        BetCreationView()
    }
}
