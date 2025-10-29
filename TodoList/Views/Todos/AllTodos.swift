//
//  AllTodos.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AllTodos: View {
    @Bindable var todoVM: TodoViewModel
    
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
                            .symbolEffect(.wiggle, value: todo.isCompleted)
                            
                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            todoVM.remove(todo.id)
                        }
                        
                        NavigationLink {
                            TodoForm(formType: .edit(todo))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                NavigationLink {
                    TodoForm(formType: .add)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    AllTodos(todoVM: TodoViewModel())
}
