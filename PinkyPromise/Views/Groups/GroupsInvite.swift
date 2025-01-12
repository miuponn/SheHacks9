import SwiftUI
import PhotosUI

struct GroupInvitationView: View {
    @State private var groupName: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var displayImage: Image? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let mainColor = Color(red: 0.2, green: 0.4, blue: 0.3)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Main content container
                    VStack(spacing: 24) {
                        Text("Send a Group Invitation")
                            .font(.customFont(size: 30))
                            .fontWeight(.semibold)
                            .foregroundColor(mainColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 30)
                        
                        // Profile Picture Button
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            ZStack {
                                Circle()
                                    .fill(mainColor)
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
                            // Group Name Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Group Name")
                                    .font(.customFont(size: 20))
                                    .fontWeight(.medium)
                                TextField("Enter group name", text: $groupName)
                                    .textFieldStyle(UnderlinedTextFieldStyle())
                            }
                            
                            // Invite Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Invite")
                                    .font(.customFont(size: 20))
                                    .fontWeight(.medium)
                                
                                VStack(spacing: 16) {
                                    // Send Invite Link Button
                                    Button(action: {
                                        // Send invite link action
                                    }) {
                                        HStack {
                                            Image(systemName: "link")
                                            Text("Send invite link")
                                                .font(.customFont(size: 18))
                                        }
                                        .foregroundColor(mainColor)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(mainColor, lineWidth: 1)
                                        )
                                    }
                                    
                                    Text("or")
                                        .font(.customFont(size: 16))
                                        .foregroundColor(.gray)
                                    
                                    // AirDrop Button
                                    Button(action: {
                                        // AirDrop action
                                    }) {
                                        HStack {
                                            Image(systemName: "airplayaudio")
                                            Text("AirDrop")
                                                .font(.customFont(size: 18))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(mainColor)
                                        )
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Submit Button
                        Button(action: handleSubmit) {
                            Text("Create Group")
                                .font(.customFont(size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(mainColor)
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    }
                }
                .padding(.horizontal, max(geometry.size.width * 0.1, 20))
                .padding(.bottom, 50)
                .frame(minHeight: geometry.size.height)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Group Creation Status"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func handleSubmit() {
        if groupName.isEmpty {
            alertMessage = "Please enter a group name"
            showAlert = true
            return
        }
        
        // If validation passes, proceed with submission
        alertMessage = "Group created successfully!"
        showAlert = true
        
        // Add your API call or data handling here
        print("Created group:", groupName)
    }
}

struct GroupInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInvitationView()
    }
}
