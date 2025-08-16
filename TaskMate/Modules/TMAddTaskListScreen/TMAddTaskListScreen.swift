//
//  TMAddTaskListScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 2/7/25.
//

import SwiftUI

struct TMAddOrEditTaskListScreen: View {
    
    @EnvironmentObject private var coordinator : TMNavigationCoordinator
    @EnvironmentObject private var taskManager : TMTaskManager
    
    @State private var taskListTitle: String

    let screenType : TMTaskListScreenType
    
    init(mode: TMTaskListScreenType) {
        self.screenType = mode
        switch mode {
        case .create:
            _taskListTitle = .init(initialValue: "")
        case .edit(let taskList):
            _taskListTitle = .init(initialValue: taskList.title ?? "")
        }
    }

    var body: some View {
        VStack {
            TextField(screenType.placeholder , text: $taskListTitle)
                .font(.headline)
                .foregroundStyle(.blackLevel1)
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                .background(.whiteLevel1)
            
            Spacer()
        }
        .background(.whiteLevel2)
        .navigationTitle(screenType.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    saveTaskList()
                    coordinator.pop()
                }
                .disabled(taskListTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    private func saveTaskList() {
        switch screenType {
        case .create:
            taskManager.createTaskList(title: taskListTitle)
        case .edit(let taskList):
            taskManager.updateTaskList(taskList, title: taskListTitle, color: "")
        }
    }
    
}

//#Preview {
//    NavigationStack {
//        TMAddTaskListScreen()
//            .environmentObject(TMNavigationCoordinator())
//            .environmentObject(TMTaskManager())
//    }
//}
