//
//  TaskModelController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData
import UIKit

enum TaskStatus: Int {
    case completed
    case incompleted
    
    func description() -> String {
        switch self {
            case .completed:
               return "Completed"
            case .incompleted:
               return "Incompleted"
        }
    }
}

class TaskModelController {
    
    static var shared = TaskModelController()
    var taskStatus = [TaskStatus.completed, TaskStatus.incompleted]
    lazy var tasks: [[Task]] = {
        var completedTasks: [Task] = []
        var incompletedTasks: [Task] = []
        return [completedTasks,incompletedTasks]
    }()
    
    private init(){}
    
    func create(title: String, notes: String?, dueDate: Date, sendNotification: Bool, taskList: TaskList) {
        let newTask = Task(title: title, dueDate: dueDate, list: taskList, notes: notes, sendNotification: sendNotification)
        tasks[TaskStatus.incompleted.rawValue].append(newTask)
        CoreDataStack.saveContext()
        
        guard sendNotification else {
            return
        }
        NotificationScheduler.shared.scheduleNotifications(for: newTask)
    }
    
    func update(task: Task, with title: String, notes: String?, dueDate: Date, completionDate: Date?) {
        task.title = title
        task.notes = notes
        task.dueDate = dueDate
        task.completionDate = completionDate
        CoreDataStack.saveContext()
        NotificationScheduler.shared.cancelNotifications(for: task)        
        guard task.sendNotification else {
            return
        }
        NotificationScheduler.shared.scheduleNotifications(for: task)
    }
    
    func fetch(taskList: TaskList) {
        self.tasks[TaskStatus.incompleted.rawValue].removeAll()
        self.tasks[TaskStatus.completed.rawValue].removeAll()
        taskList.tasks?.forEach({ task in
            guard let task = task as? Task else {
                return
            }
            
            if task.isCompleted() {
                self.tasks[TaskStatus.completed.rawValue].append(task)
            } else {
                self.tasks[TaskStatus.incompleted.rawValue].append(task)
            }
        })
    }
    
    func hideCompletedTasks() {
        taskStatus.remove(at: 0)
        self.tasks[TaskStatus.completed.rawValue].removeAll()
        self.tasks[TaskStatus.completed.rawValue].append(contentsOf: self.tasks[TaskStatus.incompleted.rawValue])
        self.tasks[TaskStatus.incompleted.rawValue].removeAll()
    }
    
    func showCompletedTasks(for taskList: TaskList) {
        taskStatus.insert(.completed, at: 0)
        fetch(taskList: taskList)
    }
    
    func complete(with taskList: TaskList, taskID: String) {
        fetch(taskList: taskList)
        guard let task = self.tasks[TaskStatus.incompleted.rawValue].first(where: { $0.id == UUID(uuidString: taskID)}) else {
            return
        }
        complete(true, task: task)
    }
    
    func complete(_ isCompleted: Bool, task: Task) {
        task.completionDate = isCompleted ? Date() : nil
        if task.isCompleted() {
            remove(from: .incompleted, task: task)
            self.tasks[TaskStatus.completed.rawValue].append(task)
            disableNotificationAlert(task)
        } else {
            remove(from: .completed, task: task)
            self.tasks[TaskStatus.incompleted.rawValue].append(task)
        }
        CoreDataStack.saveContext()        
    }
    
    func toggleNotificationAlert(_ isActive: Bool, task: Task) {
        task.sendNotification = isActive
        CoreDataStack.saveContext()
        NotificationScheduler.shared.cancelNotifications(for: task)
        guard isActive else {
            return
        }
        NotificationScheduler.shared.scheduleNotifications(for: task)
    }
    
    func delete(task: Task) {
        
    }
    
    private func disableNotificationAlert(_ task: Task) {
        task.sendNotification = false
    }
    
    private func remove(from status:TaskStatus, task: Task) {
        let index = status.rawValue
        guard let firstIndex = self.tasks[index].firstIndex(of: task) else {
            return
        }
        
        self.tasks[index].remove(at: firstIndex)
    }
}
