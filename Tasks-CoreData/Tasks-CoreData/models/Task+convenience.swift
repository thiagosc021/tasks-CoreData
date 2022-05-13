//
//  Task+convinience.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData

extension Task {
    convenience init(title: String, notes: String?, list: TaskList, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.taskList = list
    }
}
