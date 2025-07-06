//
//  TMDatabaseManager.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import Foundation
import CoreData

class TMDatabaseManager: ObservableObject {
    static let shared = TMDatabaseManager()
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //    static var preview: TMDatabaseManager = {
    //        let provider = TMDatabaseManager(inMemory: true)
    //        let context = provider.context
    //
    //        let taskList = TaskList(context: context)
    //        taskList.title = "Office"
    //        taskList.createdDate = Date()
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print(error)
    //        }
    //
    //        return provider
    //    }()
    
    init(inMemory: Bool = false) {
        self.persistentContainer = NSPersistentContainer(name: "TaskMateModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data Store failed to initialize: \(error.localizedDescription)")
            }
        }
    }

    func resetPersistentStore() {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            print("No persistent store URL found")
            return
        }

        let coordinator = persistentContainer.persistentStoreCoordinator
        do {
            // Remove the old store from the coordinator
            if let store = coordinator.persistentStore(for: storeURL) {
                try coordinator.remove(store)
            }
            // Delete the SQLite file
            try FileManager.default.removeItem(at: storeURL)
            print("Persistent store deleted successfully")
        } catch {
            print("Failed to delete persistent store: \(error)")
        }
    }

    
    func fetchTasks(for selectedList: SelectedList, selectedSort: SortOption) -> [Task] {
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        
        switch selectedList {
        case .starred:
            req.predicate = NSPredicate(format: "isStarred == YES")
            req.sortDescriptors = [
                NSSortDescriptor(key: "starredDate", ascending: false)
            ]
            
        case .taskList(let list):
            req.predicate = NSPredicate(format: "taskList == %@", list)
            switch selectedSort {
            case .alphabetical:
                req.sortDescriptors = [
                    NSSortDescriptor(key: "name", ascending: true)
                ]
            case .date:
                req.sortDescriptors = [
                    NSSortDescriptor(key: "createdDate", ascending: true)
                ]
            case .starred:
                req.sortDescriptors = [
                    NSSortDescriptor(key: "starredDate", ascending: false)
                ]
            }
        }
        
        do {
            return try context.fetch(req)
        } catch {
            print("Failed to fetch tasks:", error)
            return []
        }
    }
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Create TaskList
    func createTaskList(title: String) -> TaskList {
        let newList = TaskList(context: context)
        newList.id = UUID()
        newList.title = title
        newList.createdDate = Date()
        saveContext()
        return newList
    }
    
    // MARK: - Create Task
    func createTask(name: String,
                    details: String? = nil,
                    date: Date?,
                    time: Date?,
                    dueTime: Date? = nil,
                    repeatRule: String? = nil,
                    repeatUntil: Date? = nil,
                    isStarred: Bool = false,
                    starredDate: Date? = nil,
                    isCompleted: Bool = false,
                    taskList: TaskList) {
        
        let task = Task(context: context)
        task.id = UUID()
        task.name = name
        task.details = details
        task.date = date
        task.time = time
        task.dueTime = dueTime
        task.repeatRule = repeatRule
        task.repeatUntil = repeatUntil
        task.isStarred = isStarred
        task.starredDate = starredDate
        task.isCompleted = isCompleted
        task.taskList = taskList
        task.createdDate = Date()
        print("---creating task---")
        saveContext()
    }
    
    // MARK: - Update TaskList
    func updateTaskList(_ list: TaskList, newTitle: String) {
        list.title = newTitle
        saveContext()
    }
    
    // MARK: - Update Task
    func updateTask(_ task: Task,
                    name: String? = nil,
                    details: String? = nil,
                    date: Date? = nil,
                    time: Date? = nil,
                    dueTime: Date? = nil,
                    repeatRule: String? = nil,
                    repeatUntil: Date? = nil,
                    isStarred: Bool? = nil,
                    starredDate: Date? = nil,
                    isCompleted: Bool? = nil,
                    taskList: TaskList? = nil) {
        
        if let name = name { task.name = name }
        if let details = details { task.details = details }
        if let date = date { task.date = date }
        if let time = time { task.time = time }
        if let dueTime = dueTime { task.dueTime = dueTime }
        if let repeatRule = repeatRule { task.repeatRule = repeatRule }
        if let repeatUntil = repeatUntil { task.repeatUntil = repeatUntil }
        if let isStarred = isStarred { task.isStarred = isStarred }
        if let starredDate = starredDate { task.starredDate = starredDate }
        if let isCompleted = isCompleted { task.isCompleted = isCompleted }
        if let taskList = taskList { task.taskList = taskList }
        
        saveContext()
    }
    
    // MARK: - Delete TaskList
    func deleteTaskList(_ list: TaskList) {
        context.delete(list)
        saveContext()
    }
    
    // MARK: - Delete Task
    func deleteTask(_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func createInitialUserListIfNeeded(displayName: String) -> TaskList {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", displayName)
        
        if let existing = try? context.fetch(request).first {
            return existing
        }
        
        let newList = createTaskList(title: displayName)
        print("Created default user list for: \(displayName)")
        return newList
    }
    
}

