//
//  TaskMateApp.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 17/6/25.
//

import SwiftUI

@main
struct TaskMateApp: App {
    
    init() {

        TMNotificationManager.shared.requestPermission()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
