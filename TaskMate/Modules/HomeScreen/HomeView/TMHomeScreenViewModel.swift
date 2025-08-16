//
//  TMHomeViewModel.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import Foundation
import CoreData

class TMHomeScreenViewModel: ObservableObject {
    
    @Published var selectedList: TMSelectedList = .starred
    @Published var selectedSort: TMSortOption = .dateCreated
    
    private let context: NSManagedObjectContext
    private let taskManager: TMTaskManager
    
    init(context: NSManagedObjectContext, taskManager: TMTaskManager) {
        self.context = context
        self.taskManager = taskManager
    }
    
    var selectedTaskList: TaskList? {
        if case .taskList(let list) = selectedList {
            return list
        }
        return nil
    }
    
    var filteredTasks: [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        switch selectedList {
        case .starred:
            request.predicate = NSPredicate(format: "isStarred == true")
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.starredDate, ascending: false)]
            
        case .taskList(let taskList):
            request.predicate = NSPredicate(format: "listId == %@", taskList.id ?? "")
            request.sortDescriptors = selectedSort.sortDescriptors
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Task fetch error:", error)
            return []
        }
    }
        
    func deleteList() {
        if let list = selectedTaskList {
            taskManager.deleteTaskList(list)
        }
    }
    
    func deleteCompletedTasks() {
        if let list = selectedTaskList {
            taskManager.deleteAllCompletedTasks(list)
        }
    }
    
    func toggleStarred(_ task: Task) {
        taskManager.toggleTaskAsStarred(task)
    }
    
    func markTaskAsCompleted(_ task: Task) {
        taskManager.toggleTaskASComplete(task)
    }
}

