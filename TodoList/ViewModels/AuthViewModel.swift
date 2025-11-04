//
//  AuthViewModel.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 03/11/25.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

@Observable
class AuthViewModel {
    var isLoggedIn = false
    var isLoading = false
    var showingError = false
    var errorMessage = ""
    var loggedInUser: User?
    
    private let db = Firestore.firestore()
    
    init () {
        isLoggedIn = Auth.auth().currentUser != nil
        setLoggedInUser()
    }
    
    func setLoggedInUser() {
        guard let currentUserID =  Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(currentUserID).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                let data = document.data()
                let id = currentUserID
                let name = (data?["username"] as? String) ?? "NA"
                let email = (data?["email"] as? String) ?? "NA"
                let createdDate = (data?["createdAt"] as? Date) ?? Date()
                self.loggedInUser = User(id: id, name: name, email: email, createdDate: createdDate)
            }
        }
    }
    
    func signUp(for username: String, with email: String, password: String) {
        isLoading = true
        showingError = false
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.showingError = true
                self.errorMessage = error.localizedDescription
            } else {
                guard let user = authResult?.user else { return }
                let creationDate = Date()
                
                self.isLoggedIn = true
                self.loggedInUser = User(id: user.uid, name: username, email: email, createdDate: creationDate)
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "username": username,
                    "email": email,
                    "createdAt": creationDate
                ]) { error in
                    if let error = error {
                        print("Error saving user data: \(error)")
                    } else {
                        print("User data saved successfully!")
                    }
                }
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) {
        isLoading = true
        showingError = false
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.showingError = true
                self.errorMessage = error?.localizedDescription ?? "Unknown Error"
            } else {
                guard let user = authResult?.user else { return }
                self.isLoggedIn = true
                
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).getDocument() { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let name = (data?["username"] as? String) ?? "NA"
                        let date = (data?["createdAt"] as? Date) ?? Date()
                        self.loggedInUser = User(id: user.uid, name: name, email: email, createdDate: date)
                    }
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
}
