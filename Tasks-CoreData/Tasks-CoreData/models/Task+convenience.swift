//
//  Task+convinience.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData

extension Task {
    @discardableResult convenience init(title: String, dueDate: Date, list: TaskList, notes: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.completionDate = completionDate
        self.taskList = list
    }
    
    func markAsCompleted() {
        self.completionDate = Date()
    }
    
    func isCompleted() -> Bool {
        return self.completionDate != nil
    }
    
    func isLate() -> Bool {
        guard let dueDate = self.dueDate else {
            return false
        }
        
        guard let completionDate = self.completionDate else {
            let result = Calendar.current.compare(Date(), to: dueDate, toGranularity: .hour)
            return result == .orderedSame
        }
        
        let result = Calendar.current.compare(completionDate, to: dueDate, toGranularity: .hour)
        
        return result == .orderedSame
    }
}
