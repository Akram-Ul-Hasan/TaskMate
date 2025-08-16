//
//  TMNavigationRoute.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import Foundation

enum TMNavigationRoute: Hashable {
    
    case tasks
    case taskDetails(taskList: TaskList, task: Task)
    case addOrEditTaskList(screenType: TMTaskListScreenType)
//    case addTask(taskList: TaskList)
//    case taskListSettings(listID: String)
//    case searchResults(query: String)
    case completedTasks(listID: String)


}
