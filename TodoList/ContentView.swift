//
//  ContentView.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AllTodos()
                .tabItem {
                    Label("Todos", systemImage: "figure.run.circle")
                }
            
            Text("Account and settings")
                .tabItem {
                    Label("Settings", systemImage: "gear.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
