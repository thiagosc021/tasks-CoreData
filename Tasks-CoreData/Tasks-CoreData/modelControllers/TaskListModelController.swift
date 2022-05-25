//
//  TaskListModelController.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData

class TaskListModelController {
    
    static let shared = TaskListModelController()
    
    private init() {}
    private lazy var fetchRequest: NSFetchRequest<TaskList> = {
        let request = NSFetchRequest<TaskList>(entityName: StringConstants.TaskList.EntityName)
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var taskLists: [TaskList] = []
    
    
    func create(name: String, color: String?, icon: String?) {
        TaskList(name: name, color: color, icon: icon)
        CoreDataStack.saveContext()
    }
        
    func fetch() {        
        do {
            let listOfTasks = try CoreDataStack.context.fetch(fetchRequest)
            taskLists = listOfTasks
        } catch {
            print("Error fetching TaskList: \(error)")
        }
    }
    
    func fetch(by id: String) -> TaskList? {
        fetch()
        return taskLists.first(where: { $0.id == UUID(uuidString: id)})
    }
    
    func update(taskList: TaskList, with name: String, color: String?, icon: String?) {
        taskList.name = name
        taskList.icon = icon
        taskList.color = color
        CoreDataStack.saveContext()
        fetch()
    }
    
    func delete(taskList: TaskList) {
        guard let index = taskLists.firstIndex(of: taskList) else {
            return
        }
        taskLists.remove(at: index)
        CoreDataStack.context.delete(taskList)
        CoreDataStack.saveContext()
    }
    
}
