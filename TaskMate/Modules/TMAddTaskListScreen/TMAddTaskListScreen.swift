//
//  TMAddTaskListScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 2/7/25.
//

import SwiftUI

struct TMAddTaskListScreen: View {
    
    @EnvironmentObject private var coordinator : NavigationCoordinator
    @EnvironmentObject private var db : TMDatabaseManager
    @State private var taskListTitle = ""
    
    func saveTaskList() {
//        db.createTaskList(title: taskListTitle)
    }
    
    var body: some View {
        VStack {
            TextField("Enter list title", text: $taskListTitle)
                .font(.headline)
                .foregroundStyle(.blackLevel1)
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                .background(.whiteLevel1)
            
            Spacer()
            
                .navigationTitle("Create new list")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            saveTaskList()
                            coordinator.pop()
                        }
                        .disabled(taskListTitle.isEmpty)
                    }
                }
        }
        .background(.whiteLevel2)
    }
}

#Preview {
    NavigationStack {
        TMAddTaskListScreen()
        
    }
}
