//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Thiago Costa on 5/5/22.
//

import Foundation
import UserNotifications

class NotificationScheduler {
    
    static let shared = NotificationScheduler()
    
    private init() {}
    
    func scheduleNotifications(for task: Task) {
        guard let taskId = task.id,
        let taskListId = task.taskList?.id else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to \(task.title ?? "")"
        content.sound = .default
        content.userInfo = [StringConstants.Task.EntityIDKeyName: "\(taskId)" ,
                            StringConstants.TaskList.EntityIDKeyName: "\(taskListId)"]
        content.categoryIdentifier = StringConstants.Notifications.categoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour,.minute], from: task.dueDate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        
        
        let request = UNNotificationRequest(identifier: "\(taskId)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("something went wrong while trying to schedule the notification \(error.localizedDescription)")
            }
        }
        
    }
    
    func cancelNotifications(for task: Task) {
        guard let taskId = task.id else {
            return
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(taskId)"])
    }
    
}
