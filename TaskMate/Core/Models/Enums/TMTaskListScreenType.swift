//
//  TMTaskListScreenMode.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/14/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

enum TMTaskListScreenType: Hashable {
    case create
    case edit(TaskList)
    
    var title: String {
        switch self {
        case .create:
            return "Create new List"
        case .edit:
            return "Edit List"
        }
    }
    
    var placeholder: String {
        switch self {
        case .create:
            return "Enter List title"
        case .edit:
            return "Edit List title"
        }
    }
}
