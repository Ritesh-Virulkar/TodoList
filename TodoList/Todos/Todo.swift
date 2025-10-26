//
//  Todo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 26/10/25.
//

import Foundation

struct Todo: Identifiable {
    var id: UUID
    var title: String
    var dueDate: Date
}
