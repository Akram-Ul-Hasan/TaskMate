//
//  TMSettingsManager.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import Foundation

class TMSettingsManager: ObservableObject {
    
    static let shared = TMSettingsManager()
    
    @Published var theme: TMAppTheme = .system
    @Published var showCompletedTasks = true
    @Published var defaultPriority: TMTaskPriority = .medium
    @Published var enableNotifications = true
    @Published var hasCompletedOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadSettings()
    }
    
    private func loadSettings() {
        if let themeString = userDefaults.string(forKey: "theme"),
           let savedTheme = TMAppTheme(rawValue: themeString) {
            theme = savedTheme
        }
        
        showCompletedTasks = userDefaults.bool(forKey: "showCompletedTasks")
        enableNotifications = userDefaults.bool(forKey: "enableNotifications")
        hasCompletedOnboarding = userDefaults.bool(forKey: "hasCompletedOnboarding")
        
        if let priorityRaw = userDefaults.object(forKey: "defaultPriority") as? Int,
           let priority = TMTaskPriority(rawValue: priorityRaw) {
            defaultPriority = priority
        }
    }
    
    func saveSettings() {
        userDefaults.set(theme.rawValue, forKey: "theme")
        userDefaults.set(showCompletedTasks, forKey: "showCompletedTasks")
        userDefaults.set(enableNotifications, forKey: "enableNotifications")
        userDefaults.set(defaultPriority.rawValue, forKey: "defaultPriority")
        userDefaults.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveSettings()
    }
}
