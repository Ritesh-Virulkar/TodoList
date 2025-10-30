//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 28/10/25.
//

import Foundation

@Observable
class TodoViewModel {
    var todos = [Todo]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(todos) {
                UserDefaults.standard.set(encoded, forKey: "todoListApp-todos")
            }
        }
    }
    
    // MARK: Init
    init() {
        if let data = UserDefaults.standard.data(forKey: "todoListApp-todos"), let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
            todos = decoded
            return
        }
        todos = []
    }
    
    func add(_ todo: Todo) {
        todos.append(todo)
    }
    
    func remove(_ id: UUID) {
        if let index = todos.firstIndex (where: { $0.id == id }) {
            todos.remove(at: index)
        }
    }
    
    func update(with todo: Todo) {
        if let index = todos.firstIndex (where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }
    
    func toggleStatus(_ id: UUID) {
        if let index = todos.firstIndex (where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
        }
    }
}
