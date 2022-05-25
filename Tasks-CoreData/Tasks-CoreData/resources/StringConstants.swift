//
//  StringConstants.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/16/22.
//

import Foundation

class StringConstants {
    static let colorSelectorButtonImageNameNormal = "circle.fill"
    static let colorSelectorButtonImageNameSelected = "circle.circle.fill"
    static let listInfoViewControllerID = "ListInfoViewController"
    
    class Notifications {
        static let categoryIdentifier = "taskReminder"
        static let ignoreActionIdentifier = "ignoreAction"
        static let markCompletedActionIdentifier = "markCompletedAction"
        static let taskReminderReceived = "taskReminderReceived"
    }
    
    class Task {
        static let EntityIDKeyName = "TaskID"
        static let EntityName = "Task"
    }
    
    class TaskList {
        static let EntityName = "TaskList"
        static let EntityIDKeyName = "TaskListID"
    }
}
