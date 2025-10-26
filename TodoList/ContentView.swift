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
            Text("This is view 1")
                .tabItem {
                    Label("Tab 1", systemImage: "map.fill")
                }
            
            Text("This is view 2")
                .tabItem {
                    Label("Tab 2", systemImage: "duffle.bag.fill")
                }
            
            Text("This is view 3")
                .tabItem {
                    Label("Tab 3", systemImage: "gear.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
