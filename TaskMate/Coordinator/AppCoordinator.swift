//
//  AppCoordinator.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI

class AppCoordinator: ObservableObject {

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
}

enum SheetRoute: Identifiable, Hashable {
    var id: String { UUID().uuidString }
    
    case newTask
    case taskOptions(taskID: String)
    case datePicker(taskID: String)
    case repeatOptions(taskID: String)
    case listSelector
}

enum FullScreenRoute: Identifiable, Hashable {
    var id: String { UUID().uuidString }

    case onboarding
}
