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
    @Environment(\.dismiss) var dismiss
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
                
                Button("Create Account") {
                    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print("Error creating user: \(error.localizedDescription)")
                        } else {
                            print("User created successfully!")
                            guard let user = authResult?.user else { return }
                            let db = Firestore.firestore()
                            db.collection("users").document(user.uid).setData([
                                "username": userName,
                                "email": email,
                                "createdAt": Date()
                            ]) { error in
                                if let error = error {
                                    print("Error saving user data: \(error)")
                                } else {
                                    print("User data saved successfully!")
                                }
                                
                                dismiss()
                            }
                        }
                    }
                }
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
