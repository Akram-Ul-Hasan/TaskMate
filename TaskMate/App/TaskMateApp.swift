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

    var body: some Scene {
        WindowGroup {
            TMWelcomeScreen()
        }
    }
}
