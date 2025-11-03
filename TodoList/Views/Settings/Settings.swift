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
            ScrollView {
                Image(systemName: "person.circle")
                    .font(.system(size: 300))
                    .fontWeight(.thin)
                    .foregroundStyle(Color.secondary)
                
                Text(authVM.loggedInUser?.name ?? "N/A")
                    .font(.largeTitle)
                Text("Mail: \(authVM.loggedInUser?.email ?? "N/A")")
                    .font(.headline)
                    .foregroundStyle(Color.secondary.opacity(0.7))
                Text("Created At: \(authVM.loggedInUser?.createdDate.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .font(.headline)
                    .foregroundStyle(Color.secondary.opacity(0.7))
                
                Button("Sign Out", role: .destructive) {
                    authVM.signOut()
                }
                .padding()
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Settings()
        .environment(AuthViewModel())
}
