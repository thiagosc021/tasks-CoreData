//
//  TaskList.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData

extension TaskList {
    convenience init(name: String, color: String?, icon: String?, context: NSManagedObjectContext = CoreDataStack.context ) {
        self.init(context: context)
        self.name = name
        self.color = color
        self.icon = icon
    }
}
