//
//  TMHomeScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import SwiftUI
import CoreData

struct TMHomeScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var networkMonitor: TMNetworkMonitor
    @EnvironmentObject var authManager: TMAuthManager
    
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \TaskList.createdDate, ascending: true)],
        animation: .default
    )
    private var taskLists: FetchedResults<TaskList>
    
    @StateObject var viewModel: TMHomeScreenViewModel
    
    @Namespace private var animationNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                listSelectorBar
                
                Divider()
                
                taskListView
                
                TMHomeBottomView(
                    onMenuTap: {
                        coordinator.presentSheet(.listSelector(sheetHeight: CGFloat((taskLists.count + 1) * 60)))
                    }, onAddTaskTap: {
                        if let taskList = viewModel.selectedTaskList {
                            coordinator.presentSheet(.newTask(taskList: taskList))
                        }
                        
                    }, onMoreTap: {
                        coordinator.presentSheet(.listOptions)
                    }
                )
                
                .navigationTitle(TMStrings.Home.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        TMUserProfileButton(photoURL: authManager.photoURL)
                    }
                }
                
                if networkMonitor.isConnected {
                    TMOfflineBanner()
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var listSelectorBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.selectedList = .starred
                        
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(viewModel.selectedList == .starred ? .blue : .gray)
                        underlineView(for: .starred)
                    }
                }
                
                ForEach(taskLists) { list in
                    let current = SelectedList.taskList(list)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.selectedList = current
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(list.title ?? "Untitled")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(viewModel.selectedList == current ? Color.blue : .primary)
                            underlineView(for: current)
                        }
                    }
                }
                
                Button {
                    coordinator.push(.newTaskList)
                } label: {
                    Text(TMStrings.Home.newTaskListButtonTitle)
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
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.filteredTasks.isEmpty {
                TMEmptyView(imageName: TMImages.emptyTask, title: TMStrings.Home.emptyTaskTitle, subtitle: TMStrings.Home.emptyTaskDescription)
            } else {
                ForEach(viewModel.filteredTasks) { task in
                    TMHomeTaskRowView(task: task, onToggleStar: {
                        
                    }, onToggleComplete: {
                        
                    })
                    
                }
            }
        }
        .padding()
    }
    
    
    @ViewBuilder
    private func underlineView(for item: SelectedList) -> some View {
        if viewModel.selectedList == item {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.blue)
                .frame(height: 3)
                .padding(.top, 2)
                .matchedGeometryEffect(id: "underline", in: animationNamespace)
        } else {
            Color.clear.frame(height: 3).padding(.top, 2)
        }
    }
}


#Preview {
    let context = TMDatabaseManager.preview.context
    let coordinator = AppCoordinator()
    let networkManager = TMNetworkMonitor.shared
    let authManager = TMAuthManager.shared
    
    let viewModel = TMHomeScreenViewModel(context: context)
    
    NavigationStack {
        TMHomeScreen(viewModel: viewModel)
            .environment(\.managedObjectContext, context)
            .environmentObject(AppCoordinator())
            .environmentObject(TMNetworkMonitor.shared)
            .environmentObject(TMAuthManager.shared)
    }
}
