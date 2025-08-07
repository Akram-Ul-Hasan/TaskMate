//
//  TMFilterOption.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

enum TMFilterOption: String, CaseIterable {
    case all = "All Tasks"
    case today = "Today"
    case upcoming = "Upcoming"
    case overdue = "Overdue"
    case completed = "Completed"
    case highPriority = "High Priority"
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .today: return "sun.max"
        case .upcoming: return "calendar"
        case .overdue: return "clock.badge.exclamationmark"
        case .completed: return "checkmark.circle"
        case .highPriority: return "exclamationmark.circle"
        }
    }
}
