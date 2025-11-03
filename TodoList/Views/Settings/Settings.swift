//
//  Settings.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 03/11/25.
//

import FirebaseAuth
import SwiftUI

struct Settings: View {
    @Environment(AuthViewModel.self) var authVM
    var body: some View {
        NavigationStack {
            List {
                Button("Sign Out") {
                    authVM.signOut()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
