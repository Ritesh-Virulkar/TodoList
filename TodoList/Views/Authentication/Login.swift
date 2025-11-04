//
//  Login.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 03/11/25.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct Login: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(\.dismiss) var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("Email", systemImage: "envelope")
                    TextField("", text: $email)
                        .padding()
                        .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 9))
                        .onAppear {
                            isFocused = true
                        }
                        .focused($isFocused)
                    
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
                        authVM.signIn(withEmail: email, password: password)
                    } label: {
                        Text("Sign In")
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
                    Signup()
                } label: {
                    Text("Don't have an account? Sign up !")
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
            .navigationTitle("Login")
        }
    }
}

#Preview {
    Login()
}
