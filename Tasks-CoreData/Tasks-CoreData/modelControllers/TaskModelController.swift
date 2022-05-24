//
//  TaskModelController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation

enum TaskStatus {
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
        tasks[1].append(newTask)
        CoreDataStack.saveContext()
    }
    
    func update(task: Task, with title: String, notes: String?, dueDate: Date, completionDate: Date?) {
        task.title = title
        task.notes = notes
        task.dueDate = dueDate
        task.completionDate = completionDate
        CoreDataStack.saveContext()
    }
    
    func fetch(taskList: TaskList) {      
        taskList.tasks?.forEach({ task in
            guard let task = task as? Task else {
                return
            }
            
            if task.isCompleted() {
                self.tasks[0].append(task)
            } else {
                self.tasks[1].append(task)
            }
        })
    }
    
    func delete(task: Task) {
        
    }
    
    
}
