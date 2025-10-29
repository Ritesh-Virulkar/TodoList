//
//  Todo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 29/10/25.
//

import Foundation

struct Todo: Identifiable, Equatable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date
    
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        lhs.id == rhs.id
    }
}
