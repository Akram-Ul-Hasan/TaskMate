//
//  TMDatabaseManager.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import Foundation
import CoreData

class TMDatabaseManager {
    let persistantContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistantContainer.viewContext
    }
    
    static var preview: TMDatabaseManager = {
        let provider = TMDatabaseManager(inMemory: true)
        let context = provider.context
        
        let taskList = TaskList(context: context)
        taskList.title = "Office"
        taskList.createdDate = Date()
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        self.persistantContainer = NSPersistentContainer(name: "TaskMateModel")
        
        if inMemory {
            persistantContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistantContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data Store failed to initialize: \(error.localizedDescription)")
            }
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
                    date: String?,
                    time: String?,
                    dueTime: Date? = nil,
                    repeatRule: String? = nil,
                    repeatUntil: Date? = nil,
                    isStarred: Bool = false,
                    starredDate: Date? = nil,
                    isCompleted: Bool = false,
                    taskList: TaskList) -> Task {
        
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
        saveContext()
        return task
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
                    date: String? = nil,
                    time: String? = nil,
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

}
