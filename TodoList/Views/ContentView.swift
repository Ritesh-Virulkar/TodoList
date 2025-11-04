//
//  ContentView.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 03/11/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) var authVM
    @State private var todoVM = TodoViewModel()
    
    var body: some View {
        if authVM.isLoggedIn {
            TabView {
                AllTodos()
                    .tabItem {
                        Label("Todos", systemImage: "list.bullet")
                    }

                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    
            }
            .environment(todoVM)
        } else {
            Login()
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthViewModel())
}
