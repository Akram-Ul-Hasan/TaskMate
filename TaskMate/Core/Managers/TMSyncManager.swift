//
//  TMSyncManager.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CoreData

class SyncManager: ObservableObject {
    private let db = Firestore.firestore()
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    
    private let coreDataManager = TMDatabaseManager.shared
    
    func syncData(userId: String) {
        guard !isSyncing else { return }
        
        isSyncing = true
        
        _Concurrency.Task {
            await syncTaskLists(userId: userId)
            await syncTasks(userId: userId)
            
            DispatchQueue.main.async {
                self.isSyncing = false
                self.lastSyncDate = Date()
                UserDefaults.standard.set(Date(), forKey: "lastSyncDate")
            }
        }
    }
    
    private func syncTaskLists(userId: String) async {
        let collection = db.collection("users").document(userId).collection("taskLists")
        
        do {
            let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
            request.predicate = NSPredicate(format: "lastSyncDate == nil")
            
            let unsynced = try coreDataManager.context.fetch(request)
            
            for taskList in unsynced {
                let data: [String: Any] = [
                    "title": taskList.title ?? "",
                    "color": taskList.color ?? "",
                    "position": taskList.position,
                    "createdDate": Timestamp(date: taskList.createdDate ?? Date()),
                    "deletedFlag": taskList.deletedFlag
                ]
                
                try await collection.document(taskList.id ?? "").setData(data, merge: true)
                taskList.lastSyncDate = Date()
            }
            
            let snapshot = try await collection.getDocuments()
            
            for document in snapshot.documents {
                let data = document.data()
                
                let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", document.documentID)
                
                let existing = try coreDataManager.context.fetch(fetchRequest)
                
                if existing.isEmpty {
                    let taskList = TaskList(context: coreDataManager.context)
                    taskList.id = document.documentID
                    taskList.title = data["title"] as? String ?? ""
                    taskList.color = data["color"] as? String ?? "blue"
                    taskList.position = Int16(data["position"] as? Int ?? 0)
                    taskList.deletedFlag = data["deleteFlag"] as? Bool ?? false
                    if let createdDate = data["createdDate"] as? Timestamp {
                        taskList.createdDate = createdDate.dateValue()
                    }
                    taskList.lastSyncDate = Date()
                }
            }
            
            try coreDataManager.context.save()
        } catch {
            print("Error syncing task lists: \\(error)")
        }
    }
    
    private func syncTasks(userId: String) async {
        let collection = db.collection("users").document(userId).collection("tasks")
        
        do {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.predicate = NSPredicate(format: "lastSyncDate == nil")
            
            let unsynced = try coreDataManager.context.fetch(request)
            
            for task in unsynced {
                var data: [String: Any] = [
                    "title": task.title ?? "",
                    "notes": task.notes ?? "",
                    "isCompleted": task.isCompleted,
                    "priority": task.priority,
                    "listId": task.listId ?? "",
                    "position": task.position,
                    "createdDate": Timestamp(date: task.createdDate ?? Date()),
                    "isDeleted": task.isDeleted
                ]
                
                if let dueDate = task.dueDate {
                    data["dueDate"] = Timestamp(date: dueDate)
                }
                if let completedDate = task.completedDate {
                    data["completedDate"] = Timestamp(date: completedDate)
                }
                if let parentId = task.parentId {
                    data["parentId"] = parentId
                }
                
                try await collection.document(task.id ?? "").setData(data, merge: true)
                task.lastSyncDate = Date()
            }
            
            let snapshot = try await collection.getDocuments()
            
            for document in snapshot.documents {
                let data = document.data()
                
                let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", document.documentID)
                
                let existing = try coreDataManager.context.fetch(fetchRequest)
                
                if existing.isEmpty {
                    let task = Task(context: coreDataManager.context)
                    task.id = document.documentID
                    task.title = data["title"] as? String ?? ""
                    task.notes = data["notes"] as? String ?? ""
                    task.isCompleted = data["isCompleted"] as? Bool ?? false
                    task.priority = Int16(data["priority"] as? Int ?? 1)
                    task.listId = data["listId"] as? String ?? ""
                    task.parentId = data["parentId"] as? String
                    task.position = Int16(data["position"] as? Int ?? 0)
                    task.deleteFlag = data["deleteFlag"] as? Bool ?? false
                    
                    if let createdDate = data["createdDate"] as? Timestamp {
                        task.createdDate = createdDate.dateValue()
                    }
                    if let dueDate = data["dueDate"] as? Timestamp {
                        task.dueDate = dueDate.dateValue()
                    }
                    if let completedDate = data["completedDate"] as? Timestamp {
                        task.completedDate = completedDate.dateValue()
                    }
                    
                    task.lastSyncDate = Date()
                }
            }
            
            try coreDataManager.context.save()
        } catch {
            print("Error syncing tasks: \\(error)")
        }
    }
}
