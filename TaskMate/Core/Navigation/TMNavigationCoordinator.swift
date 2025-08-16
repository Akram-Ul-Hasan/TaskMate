//
//  TMNavigationCoordinator.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import SwiftUI
import Combine

class TMNavigationCoordinator: ObservableObject {
    
    @Published var appState: TMAppState = .splash
    @Published var navigationStack: [TMNavigationRoute] = []
    @Published var presentedSheet: TMSheetRoute?
    @Published var presentedFullScreen: TMFullScreenRoute?

    @Published var selectedTaskListID: String?
    @Published var selectedTask: Task?
    
    @Published var tabSelection: TMTabItem = .tasks
    
    
    private let authManager: TMAuthManager
    private let settingsManager: TMSettingsManager
    
    private var cancellables = Set<AnyCancellable>()

    init(authManager: TMAuthManager = TMAuthManager.shared, settingsManager: TMSettingsManager = TMSettingsManager.shared) {
        self.authManager = authManager
        self.settingsManager = settingsManager
        setupInitialState()
        observeAuthChanges()
    }
    
    private func setupInitialState() {
        if !settingsManager.hasCompletedOnboarding {
            appState = .onboarding
        } else if !authManager.isAuthenticated {
            appState = .authentication
        } else {
            appState = .main
        }
    }
    
    private func observeAuthChanges() {
        authManager.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                if !self.settingsManager.hasCompletedOnboarding {
                    self.appState = .onboarding
                } else if !isAuthenticated {
                    self.appState = .authentication
                } else {
                    self.appState = .main
                }
            }
            .store(in: &cancellables)
    }
    
    func navigateToMain() {
        withAnimation(.easeInOut) {
            appState = .main
        }
    }
    
    func navigateToAuth(mode: TMAuthMode = .signIn) {
        withAnimation(.easeInOut) {
            appState = .authentication
        }
        presentFullScreen(TMFullScreenRoute.auth(mode: mode))
    }
    
    func showOnboarding() {
        withAnimation(.easeInOut) {
            appState = .onboarding
        }
    }
    
    // MARK: - Stack Navigation
    func push(_ route: TMNavigationRoute) {
        navigationStack.append(route)
    }
    
    func pop() {
        guard !navigationStack.isEmpty else { return }
        navigationStack.removeLast()
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
    
//    func popTo(_ targetRoute: TMNavigationRoute) {
//        if let targetIndex = navigationStack.firstIndex(where: { $0.id == targetRoute.id }) {
//            navigationStack = Array(navigationStack[0...targetIndex])
//        }
//    }
    // MARK: - Sheet Presentation
    func presentSheet(_ route: TMSheetRoute) {
        presentedSheet = route
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    // MARK: - Full Screen Presentation
    func presentFullScreen(_ route: TMFullScreenRoute) {
        presentedFullScreen = route
    }
    
    func dismissFullScreen() {
        presentedFullScreen = nil
    }
    
    // MARK: - Tab Navigation
    func selectTab(_ tab: TMTabItem) {
        tabSelection = tab
        popToRoot()
    }
    
    // MARK: - Convenience Methods
    func showTaskDetail(_ taskList: TaskList, _ task: Task) {
        push(.taskDetails(taskList: taskList, task: task))
    }
    
    func showNewTask(in listID: String? = nil) {
        presentSheet(.newTask(listID: listID ?? selectedTaskListID))
    }
    
    func showEditTask(_ taskID: String) {
        presentSheet(.editTask(taskID: taskID))
    }
    
    func showTaskOptions(_ taskID: String) {
        presentSheet(.taskOptions(taskID: taskID))
    }
    
    func showListOptions(_ listID: String? = nil) {
        presentSheet(.listOptions(listID: listID ?? selectedTaskListID ?? ""))
    }
    
    func showSettings() {
        presentSheet(.settings)
    }
    
//    func showSearch(query: String) {
//        push(.searchResults(query: query))
//    }
    
    // MARK: - Deep Linking Support
//    func handleDeepLink(_ url: URL) {
//        // Parse URL and navigate accordingly
//        // Example: tasksapp://task/123
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
//        
//        switch components.host {
//        case "task":
//            if let taskID = components.path.components(separatedBy: "/").last {
//                push(.taskDetails(taskList: , task: )(taskID: taskID))
//            }
//        case "list":
//            if let listID = components.path.components(separatedBy: "/").last {
//                selectedTaskListID = listID
//                selectTab(.tasks)
//            }
//        default:
//            break
//        }
//    }
    
    // MARK: - State Reset
    func reset() {
        navigationStack.removeLast(navigationStack.count)
        presentedSheet = nil
        presentedFullScreen = nil
        selectedTask = nil
        selectedTaskListID = nil
        tabSelection = .tasks
    }
}
