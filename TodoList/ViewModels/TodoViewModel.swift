//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 28/10/25.
//

import Foundation
import UserNotifications

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
        requestNotificationAuthorization()
        scheduleDailyNotif()
        if let data = UserDefaults.standard.data(forKey: "todoListApp-todos"), let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
            todos = decoded
            return
        }
        todos = []
    }
    
    func add(_ todo: Todo) {
        todos.append(todo)
        scheduleNotif(for: todo)
    }
    
    func remove(_ id: UUID) {
        if let index = todos.firstIndex (where: { $0.id == id }) {
            todos.remove(at: index)
            cancelNotification(for: id)
        }
    }
    
    func remove(at offsets: IndexSet) {
        for offSet in offsets {
            remove(todos[offSet].id)
        }
    }
    
    func update(with todo: Todo) {
        if let index = todos.firstIndex (where: { $0.id == todo.id }) {
            todos[index] = todo
        }
        scheduleNotif(for: todo)
    }
    
    func toggleStatus(_ id: UUID) {
        if let index = todos.firstIndex (where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    // notifications
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Access Granted")
            } else {
                print("Access Denied")
            }
        }
    }
    
    // daily check notification
    func scheduleDailyNotif() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Don't forget to check the list"
        content.sound = .default
        
        var date = DateComponents()
        date.hour = 15

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // 1 hour before the due date
    func scheduleNotif(for todo: Todo) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to complete: \(todo.title)"
        content.sound = .default
        
        let fireDate = todo.dueDate.addingTimeInterval(-3600) // 1 hour before
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(fireDate.timeIntervalSinceNow, 1),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: todo.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // cancel notification
    func cancelNotification(for todoID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todoID.uuidString])
    }
}
