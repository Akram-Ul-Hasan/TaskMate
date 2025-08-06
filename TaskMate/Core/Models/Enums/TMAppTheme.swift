//
//  TMAppTheme.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 8/6/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
