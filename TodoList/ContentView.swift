//
//  ContentView.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var todoVM = TodoViewModel()
    
    var body: some View {
        TabView {
            AllTodos(todoVM: todoVM)
                .tabItem {
                    Label("Todos", systemImage: "figure.run.circle")
                }
            
            Text("Account and settings")
                .tabItem {
                    Label("Settings", systemImage: "gear.circle")
                }
        }
        .environment(todoVM)
    }
}

#Preview {
    ContentView()
}
