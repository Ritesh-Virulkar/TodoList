//
//  Todo.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 29/10/25.
//

import FirebaseFirestore
import Foundation

struct Todo: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var title: String
    var dueDate: Date
    var isCompleted = false
}
