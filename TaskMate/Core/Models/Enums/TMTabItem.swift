//
//  TMTabItem.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

enum TMTabItem: String, CaseIterable {
    case tasks = "Tasks"
    case upcoming = "Upcoming"

    //    case search = "Search"
    //    case account = "Account"
    
    var icon: String {
        switch self {
        case .tasks: return "list.clipboard.fill"
            //        case .search: return "magnifyingglass"
            //        case .account: return "person.circle"
        case .upcoming: return "alarm"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .tasks: return "list.clipboard.fill"
            //        case .search: return "magnifyingglass"
            //        case .account: return "person.circle.fill"
        case .upcoming: return "alarm"
        }
    }
}
