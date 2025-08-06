//
//  AppCoordinator.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI
import Combine
import OSLog

// MARK: - Navigation Protocols

/// Protocol defining navigation capabilities
protocol NavigationCoordinator: ObservableObject {
    associatedtype Route: Hashable
    associatedtype SheetRoute: Identifiable & Hashable
    associatedtype FullScreenRoute: Identifiable & Hashable
    
    var navigationPath: NavigationPath { get set }
    var currentSheet: SheetRoute? { get set }
    var currentFullScreen: FullScreenRoute? { get set }
    
    func navigate(to route: Route)
    func pop()
    func popToRoot()
    func presentSheet(_ route: SheetRoute)
    func dismissSheet()
    func presentFullScreen(_ route: FullScreenRoute)
    func dismissFullScreen()
}

class NavigationCoordinator: ObservableObject {

    @Published var navigationPath: [CoordinatorRoute] = []
    
    @Published var sheetRoute: SheetRoute?
    @Published var fullScreenRoute: FullScreenRoute?
    
    @Published var selectedTaskList: TaskList?

    func push(_ route: CoordinatorRoute) {
        navigationPath.append(route)
    }

    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func popToRoot() {
        navigationPath.removeAll()
    }

    func presentSheet(_ route: SheetRoute) {
        sheetRoute = route
    }

    func dismissSheet() {
        sheetRoute = nil
    }

    func presentFullScreen(_ route: FullScreenRoute) {
        fullScreenRoute = route
    }

    func dismissFullScreen() {
        fullScreenRoute = nil
    }
}

enum CoordinatorRoute: Hashable {
    case taskDetails(taskID: String)
    case newTaskList
}

enum SheetRoute: Identifiable, Hashable, Equatable {
    case newTask(taskList: TaskList)
    case listOptions
    case listSelector(sheetHeight: CGFloat)
    
    
    
    var id: String {
        switch self {
        case .newTask:
            return "newTask"
            
        case .listOptions:
            return "listOptions"

        case .listSelector:
            return "listSelector"
        }
    }
}


enum FullScreenRoute: Identifiable, Hashable {
    var id: String { UUID().uuidString }

    case repeatOptions
}

enum ListOptionAction {
    case rename
    case delete
    case deleteAll
    case sort(SortOption)
}

enum SortOption: String, CaseIterable {
    case alphabetical = "A–Z"
    case date = "Date"
    case starred = "Starred recently"
}
