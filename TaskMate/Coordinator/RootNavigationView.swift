//
//  RootNavigationView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI

struct RootNavigationView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            TMRootContentView()
                .navigationDestination(for: CoordinatorRoute.self) { route in
                    switch route {
                    case .taskDetails(let taskID):
                        EmptyView()
                    case .newTaskList:
                        TMAddTaskListScreen()
                    }
                }
                .sheet(item: $coordinator.sheetRoute) { route in
                    switch route {
                    case .newTask(let taskList):
                        TMAddTaskSheetView(taskList: taskList)
                    case .listOptions:
                        TMHomeOptionView()

                    case .listSelector(let sheetHeight):
                        TMHomeTaskSelecterView(sheetHeight: sheetHeight)
                    }
                }
                .fullScreenCover(item: $coordinator.fullScreenRoute) { route in
                    switch route {
                    case .repeatOptions:
                        TMTaskRepeatSelectionScreen()
                    }
                }
        }
    }
}
