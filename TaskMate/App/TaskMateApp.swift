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
    
    @StateObject private var databaseManager = TMDatabaseManager.shared
    @StateObject private var appState = TMAppState()
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootNavigationView()
                .environment(\.managedObjectContext, databaseManager.context)
                .environmentObject(databaseManager)
                .environmentObject(coordinator)
                .environmentObject(appState)
                .environmentObject(TMNetworkMonitor.shared)
        }
    }
}
