//
//  TMHomeScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import SwiftUI

enum SelectedList: Identifiable, Equatable {
    case starred
    case taskList(TaskList)
    
    var id: UUID {
        switch self {
        case .starred:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        case .taskList(let list):
            return list.id!
            
        }
    }
    
    var title: String {
        switch self {
        case .starred:
            return "⭐"
        case .taskList(let list):
            return list.title ?? "Untitled"

        }
    }
}


struct TMHomeScreen: View {
    
    @EnvironmentObject var db: TMDatabaseManager
    @EnvironmentObject var coordinator: AppCoordinator
    
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [],
        animation: .default
    )
    private var taskLists: FetchedResults<TaskList>
    
    @State private var selectedList: SelectedList = .starred
    @State private var selectedSort: SortOption = .date
    @State private var tasks: [Task] = []
    @State private var showNewTaskSheet = false
    
    func fetchAssociateTasks() {
        tasks = db.fetchTasks(for: selectedList, selectedSort: selectedSort)
    }
    
    func updateCompleteStatus() {
//        db.updateTask()
    }
    
    var body: some View {
        //        ZStack {
        VStack {
            listSelectorBar
            
            Divider()
            
            taskListView
            
            TMHomeBottomView(
                onMenuTap: {
                    coordinator.presentSheet(.listSelector)
                }, onAddTaskTap: {
                    if let taskList = selectedTaskList {
                        coordinator.presentSheet(.newTask(taskList: taskList))
                    }
                    
                }, onMoreTap: {
                    coordinator.presentSheet(.listOptions)
                })
            
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                }
            }
        }
    }
    //    }
    private var listSelectorBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                
                Button(action: {
                    withAnimation {
                        selectedList = .starred
                        fetchAssociateTasks()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(selectedList == .starred ? .blue : .gray)
                        underlineView(for: .starred)
                    }
                }

                ForEach(taskLists) { list in
                    let current = SelectedList.taskList(list)
                    Button(action: {
                        withAnimation {
                            selectedList = current
                            fetchAssociateTasks()
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(list.title ?? "Untitled")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedList == current ? Color.blue : .primary)
                            underlineView(for: current)
                        }
                    }
                }
                
                Button {
                    coordinator.push(.newTaskList)
                } label: {
                    Text("+ New list")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.blackLevel1)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 5)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }

    private var taskListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if tasks.isEmpty {
                    Text("No tasks yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(tasks) { task in
                        TMHomeTaskRowView(task: task) {
                                
                        } onToggleComplete: {
                            updateCompleteStatus()
                        }

                    }
                }
            }
            .padding()
        }
    }
    
    private var selectedTaskList: TaskList? {
        if case .taskList(let list) = selectedList {
            return list
        }
        return nil
    }
    
    @ViewBuilder
    private func underlineView(for item: SelectedList) -> some View {
        if selectedList == item {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.blue)
                .frame(height: 3)
                .padding(.top, 2)
                .matchedGeometryEffect(id: "underline", in: Namespace().wrappedValue)
        } else {
            Color.clear.frame(height: 3).padding(.top, 2)
        }
    }

}


#Preview {
    NavigationStack {
        TMHomeScreen()
    }
}
