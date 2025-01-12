import SwiftUI

struct SignupView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(.sRGB, red: 0.902, green: 0.369, blue: 0.165, opacity: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Background logo container
                    Image("backgroundLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack(spacing: 20) {
                        // Logo and Title Section
                        VStack(spacing: 15) {
                            Image("pinky_promise_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                            
                            Text("Pinky Promise")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.white)
                            
                            Text("Betting with a twist...")
                                .font(.system(size: 18))
                                .foregroundColor(Color.white)
                        }
                        
                        Spacer()
                        
                        // Input fields section
                        VStack(spacing: 16) {
                            TextField("Enter Email", text: $authViewModel.email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                            
                            SecureField("Create Password", text: $authViewModel.password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            
                            if let error = authViewModel.error {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            
                            // Sign Up Button
                            Button(action: {
                                authViewModel.signUp()
                            }) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign Up")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                            .background(Color.white)
                            .foregroundColor(Color(.sRGB, red: 0.902, green: 0.369, blue: 0.165, opacity: 1.0))
                            .cornerRadius(8)
                            .disabled(authViewModel.isLoading)
                        }
                        .padding(.horizontal, 20)
                        
                        // Login Link
                        VStack(spacing: 10) {
                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(.white)
                                Button {
                                    showLogin = true
                                } label: {
                                    Text("Login")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        .padding(.top, 10)
                        .navigationDestination(isPresented: $showLogin) {
                            LoginView()
                                .navigationBarBackButtonHidden(true)
                        }
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Text("SheHacks+ 9")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}
