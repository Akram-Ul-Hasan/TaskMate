//
//  TMNotificationManager.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import Foundation
import UserNotifications
import UIKit

final class TMNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = TMNotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func scheduleNotification(for task: Task) {
        guard let dueDate = task.dueDate, dueDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Due"
        content.body = task.title ?? ""
        content.sound = .default

        let reminderDate = Calendar.current.date(byAdding: .minute, value: -15, to: dueDate) ?? dueDate
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: task.id ?? "", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification(for taskId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
    }

    
}
