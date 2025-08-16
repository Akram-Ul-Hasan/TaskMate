//
//  TMSelectedList.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/10/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

enum TMSelectedList: Equatable {
    case starred
    case taskList(taskList: TaskList)
    
    var title: String {
        switch self {
        case .starred:
            return "⭐"
        case .taskList(let taskList):
            return taskList.title ?? "Untitled"
        }
    }
    
    var id: String {
        switch self {
        case .starred:
            return "starred"
        case .taskList(let taskList):
            return taskList.id ?? UUID().uuidString
        }
    }
    
    static func == (lhs: TMSelectedList, rhs: TMSelectedList) -> Bool {
        switch (lhs, rhs) {
        case (.starred, .starred):
            return true
        case (.taskList(let lhsList), .taskList(let rhsList)):
            return lhsList.id == rhsList.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
