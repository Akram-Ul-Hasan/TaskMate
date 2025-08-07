//
//  TMMainNavigationView.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI

//struct TMMainNavigationView: View {
//    @EnvironmentObject var coordinator: NavigationCoordinator
//    @Environment(\.managedObjectContext) private var context
//    
//    var body: some View {
//        TabView(selection: $coordinator.tabSelection) {
//            ForEach(TMTabItem.allCases, id: \.self) { tab in
//                NavigationStack(path: $coordinator.navigationStack) {
//                    tabContent(for: tab)
//                        .navigationDestination(for: TMNavigationRoute.self) { route in
//                            destinationView(for: route)
//                        }
//                }
//                .tabItem {
//                    Image(systemName: coordinator.tabSelection == tab ? tab.selectedIcon : tab.icon)
//                    Text(tab.rawValue)
//                }
//                .tag(tab)
//            }
//        }
//        .sheet(item: $coordinator.presentedSheet) { route in
//            sheetContent(for: route)
//        }
//        .fullScreenCover(item: $coordinator.presentedFullScreen) { route in
//            fullScreenContent(for: route)
//        }
//    }
//    
//    @ViewBuilder
//    private func tabContent(for tab: TMTabItem) -> some View {
//        switch tab {
//        case .tasks:
//            TMHomeScreen()
////        case .search:
////            SearchView()
////        case .account:
////            AccountView()
//        }
//    }
//    
//    @ViewBuilder
//    private func destinationView(for route: NavigationRoute) -> some View {
//        switch route {
//        case .taskDetail(let taskID):
//            TaskDetailView(taskID: taskID)
////        case .editTask(let taskID):
////            EditTaskView(taskID: taskID)
//        case .newTaskList:
//            TMAddTaskListScreen()
//        case .taskListSettings(let listID):
//            TaskListSettingsView(listID: listID)
//        case .searchResults(let query):
//            SearchResultsView(query: query)
//        case .completedTasks(let listID):
//            CompletedTasksView(listID: listID)
//        }
//    }
//    
//    @ViewBuilder
//    private func sheetContent(for route: SheetRoute) -> some View {
//        switch route {
//        case .newTask(let listID):
//            NewTaskSheet(listID: listID)
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
//        }
//    }
//    
//    @ViewBuilder
//    private func fullScreenContent(for route: FullScreenRoute) -> some View {
//        switch route {
//        case .onboarding:
//            TMOnboardingScreen()
//        case .auth(let mode):
//            AuthView(mode: mode)
//        case .taskRepeatOptions(let taskID):
//            TaskRepeatOptionsView(taskID: taskID)
//        case .dateTimePicker(let task, let completion):
//            DateTimePickerView(task: task, completion: completion)
//        }
//    }
//}
//
