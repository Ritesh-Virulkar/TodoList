//
//  Todo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 29/10/25.
//

import Foundation

struct Todo: Codable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var dueDate: Date
    var isCompleted = false
    
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        lhs.id == rhs.id
    }
}
