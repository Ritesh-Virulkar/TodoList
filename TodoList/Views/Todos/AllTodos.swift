//
//  AllTodos.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AllTodos: View {
    @Environment(TodoViewModel.self) var todoVM
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todoVM.todos, id: \.id) { todo in
                    HStack {
                        Text(todo.title)
                        Spacer()
                        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                todoVM.toggleStatus(todo.id)
                            }
                            .symbolEffect(.bounce, value: todo.isCompleted)
                            
                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            todoVM.remove(todo.id)
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
                    AddTodo() 
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    AllTodos()
        .environment(TodoViewModel())
}
