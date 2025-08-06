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
    
}
