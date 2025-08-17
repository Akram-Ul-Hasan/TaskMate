//
//  TMProfileViewModel.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/17/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

class TMProfileViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var profileImage: URL? = nil
    
    @Published var selectedTheme: TMAppTheme = .system
    @Published var notificationTiming: Int = 10
    @Published var notificationSound: String = "Default"
    
    // MARK: - Managers
    private let authManager: TMAuthManager
    private let notificationManager: TMNotificationManager
    private let settingsManager: TMSettingsManager
    
    // MARK: - Init
    init(authManager: TMAuthManager,
         notificationManager: TMNotificationManager,
         settingsManager: TMSettingsManager) {
        self.authManager = authManager
        self.notificationManager = notificationManager
        self.settingsManager = settingsManager
        loadData()
    }
    
    // MARK: - Data Loading
    func loadData() {
        let user = authManager.currentUser
        self.name = user?.displayName ?? "User"
        self.email = user?.email ?? ""
        self.profileImage = user?.photoURL
        
        self.selectedTheme = settingsManager.theme
//        self.notificationTiming = notificationManager.reminderMinutesBefore
//        self.notificationSound = notificationManager.notificationSound
    }
    
    // MARK: - Actions
    func updateProfilePhoto() {
//        userManager.updateProfilePhoto()
    }
    
    func changeTheme(_ theme: TMAppTheme) {
//        settingsManager.updateTheme(theme)
        selectedTheme = theme
    }
    
    func updateNotificationTiming(_ minutes: Int) {
//        notificationManager.updateReminderTime(minutes)
        notificationTiming = minutes
    }
    
    func updateNotificationSound(_ sound: String) {
//        notificationManager.updateSound(sound)
        notificationSound = sound
    }
    
    func logout() {
        authManager.signOut()
    }
}
    

