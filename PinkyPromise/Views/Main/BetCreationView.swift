import SwiftUI
import PhotosUI


struct BetCreationView: View {
    @State private var betPrompt: String = ""
    @State private var betAmount: String = ""
    @State private var options: [String] = [""]
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var displayImage: Image? = nil
    @State private var showCalendar = false
    @State private var isSelectingEndDate = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Header and other sections remain the same
                    Text("Create the Bet")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
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
                                    .font(.system(size: 30))
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
                                .font(.title3)
                                .fontWeight(.medium)
                            TextField("Enter bet prompt", text: $betPrompt)
                                .textFieldStyle(UnderlinedTextFieldStyle())
                        }
                        
                        // Bet Amount Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Bet Amount/Thing")
                                .font(.title3)
                                .fontWeight(.medium)
                            TextField("Enter bet amount", text: $betAmount)
                                .textFieldStyle(UnderlinedTextFieldStyle())
                        }
                        
                        // Options Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Options")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                            ForEach(0..<options.count, id: \.self) { index in
                                TextField("Enter option", text: $options[index])
                                    .textFieldStyle(UnderlinedTextFieldStyle())
                            }
                            
                            Button(action: {
                                options.append("")
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.3))
                            }
                        }
                        
                        // Duration Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Duration")
                                .font(.title3)
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
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

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
