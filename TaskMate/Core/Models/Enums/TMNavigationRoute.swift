//
//  TMNavigationRoute.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import Foundation

enum TMNavigationRoute: Hashable {
    case taskDetail(taskID: String)
    case editTask(taskID: String)
    case newTaskList
    case taskListSettings(listID: String)
    case searchResults(query: String)
    case completedTasks(listID: String)
}
