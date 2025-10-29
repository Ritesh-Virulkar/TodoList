//
//  AddTodo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AddTodo: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TodoViewModel.self) var todoVM
    
    @State private var title: String = ""
    @State private var dueDate: Date = .now
    
    // errors
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
//    let onSave: (Todo) -> Void
    
    var body: some View {
        ScrollView {
            
            TextField("Enter a new task", text: $title)
                .padding(.horizontal)
                .padding(.top)
            DatePicker("Choose due date", selection: $dueDate)
                .datePickerStyle(.graphical)
                .padding()
            
            Button {
                if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showingError = true
                    errorTitle = "Empty title"
                    errorMessage = "Title cannot be empty"
                } else {
                    let newTodo = Todo(id: UUID(), title: title, isCompleted: false, dueDate: dueDate)
                    todoVM.add(newTodo)
                    dismiss()
                }
            } label: {
                Text("Add task")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationTitle("New Item")
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
    AddTodo()
        .environment(TodoViewModel())
}
