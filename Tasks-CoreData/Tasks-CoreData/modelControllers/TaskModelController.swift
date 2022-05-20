//
//  TaskModelController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation

class TaskModelController {
    
    var completedTasks: [Task]?
    var incompletedTasks: [Task]?
    
    
    func create(title: String, notes: String?, dueDate: Date, taskList: TaskList) {
        let newTask = Task(title: title, dueDate: dueDate, list: taskList, notes: notes)
        incompletedTasks?.append(newTask)
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
        self.completedTasks = []
        self.completedTasks = []
        taskList.tasks?.forEach({ task in
            guard let task = task as? Task else {
                return
            }
            
            if task.isCompleted() {
                self.completedTasks?.append(task)
            } else {
                self.incompletedTasks?.append(task)
            }
        })
    }
    
    func delete(task: Task) {
        
    }
    
    
}
