//
//  AddTodo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import SwiftUI

struct AddTodo: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var dueDate: Date = .now
    
    let onSave: (Todo) -> Void
    
    var body: some View {
        ScrollView {
            
            TextField("Enter a new task", text: $title)
                .padding(.horizontal)
                .padding(.top)
            DatePicker("Choose due date", selection: $dueDate)
                .datePickerStyle(.graphical)
                .padding()
            
            Button {
                // add
                let newTask = Todo(id: UUID(), title: title, dueDate: dueDate)
                onSave(newTask)
                dismiss()
            } label: {
                Text("Add task")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddTodo() { _ in }
}
