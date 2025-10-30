//
//  AllTodos.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AllTodos: View {
    @Bindable var todoVM: TodoViewModel
    
    #if DEBUG
    let sampleData: [Todo] = [
        Todo(id: UUID(), title: "task1 with more detail to see the content width ", dueDate: .now, isCompleted: false),
        Todo(id: UUID(), title: "task2", dueDate: .now, isCompleted: true),
        Todo(id: UUID(), title: "task3", dueDate: .distantFuture, isCompleted: false),
        Todo(id: UUID(), title: "task4", dueDate: .distantPast, isCompleted: true)
    ]
    #endif
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todoVM.todos, id: \.id) { todo in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(todo.title)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                                .strikethrough(todo.isCompleted)
                                .animation(.linear, value: todo.isCompleted)
                            
                            Text(formattedDate(todo.dueDate))
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                                .strikethrough(todo.isCompleted)
                                .animation(.linear, value: todo.isCompleted)
                        }
                        
                        Spacer()
                        
                        if todo.dueDate < Date() && todo.isCompleted == false {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                        }
                        
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
                .onMove(perform: move)
                .onDelete(perform: remove)
            }
            .navigationTitle("Trackify")
            .toolbar {
                EditButton() // for re-arranging list
                
                NavigationLink {
                    TodoForm(formType: .add)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    
    // MARK: leveraging Swift UI methods and private functions
    private func move(indices: IndexSet, to newOffset: Int) {
        todoVM.todos.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    private func remove(for offsets: IndexSet) {
        todoVM.todos.remove(atOffsets: offsets)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    AllTodos(todoVM: TodoViewModel())
}
