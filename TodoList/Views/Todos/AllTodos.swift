//
//  AllTodos.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AllTodos: View {
    @Bindable var todoVM: TodoViewModel
    
    var groupedTodos: [(title: String, todos: [Todo])] {
        var pastDue = [Todo]()
        var pending = [Todo]()
        var completed = [Todo]()
        
        let now = Date()
        for todo in todoVM.todos {
            if todo.dueDate < now && todo.isCompleted == false {
                pastDue.append(todo)
            } else if todo.isCompleted {
                completed.append(todo)
            } else {
                pending.append(todo)
            }
        }
        
        var grouped = [(title: String, todos: [Todo])]()
        
        if pastDue.isEmpty == false {
            grouped.append((title: "Past Due", todos: pastDue))
        }
        if pending.isEmpty == false {
            grouped.append((title: "Pending", todos: pending))
        }
        if completed.isEmpty == false {
            grouped.append((title: "Completed", todos: completed))
        }
       
        return grouped
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedTodos, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.todos, id: \.id) { todo in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(todo.title)
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                                        .strikethrough(todo.isCompleted)
                                    
                                    Text(formattedDate(todo.dueDate))
                                        .font(.caption)
                                        .fontWeight(.light)
                                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                                        .strikethrough(todo.isCompleted)
                                }
                                
                                Spacer()
                                
                                if todo.dueDate < Date() && todo.isCompleted == false {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                }
                                
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        withAnimation {
                                            todoVM.toggleStatus(todo.id)
                                        }
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
                    
                }
                .onMove(perform: move)
                .onDelete(perform: remove)
            }
            .navigationTitle("Todo List")
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
        var flattened = groupedTodos.flatMap { $0.1 }
        flattened.move(fromOffsets: indices, toOffset: newOffset)
        todoVM.todos = flattened
    }
    
    // TODO: check why it doesnt work
    private func remove(for offsets: IndexSet) {
        todoVM.remove(at: offsets)
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
