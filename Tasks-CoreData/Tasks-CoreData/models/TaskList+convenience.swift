//
//  TaskList.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData

extension TaskList {
    @discardableResult convenience init(name: String, color: String?, icon: String?, context: NSManagedObjectContext = CoreDataStack.context ) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.color = color
        self.icon = icon
    }
}
