//
//  TMSortOption.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

enum TMSortOption: String, CaseIterable {
    case manual = "Manual"
    case dateCreated = "Date Created"
    case dateModified = "Date Modified"
    case priority = "Priority"
    case dueDate = "Due Date"
    case alphabetical = "Alphabetical"
    
    var icon: String {
        switch self {
        case .manual: return "hand.draw"
        case .dateCreated: return "calendar.badge.plus"
        case .dateModified: return "calendar.badge.clock"
        case .priority: return "exclamationmark.triangle"
        case .dueDate: return "clock"
        case .alphabetical: return "textformat.abc"
        }
    }
}
