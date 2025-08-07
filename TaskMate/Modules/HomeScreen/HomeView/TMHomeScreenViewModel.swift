//
//  TMHomeViewModel.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import Foundation
import CoreData

enum SelectedList:  Equatable {
    
    case starred
    case taskList(TaskList)
    
//    var id: UUID {
//        switch self {
//        case .starred:
//            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
////        case .taskList(let list):
////            return list.id
////
//
//        }
//    }
    
    var title: String {
        switch self {
        case .starred:
            return "⭐"
        case .taskList(let list):
            return list.title ?? "Untitled"

        }
    }
}

class TMHomeScreenViewModel: ObservableObject {
    @Published var selectedList: SelectedList = .starred
    @Published var selectedSort: TMSortOption = .dateCreated
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
            
        case .taskList(let list):
            request.predicate = NSPredicate(format: "taskList == %@", list)
            switch selectedSort {
            case .dateCreated:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createdDate, ascending: true)]
            case .alphabetical:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.title, ascending: true)]
//            case .starred:
//                request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.starredDate, ascending: false)]
            default:
                break
            }
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Task fetch error:", error)
            return []
        }
    }
}

