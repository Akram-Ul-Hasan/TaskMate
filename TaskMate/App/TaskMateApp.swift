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
    
//    @StateObject private var appState = TMAppState()
    @StateObject private var coordinator = NavigationCoordinator()
    @StateObject private var authManager = TMAuthManager.shared
    @StateObject private var taskManager = TMTaskManager()
    @StateObject private var syncManager = TMSyncManager()
    @StateObject private var settingsManager = TMSettingsManager.shared
    
    var body: some Scene {
        WindowGroup {
            RootNavigationView()
                .environmentObject(coordinator)
                .environmentObject(authManager)
                .environmentObject(taskManager)
                .environmentObject(syncManager)
                .environmentObject(settingsManager)
                .environment(\.managedObjectContext, TMDatabaseManager.shared.context)
                .preferredColorScheme(settingsManager.theme.colorScheme)
            
        }
    }
}
