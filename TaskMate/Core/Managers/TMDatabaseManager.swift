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
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static var preview: TMDatabaseManager = {
        let provider = TMDatabaseManager(inMemory: true)
        let context = provider.context
        
        let taskList = TaskList(context: context)
        taskList.title = "Office"
        taskList.createdDate = Date()
        
        let task = Task(context: context)
        task.title = "Finish iOS module"
        task.isCompleted = false
        task.isStarred = true
        task.createdDate = Date()
        task.taskList = taskList
        
        do {
            try context.save()
        } catch {
            print("Preview context save error: \(error)")
        }
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "TaskMateModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
//        resetPersistentStore()
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data Store failed to initialize: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPersistentStore() {
        guard let storeURL = container.persistentStoreDescriptions.first?.url else {
            print("No persistent store URL found")
            return
        }
        
        let coordinator = container.persistentStoreCoordinator
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
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("successfully saved context")
            } catch {
                print("Failed to save: \(error.localizedDescription)")
            }
        }
    }
}

