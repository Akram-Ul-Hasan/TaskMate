//
//  TaskPriority.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 8/6/25.
//

import SwiftUI

enum TMTaskPriority: Int, CaseIterable, Codable {
    case low = 0
    case medium = 1
    case high = 2
    case urgent = 3
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
    
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "arrow.down.circle"
        case .medium: return "minus.circle"
        case .high: return "arrow.up.circle"
        case .urgent: return "exclamationmark.circle"
        }
    }
}
