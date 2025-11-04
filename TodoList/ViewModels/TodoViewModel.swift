//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Ritesh Virulkar on 28/10/25.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import UserNotifications

@Observable
class TodoViewModel {
    private let db = Firestore.firestore()
    
    static let shared = TodoViewModel()
    
    var todos = [Todo]()
    
    // MARK: Init
    init() {
        requestNotificationAuthorization()
        scheduleDailyNotif()
        fetchTodosOnline()
    }
    
    func fetchTodosOnline() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userID)
            .collection("todos")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching todos:", error.localizedDescription)
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                DispatchQueue.main.async {
                    self.todos = documents.compactMap { document in
                        try? document.data(as: Todo.self)
                    }
                }
            }
    }
    
    func add(_ todo: Todo) {
        todos.append(todo)
        scheduleNotif(for: todo)
    }
    
    func addOnline(_ todo: Todo) {
        guard let userID = Auth.auth().currentUser?.uid, let todoID = todo.id else { return }
        
        do {
            try db.collection("users")
                .document(userID)
                .collection("todos")
                .document(todoID)
                .setData(from: todo)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeOnline(_ todo: Todo) {
        guard let userID = Auth.auth().currentUser?.uid, let todoID = todo.id else { return }
        db.collection("users")
            .document(userID)
            .collection("todos")
            .document(todoID)
            .delete()
    }
    
    func remove(_ id: String) {
        if let index = todos.firstIndex (where: { $0.id == id }) {
            todos.remove(at: index)
//            cancelNotification(for: id)
        }
    }
    
    func remove(at offsets: IndexSet) {
        for _ in offsets {
//            remove(todos[offSet].id)
        }
    }
    
    func update(with todo: Todo) {
        if let index = todos.firstIndex (where: { $0.id == todo.id }) {
            todos[index] = todo
        }
        scheduleNotif(for: todo)
    }
    
    func updateOnline(with todo: Todo) {
        guard let userID = Auth.auth().currentUser?.uid,  let todoID = todo.id else { return }
        do {
            try db.collection("users")
                .document(userID)
                .collection("todos")
                .document(todoID)
                .setData(from: todo)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func toggleStatusOnline(_ todo: Todo) {
        guard let userID = Auth.auth().currentUser?.uid, let todoID = todo.id else { return }
        db.collection("users")
            .document(userID)
            .collection("todos")
            .document(todoID)
            .updateData(["isCompleted": !todo.isCompleted])
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
        guard let todoID = todo.id else { return }
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to complete: \(todo.title)"
        content.sound = .default
        
        let fireDate = todo.dueDate.addingTimeInterval(-3600) // 1 hour before
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(fireDate.timeIntervalSinceNow, 1),
            repeats: false
        )
        
        let request = UNNotificationRequest(identifier: todoID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // cancel notification
    func cancelNotification(for todoID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todoID.uuidString])
    }
}
