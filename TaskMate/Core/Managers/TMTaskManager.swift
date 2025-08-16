//
//  TMTaskManager.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 8/6/25.
//

import SwiftUI
import Combine
import CoreData

enum ViewType {
    case list
    case calendar
}

class TMTaskManager: ObservableObject {
    @Published var taskLists: [TaskList] = []
    @Published var tasks: [Task] = []
    @Published var selectedListId: String?
    @Published var currentFilter: TMTaskFilter = .all
    @Published var searchText = ""
    @Published var viewType: ViewType = .list
    
    private let coreDataManager = TMDatabaseManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    private func loadData() {
        loadTaskLists()
        loadTasks()
    }
    
    private func loadTaskLists() {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        request.predicate = NSPredicate(format: "deleteFlag == NO")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskList.position, ascending: true)]
        
        do {
            taskLists = try coreDataManager.context.fetch(request)
            if taskLists.isEmpty {
                createDefaultList()
            } else if selectedListId == nil {
                selectedListId = taskLists.first?.id
            }
        } catch {
            print("Error loading task lists: \(error)")
        }
    }
    
    private func loadTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "deleteFlag == NO")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Task.position, ascending: true),
            NSSortDescriptor(keyPath: \Task.createdDate, ascending: false)
        ]
        
        do {
            tasks = try coreDataManager.context.fetch(request)
        } catch {
            print("Error loading tasks: \\(error)")
        }
    }
    
    func createTaskList(title: String, color: String = "system") {
        let taskList = TaskList(context: coreDataManager.context)
        taskList.id = UUID().uuidString
        taskList.title = title
        taskList.deleteFlag = false
        taskList.createdDate = Date()
        taskList.lastSyncDate = nil
        taskList.color = color
        taskList.position = Int16(taskLists.count)
        
        coreDataManager.save()
//        loadTaskLists()
    }
    
    private func createDefaultList() {
        createTaskList(title: "My Tasks")
    }
    
    func deleteTaskList(_ taskList: TaskList) {
        taskList.deleteFlag = true
        
        let tasksInList = tasks.filter { $0.listId == taskList.id }
        tasksInList.forEach { $0.deleteFlag = true }
        
        coreDataManager.save()
        loadData()
        
        if selectedListId == taskList.id {
            selectedListId = taskLists.first(where: { !$0.isDeleted })?.id
        }
    }
    
    func updateTaskList(_ taskList: TaskList, title: String, color: String?) {
        taskList.title = title
        taskList.color = color
        taskList.lastSyncDate = nil
        
        coreDataManager.save()
        loadTaskLists()
    }
    
    func deleteAllCompletedTasks(_ taskList: TaskList) {
        if let tasks = taskList.tasks as? Set<Task> {
            tasks.forEach { task in
                if task.isCompleted {
                    task.deleteFlag = true
                }
            }
        }
    }
    
    // MARK: - Task Operations
    func createTask(title: String, details: String = "", isStarred: Bool = false, isCompleted: Bool = false, notes: String = "", priority: TaskPriority = .medium, dueDate: Date? = nil, deleteFlag: Bool = false, listId: String, parentId: String? = nil) {
        let task = Task(context: coreDataManager.context)
        task.id = UUID().uuidString
        task.title = title
        task.details = details
        task.isStarred = isStarred
        task.isCompleted = isCompleted
        task.deleteFlag = deleteFlag
        task.notes = notes
        task.priority = Int16(priority.rawValue)
        task.dueDate = dueDate
        task.listId = listId
        task.parentId = parentId
        task.createdDate = Date()
        
        let siblingTasks = tasks.filter { $0.listId == listId && $0.parentId == parentId }
        task.position = Int16(siblingTasks.count)
        
        coreDataManager.save()
        loadTasks()
        
        //TODO
//        if let dueDate = dueDate {
//            TMNotificationManager.shared.scheduleNotification(for: task)
//        }
    }
    
    func updateTask(_ task: Task, title: String, notes: String, priority: TaskPriority, dueDate: Date?) {
        task.title = title
        task.notes = notes
        task.priority = Int16(priority.rawValue)
        task.dueDate = dueDate
        task.lastSyncDate = nil
        
        coreDataManager.save()
        loadTasks()
        
        //TODO
//        NotificationManager.shared.cancelNotification(for: task.id)
//        if let dueDate = dueDate, !task.isCompleted {
//            NotificationManager.shared.scheduleNotification(for: task)
//        }
    }
    
    func toggleTaskASComplete(_ task: Task) {
        task.isCompleted.toggle()
        task.completedDate = task.isCompleted ? Date() : nil
        task.lastSyncDate = nil
        
        //TODO
//        if task.isCompleted && task.parentId == nil {
//            task.subtasksArray?.forEach { subtask in
//                subtask.iscompleted = true
//                subtask.completedDate = Date()
//            }
//        }
        
        coreDataManager.save()
//        loadTasks()
        
        //TODO
//        if task.isCompleted {
//            NotificationManager.shared.cancelNotification(for: task.id)
//        } else if let dueDate = task.dueDate {
//            NotificationManager.shared.scheduleNotification(for: task)
//        }
    }
        
    func deleteTask(_ task: Task) {
        task.deleteFlag = true
                
        coreDataManager.save()
//        loadTasks()
        
        //TODO
//        NotificationManager.shared.cancelNotification(for: task.id)
    }
    
    func toggleTaskAsStarred(_ task: Task) {
        task.isStarred.toggle()
        
        coreDataManager.save()
    }
    // MARK: - Filtering
    func filteredTasks(for listId: String) -> [Task] {
        var filtered = tasks.filter { task in
            task.listId == listId && task.parentId == nil && !task.isDeleted
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { task in
                (task.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (task.notes?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        
        switch currentFilter {
        case .all:
            break
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            filtered = filtered.filter { task in
                if let dueDate = task.dueDate {
                    return dueDate >= today && dueDate < tomorrow
                }
                return false
            }
        case .upcoming:
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            filtered = filtered.filter { task in
                if let dueDate = task.dueDate {
                    return dueDate >= tomorrow && !task.isCompleted
                }
                return false
            }
        case .completed:
            filtered = filtered.filter { $0.isCompleted }
        case .overdue:
            filtered = filtered.filter { task in
                if let dueDate = task.dueDate {
                    return dueDate < Date() && !task.isCompleted
                }
                return false
            }
        }
        
        return filtered.sorted { (task1: Task, task2: Task) -> Bool in
            if task1.priority != task2.priority {
                return task1.priority > task2.priority
            }
            
            if let date1 = task1.dueDate, let date2 = task2.dueDate {
                return date1 < date2
            }
            if task1.dueDate != nil { return true }
            if task2.dueDate != nil { return false }
            
            return task1.position < task2.position
        }
    }
    
}
