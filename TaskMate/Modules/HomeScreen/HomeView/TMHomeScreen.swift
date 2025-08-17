//
//  TMHomeScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import SwiftUI
import CoreData

struct TMHomeScreen: View {
    
    @StateObject private var viewModel: TMHomeScreenViewModel
    
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject var coordinator: TMNavigationCoordinator
    @EnvironmentObject var networkMonitor: TMNetworkMonitor
    @EnvironmentObject var authManager: TMAuthManager
    @EnvironmentObject var taskManager: TMTaskManager
    
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskList.position, ascending: true)],
        predicate: NSPredicate(format: "deleteFlag == NO"),
        animation: .spring(response: 0.4, dampingFraction: 0.8)
    )
    private var taskLists: FetchedResults<TaskList>
    
    @State private var showingDeleteAlert = false
    @State private var listToDelete: TaskList?
    @State private var isRefreshing = false
    @State private var isShowingSidebar = false
    
    @Namespace private var animationNamespace
    @State private var headerOffset: CGFloat = 0
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
        static let listSelectorHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 12
    }
    
    init(viewModel: TMHomeScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                listSelectorSection
                
                Divider()
                
                taskContentSection
            }
            
            GeometryReader { _ in
                HStack {
                    Spacer()
                    
                    TMHomeScreenSideBarMenu(selectedSortOption: $viewModel.selectedSort, isShowingSideBar: $isShowingSidebar, onRename: navigateToRenameList, onDeleteList: viewModel.deleteList, onDeleteCompletedTask: viewModel.deleteCompletedTasks)
                        .offset(x: isShowingSidebar ? UIScreen.main.bounds.width * 0.4 : UIScreen.main.bounds.width)
                        .animation(.easeInOut(duration: 0.3), value: isShowingSidebar)
                }
                
            }
            .background(Color.black.opacity(isShowingSidebar ? 0.5 : 0))
            
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        coordinator.presentSheet(.newTask(listID: viewModel.selectedTaskList?.id))
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .disabled((viewModel.selectedTaskList != nil) == false)
                    .padding(.trailing, 50)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationTitle(TMStrings.Home.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowingSidebar.toggle()
                    }
                    
                } label: {
                    if isShowingSidebar {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundColor(.blackLevel1)
                    } else {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.subheadline)
                            .foregroundColor(.blackLevel1)
                    }
                }
                
            }
        }
    }
    
    private var listSelectorSection: some View {
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
                        underlineView(for: TMSelectedList.starred)
                    }
                }
                
                ForEach(taskLists) { list in
                    let current = TMSelectedList.taskList(taskList: list)
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
                    coordinator.push(.addOrEditTaskList(screenType: .create))
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
    
    private var taskContentSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.filteredTasks.isEmpty {
                    TMEmptyView(imageName: TMImages.emptyTask, title: TMStrings.Home.emptyTaskTitle, subtitle: TMStrings.Home.emptyTaskDescription)
                } else {
                    ForEach(viewModel.filteredTasks) { task in
                        TMHomeTaskRowView(task: task, onToggleStar: {
                            viewModel.toggleStarred(task)
                        }, onToggleComplete: {
                            viewModel.markTaskAsCompleted(task)
                        })
                        .onTapGesture {
                            navigateToTaskDetails(task: task)
                        }
                        
                    }
                }
            }
            .padding()
        }
    }
    
    private func navigateToRenameList() {
        if let list = viewModel.selectedTaskList {
            coordinator.push(.addOrEditTaskList(screenType: .edit(list)))
        }
    }
    
    private func navigateToTaskDetails(task: Task) {
        if let list = viewModel.selectedTaskList {
            coordinator.push(.taskDetails(taskList: list, task: task))
        }
    }
    
    @ViewBuilder
    private func underlineView(for item: TMSelectedList) -> some View {
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
    let coordinator = TMNavigationCoordinator()
    let networkManager = TMNetworkMonitor.shared
    let authManager = TMAuthManager.shared
    
    let viewModel = TMHomeScreenViewModel(context: context, taskManager: TMTaskManager())
    
    NavigationStack {
        TMHomeScreen(viewModel: viewModel)
            .environment(\.managedObjectContext, context)
            .environmentObject(TMNavigationCoordinator())
            .environmentObject(TMNetworkMonitor.shared)
            .environmentObject(TMAuthManager.shared)
    }
}
