//
//  TMSortOption.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

enum TMSortOption: String, CaseIterable {
    case none = "none"
    case dateCreated = "Date Created"
    case priority = "Priority"
    case alphabetical = "Alphabetical"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .none: return "None"
        case .dateCreated: return "Date Created"
        case .priority: return "Priority"
        case .alphabetical: return "Alphabetical"
        }
    }
    
    var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .none:
            return [
                NSSortDescriptor(keyPath: \Task.position, ascending: true),
                NSSortDescriptor(keyPath: \Task.createdDate, ascending: false)
            ]
        case .dateCreated:
            return [
                NSSortDescriptor(keyPath: \Task.createdDate, ascending: false),
                NSSortDescriptor(keyPath: \Task.title, ascending: true)
            ]
        case .alphabetical:
            return [
                NSSortDescriptor(keyPath: \Task.title, ascending: true),
                NSSortDescriptor(keyPath: \Task.createdDate, ascending: false)
            ]
        case .priority:
            return [
                NSSortDescriptor(keyPath: \Task.priority, ascending: false),
                NSSortDescriptor(keyPath: \Task.dueDate, ascending: true),
                NSSortDescriptor(keyPath: \Task.createdDate, ascending: false)
            ]
        }
    }
}
