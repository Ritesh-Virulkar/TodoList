//
//  User.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 03/11/25.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String
    var email: String
    var createdDate: Date
}
