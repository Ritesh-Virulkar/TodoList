//
//  ContentView.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 03/11/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(TodoViewModel.self) var todoVM
    
    var body: some View {
        if authVM.isLoggedIn {
            TabView {
                AllTodos()
                    .tabItem {
                        Label("Todos", systemImage: "list.bullet")
                    }
                    .onAppear {
                        todoVM.fetchTodosOnline()
                    }

                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    
            }
        } else {
            Login()
        }
    }
}

#Preview {
    ContentView()
}
