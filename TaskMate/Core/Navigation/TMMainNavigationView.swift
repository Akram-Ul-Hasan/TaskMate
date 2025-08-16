//
//  TMMainNavigationView.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI

struct TMMainNavigationView: View {
    @EnvironmentObject var coordinator: TMNavigationCoordinator
    @EnvironmentObject var taskManager: TMTaskManager
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        TabView(selection: $coordinator.tabSelection) {
            ForEach(TMTabItem.allCases, id: \.self) { tab in
                NavigationStack(path: $coordinator.navigationStack) {
                    tabContent(for: tab)
                        .navigationDestination(for: TMNavigationRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .tabItem {
                    Image(systemName: coordinator.tabSelection == tab ? tab.selectedIcon : tab.icon)
                    Text(tab.rawValue)
                }
                .tag(tab)
            }
        }
    
        .sheet(item: $coordinator.presentedSheet) { route in
            sheetContent(for: route)
        }
        .fullScreenCover(item: $coordinator.presentedFullScreen) { route in
            fullScreenContent(for: route)
        }
    }
    
    @ViewBuilder
    private func tabContent(for tab: TMTabItem) -> some View {
        switch tab {
        case .tasks:
            TMHomeScreen(viewModel: TMHomeScreenViewModel(context: context, taskManager: taskManager))
//        case .search:
//            SearchView()
//        case .account:
//            AccountView()
        case .upcoming:
            TMUpcomingTasksView()
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: TMNavigationRoute) -> some View {
        switch route {
        case .tasks:
            TMHomeScreen(viewModel: TMHomeScreenViewModel(context: context, taskManager: taskManager))
        case .taskDetails(let taskList, let task):
            TMTaskDetailsScreen(taskList: taskList, task: task)
        case .addOrEditTaskList(let mode):
            TMAddOrEditTaskListScreen(mode: mode)
//        case .addTask(let taskList):
            
//        case .taskListSettings(let listID):
//            TaskListSettingsView(listID: listID)
//        case .searchResults(let query):
//            SearchResultsView(query: query)
//        case .completedTasks(let listID):
//            CompletedTasksView(listID: listID)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func sheetContent(for route: TMSheetRoute) -> some View {
        switch route {
        case .newTask(let listID):
            TMAddTaskSheetView(taskListId: listID ?? "")
//        case .editTask(let taskID):
//            EditTaskSheet(taskID: taskID)
//        case .taskOptions(let taskID):
//            TaskOptionsSheet(taskID: taskID)
//        case .listOptions(let listID):
//            ListOptionsSheet(listID: listID)
//        case .listSelector:
//            ListSelectorSheet()
//        case .sortFilter(let sort, let filter):
//            SortFilterSheet(currentSort: sort, currentFilter: filter)
//        case .settings:
//            SettingsSheet()
//        case .account:
//            AccountSheet()
//        case .about:
//            AboutSheet()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func fullScreenContent(for route: TMFullScreenRoute) -> some View {
        switch route {
        case .onboarding:
            TMOnboardingScreen()
//        case .auth(let mode):
//            AuthView(mode: mode)
//        case .taskRepeatOptions(let taskID):
//            TaskRepeatOptionsView(taskID: taskID)
//        case .dateTimePicker(let task, let completion):
//            DateTimePickerView(task: task, completion: completion)
        default:
            EmptyView()
        }
    }
}

