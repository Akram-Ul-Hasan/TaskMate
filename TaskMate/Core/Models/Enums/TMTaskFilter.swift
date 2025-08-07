//
//  TMTaskFilter.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 8/6/25.
//

import Foundation

enum TMTaskFilter: CaseIterable {
    case all, today, upcoming, completed, overdue
    
    var title: String {
        switch self {
        case .all: return "All"
        case .today: return "Today"
        case .upcoming: return "Upcoming"
        case .completed: return "Completed"
        case .overdue: return "Overdue"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .today: return "today"
        case .upcoming: return "calendar"
        case .completed: return "checkmark.circle"
        case .overdue: return "clock.badge.exclamationmark"
        }
    }
}
