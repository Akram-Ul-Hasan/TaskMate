//
//  TaskMateApp.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 17/6/25.
//

import SwiftUI
import FirebaseCore

@main
struct TaskMateApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var coordinator = TMNavigationCoordinator()
    @StateObject private var authManager = TMAuthManager.shared
    @StateObject private var taskManager = TMTaskManager()
    @StateObject private var syncManager = TMSyncManager()
    @StateObject private var notificationManger = TMNotificationManager.shared
    @StateObject private var settingsManager = TMSettingsManager.shared
    
    var body: some Scene {
        WindowGroup {
            TMRootNavigationView()
                .environmentObject(coordinator)
                .environmentObject(authManager)
                .environmentObject(taskManager)
                .environmentObject(syncManager)
                .environmentObject(settingsManager)
                .environmentObject(notificationManger)
                .environment(\.managedObjectContext, TMDatabaseManager.shared.context)
                .preferredColorScheme(settingsManager.theme.colorScheme)
                .onReceive(authManager.$isAuthenticated) { isAuthenticated in
                    print("App received auth state change: \(isAuthenticated)")
                }
            
        }
    }
}
