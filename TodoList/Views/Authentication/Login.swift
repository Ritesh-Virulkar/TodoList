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
    @Environment(\.dismiss) var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("Email", systemImage: "envelope")
                    TextField("", text: $email)
                        .padding()
                        .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 9))
                    
                    Label("Password", systemImage: "key")
                    TextField("", text: $password)
                        .padding()
                        .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 9))
                }
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    Button("Login")  {
                        signIn()
                    }
                }
                
                if showingError {
                    Text(errorMessage)
                        .padding()
                        .foregroundStyle(Color.red)
                }
            }
            .padding(.top)
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Login")
        }
    }
    
    private func signIn() {
        isLoading = true
        showingError = false
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            isLoading = false
            if error != nil {
                showingError = true
                errorMessage = error?.localizedDescription ?? "Unknown Error"
                print("Couldnt login")
            } else {
                guard let user = authResult?.user else { return }
                print(user.email ?? "no email")
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).getDocument() { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let name = data?["username"] ?? "No Name"
                        
                        print("Welcome \(name)!!")
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    Login()
}
