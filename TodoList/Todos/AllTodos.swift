//
//  AllTodos.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AllTodos: View {
    @State private var allTodos = [Todo]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allTodos, id: \.id) { todo in // all todos
                    NavigationLink {
                        // view todo
                        Text("\(todo.title)")
                    } label: {
                        Text("\(todo.title)")
                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            // delete
                        }
                        
                        Button("Edit", systemImage: "pencil") {
                            // edit
                        }
                    }
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                NavigationLink {
                    AddTodo() { task in
                        allTodos.append(task)
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    AllTodos()
}
