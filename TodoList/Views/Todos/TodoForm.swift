//
//  AddTodo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

enum FormType {
    case add
    case edit(Todo)
}

struct TodoForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TodoViewModel.self) var todoVM
    
    @FocusState private var isFocused: Bool
    
    // form properties
    @State private var title: String = ""
    @State private var dueDate: Date = Calendar.current.date(
        bySettingHour: 23,
        minute: 59,
        second: 59,
        of: Date()
    )!
    
    // errors
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
//    let onSave: (Todo) -> Void
    
    // local vars
    var _formType: FormType = .add
    var navTitle = ""
    var operationType: String {
        switch _formType {
            case .add:
                return "Add"
            case .edit:
                return "Update"
        }
    }
    
    init(formType: FormType = .add) {
        _formType = formType
        switch formType {
            case .add:
            navTitle = "Add new todo"
        case .edit(let todo):
            _title = State(initialValue: todo.title)
            _dueDate = State(initialValue: todo.dueDate)
            
            navTitle = "Update todo"
        }
    }
    
    var body: some View {
        ScrollView {
            
            TextField("Enter a new task", text: $title)
                .padding()
                .background(Color.secondary.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .focused($isFocused)
                .onAppear { isFocused = true }
            
            DatePicker("Choose due date", selection: $dueDate)
                .datePickerStyle(.graphical)
                .tint(Color.pink.opacity(0.8))
                .padding()
            
            Button {
                if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showingError = true
                    errorTitle = "Empty title"
                    errorMessage = "Title cannot be empty"
                } else {
                    switch _formType {
                        case .add:
                        let newTodo = Todo(id: UUID().uuidString, title: title, dueDate: dueDate)
//                            todoVM.add(newTodo)
                            todoVM.addOnline(newTodo)
                        case .edit(let todo):
                            let todo = Todo(id: todo.id, title: title, dueDate: dueDate)
//                            todoVM.update(with: todo)
                            todoVM.updateOnline(with: todo)
                    }
                    
                    dismiss()
                }
            } label: {
                Text("\(operationType) task")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    TodoForm()
        .environment(TodoViewModel())
}
