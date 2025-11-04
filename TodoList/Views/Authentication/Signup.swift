//
//  Signup.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 02/11/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Signup: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isFocused: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userName: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("Username", systemImage: "person.circle")
                    TextField("", text: $userName)
                        .padding()
                        .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 9))
                        .onAppear {
                            isFocused = true
                        }
                        .focused($isFocused)
                    
                    Label("Email", systemImage: "envelope")
                    TextField("", text: $email)
                        .padding()
                        .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 9))
                    
                    Label("Password", systemImage: "key")
                    SecureField("", text: $password)
                        .padding()
                        .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 9))
                }
                .padding(.horizontal)
                
                if authVM.isLoading {
                    ProgressView("Loading...")
                } else {
                    Button {
                        authVM.signUp(for: userName, with: email, password: password)
                    } label: {
                        Text("Create")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.9), in: RoundedRectangle(cornerRadius: 9))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .padding()
                    }
                    .buttonStyle(.plain)
                }
                
                if authVM.showingError {
                    Text(authVM.errorMessage)
                        .padding()
                        .foregroundStyle(Color.red)
                }
                
                ZStack {
                    Text("OR")
                        .fontWeight(.black)
                    Divider()
                }
                .foregroundStyle(Color.secondary.opacity(0.7))
                
                NavigationLink {
                    Login()
                } label: {
                    Text("Already have an account? Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.9), in: RoundedRectangle(cornerRadius: 9))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding()
                }
                .buttonStyle(.plain)
                
            }
            .padding(.top)
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Signup")
        }
        
    }
}

#Preview {
    Signup()
}
