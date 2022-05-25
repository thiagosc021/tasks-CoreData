//
//  AppDelegate.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { authorized, error in
            if let error = error {
                print("🔴 error requesting notification authorization: \(error)")
            }
            
            if authorized {
                UNUserNotificationCenter.current().delegate = self
                self.setNotificationCategories()
                    print("✅ authorization granted")
            } else {
                    print("🔴 autorization denied")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: StringConstants.Notifications.taskReminderReceived), object: self)
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard response.actionIdentifier == StringConstants.Notifications.markCompletedActionIdentifier,
                let taskId = response.notification.request.content.userInfo[StringConstants.Task.EntityIDKeyName] as? String,
                let taskListId = response.notification.request.content.userInfo[StringConstants.TaskList.EntityIDKeyName] as? String ,
                let taskList = TaskListModelController.shared.fetch(by: taskListId) else {
            completionHandler()
            return
        }
        
        TaskModelController.shared.complete(with: taskList, taskID: taskId)
        completionHandler()
    }
    func setNotificationCategories() {
        let markCompletedAction = UNNotificationAction(identifier: StringConstants.Notifications.markCompletedActionIdentifier, title: "I've done it!", options: [.authenticationRequired])
        let ignoreAction = UNNotificationAction(identifier: StringConstants.Notifications.ignoreActionIdentifier, title: "I'll do it later", options: [.authenticationRequired])
        let category = UNNotificationCategory(identifier: StringConstants.Notifications.categoryIdentifier,
                                              actions: [markCompletedAction, ignoreAction],
                                              intentIdentifiers: [],
                                              hiddenPreviewsBodyPlaceholder: "",
                                              options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
