////
////  temp.swift
////  TaskMate
////
////  Created by Techetron Ventures Ltd on 8/7/25.
////  Copyright © 2025 Akram Ul Hasan. All rights reserved.
////
//
//import Foundation
//
//import SwiftUI
//import CoreData
//import Combine
//
//// MARK: - Home Screen View
//struct HomeScreen: View {
//    
//    // MARK: - Environment & Dependencies
//    @Environment(\.managedObjectContext) private var context
//    @EnvironmentObject var coordinator: TMNavigationCoordinator
//    @EnvironmentObject var networkMonitor: TMNetworkMonitor
//    @EnvironmentObject var authManager: TMAuthManager
//    @EnvironmentObject var taskManager: TMTaskManager
//    
//    // MARK: - Core Data Fetch Request
//    @FetchRequest(
//        entity: TaskList.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TaskList.position, ascending: true)],
//        predicate: NSPredicate(format: "deleteFlag == NO"),
//        animation: .spring(response: 0.4, dampingFraction: 0.8)
//    )
//    private var taskLists: FetchedResults<TaskList>
//    
//    // MARK: - State Management
//    @StateObject private var viewModel: TMHomeScreenViewModel
//    @State private var showingDeleteAlert = false
//    @State private var listToDelete: TaskList?
//    @State private var isRefreshing = false
//    @State private var showingFilterSheet = false
//    
//    // MARK: - Animation Properties
//    @Namespace private var animationNamespace
//    @State private var headerOffset: CGFloat = 0
//    
//    // MARK: - Constants
//    private enum Constants {
//        static let horizontalPadding: CGFloat = 16
//        static let animationDuration: TimeInterval = 0.3
//        static let listSelectorHeight: CGFloat = 60
//        static let cornerRadius: CGFloat = 12
//    }
//    
//    // MARK: - Initializer
//    init(viewModel: TMHomeScreenViewModel) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    // MARK: - Body
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .bottom) {
//                backgroundView
//                
//                VStack(spacing: 0) {
//                    headerSection
//                    
//                    ScrollView {
//                        VStack(spacing: 0) {
//                            listSelectorSection
//                                .background(headerBackgroundView)
//                            
//                            filterAndSortSection
//                            
//                            Divider()
//                                .opacity(headerOffset > 10 ? 1 : 0)
//                                .animation(.easeInOut(duration: 0.2), value: headerOffset > 10)
//                            
//                            taskContentSection
//                                .refreshable {
//                                    await performRefresh()
//                                }
//                        }
//                    }
//                    .coordinateSpace(name: "scroll")
//                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
//                        withAnimation(.easeOut(duration: 0.1)) {
//                            headerOffset = offset
//                        }
//                    }
//                    
//                    bottomActionBar
//                }
//                
//                networkStatusOverlay
//            }
//        }
//        .navigationTitle(TMStrings.Home.title)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar { toolbarContent }
//        .alert("Delete Task List", isPresented: $showingDeleteAlert, presenting: listToDelete) { list in
//            alertActions(for: list)
//        } message: { list in
//            Text("Are you sure you want to delete '\(list.title ?? "Untitled")'? This action cannot be undone.")
//        }
//        .sheet(isPresented: $showingFilterSheet) {
//            filterAndSortSheet
//        }
//        .onAppear {
//            setupInitialState()
//        }
//        .accessibilityElement(children: .contain)
//        .accessibilityLabel("Home Screen")
//    }
//}
//
//// MARK: - View Components
//private extension TMHomeScreen {
//    
//    var backgroundView: some View {
//        Color(.systemGroupedBackground)
//            .ignoresSafeArea()
//    }
//    
//    var headerBackgroundView: some View {
//        Color(.systemBackground)
//            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
//            .opacity(headerOffset > 5 ? 1 : 0)
//            .animation(.easeInOut(duration: 0.2), value: headerOffset > 5)
//    }
//    
//    var headerSection: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Good \(timeBasedGreeting())")
//                    .font(.title2.weight(.semibold))
//                    .foregroundColor(.primary)
//                
//                if let userName = authManager.currentUser?.displayName {
//                    Text(userName)
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                } else {
//                    Text("Welcome back!")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//            
//            Spacer()
//            
//            taskSummaryView
//        }
//        .padding(.horizontal, Constants.horizontalPadding)
//        .padding(.vertical, 12)
//        .background(Color(.systemBackground))
//    }
//    
//    var taskSummaryView: some View {
//        VStack(alignment: .trailing, spacing: 2) {
//            Text("\(completedTasksToday)")
//                .font(.title3.weight(.bold))
//                .foregroundColor(.green)
//            
//            Text("completed today")
//                .font(.caption2)
//                .foregroundColor(.secondary)
//        }
//        .accessibilityElement(children: .combine)
//        .accessibilityLabel("\(completedTasksToday) tasks completed today")
//    }
//    
//    var listSelectorSection: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            ScrollViewReader { proxy in
//                HStack(spacing: 20) {
//                    starredListButton
//                    
//                    ForEach(taskLists) { list in
//                        taskListButton(for: list)
//                    }
//                    
//                    newListButton
//                }
//                .padding(.horizontal, Constants.horizontalPadding)
//                .padding(.vertical, 16)
//                .onChange(of: viewModel.selectedList) { newSelection in
//                    withAnimation(.easeInOut(duration: Constants.animationDuration)) {
//                        if case .taskList(let list) = newSelection {
//                            proxy.scrollTo(list.id, anchor: .center)
//                        }
//                    }
//                }
//            }
//        }
//        .accessibilityElement(children: .contain)
//        .accessibilityLabel("Task list selector")
//    }
//    
//    var filterAndSortSection: some View {
//        if case .taskList = viewModel.selectedList {
//            HStack {
//                Spacer()
//                
//                Menu {
//                    Picker("Sort", selection: $viewModel.selectedSort) {
//                        ForEach(TMSortOption.allCases, id: \.self) { option in
//                            Label(option.title, systemImage: option.icon)
//                                .tag(option)
//                        }
//                    }
//                } label: {
//                    HStack(spacing: 4) {
//                        Text("Sort")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        Image(systemName: "arrow.up.arrow.down")
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color(.tertiarySystemFill))
//                    .clipShape(Capsule())
//                }
//                
//                Menu {
//                    Picker("Filter", selection: $taskManager.currentFilter) {
//                        ForEach(TMTaskFilter.allCases, id: \.self) { filter in
//                            Label(filter.title, systemImage: filter.icon)
//                                .tag(filter)
//                        }
//                    }
//                } label: {
//                    HStack(spacing: 4) {
//                        Text("Filter")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color(.tertiarySystemFill))
//                    .clipShape(Capsule())
//                }
//            }
//            .padding(.horizontal, Constants.horizontalPadding)
//            .padding(.vertical, 8)
//        }
//    }
//    
//    var starredListButton: some View {
//        Button(action: { selectList(.starred) }) {
//            VStack(spacing: 6) {
//                HStack(spacing: 6) {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(viewModel.selectedList == .starred ? .yellow : .gray)
//                        .scaleEffect(viewModel.selectedList == .starred ? 1.1 : 1.0)
//                    
//                    Text("Starred")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(viewModel.selectedList == .starred ? .primary : .secondary)
//                }
//                
//                underlineView(for: .starred)
//            }
//            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.selectedList)
//        }
//        .buttonStyle(ScaleButtonStyle())
//        .accessibilityLabel("Starred tasks")
//        .accessibilityHint("Shows all starred tasks")
//    }
//    
//    func taskListButton(for list: TaskList) -> some View {
//        let currentSelection = SelectedList.taskList(list)
//        let isSelected = viewModel.selectedList == currentSelection
//        let taskCount = taskManager.filteredTasks(for: list.id ?? "").count
//        
//        return Button(action: { selectList(currentSelection) }) {
//            VStack(spacing: 6) {
//                HStack(spacing: 8) {
//                    Circle()
//                        .fill(Color(hex: list.color ?? "#007AFF"))
//                        .frame(width: 8, height: 8)
//                        .scaleEffect(isSelected ? 1.2 : 1.0)
//                    
//                    Text(list.title ?? "Untitled")
//                        .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
//                        .foregroundColor(isSelected ? .primary : .secondary)
//                        .lineLimit(1)
//                    
//                    if taskCount > 0 {
//                        Text("(\(taskCount))")
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                
//                underlineView(for: currentSelection)
//            }
//            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
//        }
//        .buttonStyle(ScaleButtonStyle())
//        .contextMenu {
//            contextMenuContent(for: list)
//        }
//        .accessibilityLabel("\(list.title ?? "Untitled") task list")
//        .accessibilityHint("Contains \(taskCount) tasks")
//        .id(list.objectID)
//    }
//    
//    var newListButton: some View {
//        Button(action: { coordinator.push(.newTaskList) }) {
//            VStack(spacing: 6) {
//                HStack(spacing: 6) {
//                    Image(systemName: "plus.circle")
//                        .foregroundColor(.blue)
//                    
//                    Text("New List")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.blue)
//                }
//                
//                Color.clear.frame(height: 3)
//            }
//        }
//        .buttonStyle(ScaleButtonStyle())
//        .accessibilityLabel("Create new task list")
//        .accessibilityHint("Tap to add a new task list")
//    }
//    
//    var taskContentSection: some View {
//        LazyVStack(spacing: 0) {
//            if taskManager.searchText.isEmpty && viewModel.filteredTasks.isEmpty {
//                emptyStateView
//            } else if !taskManager.searchText.isEmpty && viewModel.filteredTasks.isEmpty {
//                searchEmptyStateView
//            } else {
//                taskListContent
//            }
//        }
//        .padding(.top, 20)
//        .background(
//            ScrollOffsetReader()
//        )
//    }
//    
//    var emptyStateView: some View {
//        VStack(spacing: 24) {
//            Image(systemName: viewModel.selectedList == .starred ? "star" : "checklist")
//                .font(.system(size: 60))
//                .foregroundColor(.gray.opacity(0.6))
//            
//            VStack(spacing: 8) {
//                Text(emptyStateTitle)
//                    .font(.title3.weight(.semibold))
//                    .foregroundColor(.primary)
//                
//                Text(emptyStateSubtitle)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, 32)
//            }
//            
//            if case .taskList(let list) = viewModel.selectedList {
//                Button(action: { addNewTask(to: list) }) {
//                    Label("Add Your First Task", systemImage: "plus")
//                        .font(.subheadline.weight(.medium))
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 24)
//                        .padding(.vertical, 12)
//                        .background(Color.blue)
//                        .clipShape(Capsule())
//                }
//                .buttonStyle(ScaleButtonStyle())
//            }
//        }
//        .frame(maxWidth: .infinity, minHeight: 300)
//        .accessibilityElement(children: .combine)
//        .accessibilityLabel("\(emptyStateTitle). \(emptyStateSubtitle)")
//    }
//    
//    var searchEmptyStateView: some View {
//        VStack(spacing: 16) {
//            Image(systemName: "magnifyingglass")
//                .font(.system(size: 40))
//                .foregroundColor(.gray.opacity(0.6))
//            
//            Text("No results for \"\(taskManager.searchText)\"")
//                .font(.headline)
//                .foregroundColor(.primary)
//            
//            Text("Try adjusting your search or filter")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity, minHeight: 200)
//    }
//    
//    var taskListContent: some View {
//        LazyVStack(spacing: 12) {
//            ForEach(viewModel.filteredTasks, id: \.objectID) { task in
//                TMHomeTaskRowView(
//                    task: task,
//                    onToggleStar: { toggleTaskStar(task) },
//                    onToggleComplete: { toggleTaskCompletion(task) },
//                    onDelete: { deleteTask(task) },
//                    onEdit: { editTask(task) }
//                )
//                .transition(.asymmetric(
//                    insertion: .opacity.combined(with: .move(edge: .top)),
//                    removal: .opacity.combined(with: .move(edge: .leading))
//                ))
//            }
//        }
//        .padding(.horizontal, Constants.horizontalPadding)
//        .padding(.bottom, 100) // Space for bottom bar
//        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.filteredTasks.count)
//    }
//    
//    var bottomActionBar: some View {
//        TMHomeBottomView(
//            onMenuTap: showListSelector,
//            onAddTaskTap: addNewTask,
//            onMoreTap: showMoreOptions,
//            onSearchTap: showSearch
//        )
//        .background(
//            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
//                .fill(.ultraThinMaterial)
//                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
//        )
//        .padding(.horizontal, Constants.horizontalPadding)
//        .padding(.bottom, 8)
//    }
//    
//    var networkStatusOverlay: some View {
//        VStack {
//            if !networkMonitor.isConnected {
//                TMOfflineBanner()
//                    .transition(.move(edge: .top).combined(with: .opacity))
//            }
//            
//            Spacer()
//        }
//        .animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)
//    }
//    
//    var filterAndSortSheet: some View {
//        NavigationView {
//            VStack(spacing: 24) {
//                // Filter Section
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Filter Tasks")
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                    
//                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
//                        ForEach(TMTaskFilter.allCases, id: \.self) { filter in
//                            FilterButton(
//                                filter: filter,
//                                isSelected: taskManager.currentFilter == filter
//                            ) {
//                                taskManager.currentFilter = filter
//                            }
//                        }
//                    }
//                }
//                
//                Divider()
//                
//                // Sort Section
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Sort Tasks")
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                    
//                    VStack(spacing: 8) {
//                        ForEach(TMSortOption.allCases, id: \.self) { option in
//                            SortButton(
//                                option: option,
//                                isSelected: viewModel.selectedSort == option
//                            ) {
//                                viewModel.selectedSort = option
//                            }
//                        }
//                    }
//                }
//                
//                Spacer()
//            }
//            .padding(24)
//            .navigationTitle("Filter & Sort")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden()
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Done") {
//                        showingFilterSheet = false
//                    }
//                }
//            }
//        }
//        .presentationDetents([.medium])
//    }
//    
//    @ViewBuilder
//    func underlineView(for item: SelectedList) -> some View {
//        if viewModel.selectedList == item {
//            RoundedRectangle(cornerRadius: 2)
//                .fill(Color.blue)
//                .frame(height: 3)
//                .matchedGeometryEffect(id: "underline", in: animationNamespace)
//        } else {
//            Color.clear.frame(height: 3)
//        }
//    }
//    
//    @ToolbarContentBuilder
//    var toolbarContent: some ToolbarContent {
//        ToolbarItem(placement: .topBarTrailing) {
//            Button(action: { coordinator.presentSheet(.userProfile) }) {
//                AsyncImage(url: authManager.photoURL) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                } placeholder: {
//                    Image(systemName: "person.crop.circle.fill")
//                        .foregroundColor(.gray)
//                }
//                .frame(width: 32, height: 32)
//                .clipShape(Circle())
//            }
//            .accessibilityLabel("User profile")
//        }
//        
//        ToolbarItem(placement: .topBarLeading) {
//            Button(action: { showingFilterSheet = true }) {
//                Image(systemName: "line.3.horizontal.decrease.circle")
//                    .foregroundColor(taskManager.currentFilter != .all ? .blue : .gray)
//            }
//            .accessibilityLabel("Filter and sort tasks")
//        }
//    }
//    
//    @ViewBuilder
//    func contextMenuContent(for list: TaskList) -> some View {
//        Button(action: { coordinator.push(.editTaskList(list)) }) {
//            Label("Edit", systemImage: "pencil")
//        }
//        
//        Button(action: { shareTaskList(list) }) {
//            Label("Share", systemImage: "square.and.arrow.up")
//        }
//        
//        Divider()
//        
//        Button(role: .destructive, action: { confirmDelete(list) }) {
//            Label("Delete", systemImage: "trash")
//        }
//    }
//    
//    func alertActions(for list: TaskList) -> some View {
//        Group {
//            Button("Cancel", role: .cancel) { }
//            
//            Button("Delete", role: .destructive) {
//                deleteTaskList(list)
//            }
//        }
//    }
//}
//
//// MARK: - Helper Methods
//private extension TMHomeScreen {
//    
//    var completedTasksToday: Int {
//        let today = Calendar.current.startOfDay(for: Date())
//        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
//        
//        return taskManager.tasks.filter { task in
//            guard let completedDate = task.completedDate else { return false }
//            return completedDate >= today && completedDate < tomorrow
//        }.count
//    }
//    
//    func timeBasedGreeting() -> String {
//        let hour = Calendar.current.component(.hour, from: Date())
//        switch hour {
//        case 0..<12: return "Morning"
//        case 12..<17: return "Afternoon"
//        default: return "Evening"
//        }
//    }
//    
//    var emptyStateTitle: String {
//        switch viewModel.selectedList {
//        case .starred:
//            return "No Starred Tasks"
//        case .taskList(let list):
//            return "No Tasks in \(list.title ?? "List")"
//        }
//    }
//    
//    var emptyStateSubtitle: String {
//        switch viewModel.selectedList {
//        case .starred:
//            return "Star important tasks to see them here"
//        case .taskList:
//            return "Add your first task to get started with organizing your work"
//        }
//    }
//    
//    func setupInitialState() {
//        if taskLists.isEmpty {
//            // Will trigger default list creation in TaskManager
//        } else if case .starred = viewModel.selectedList {
//            // Keep starred selection
//        } else if taskLists.first(where: { !$0.isDeleted }) != nil {
//            // Select first available list if current selection is invalid
//            if case .taskList(let currentList) = viewModel.selectedList {
//                if currentList.isDeleted {
//                    viewModel.selectedList = .taskList(taskLists.first!)
//                }
//            }
//        }
//    }
//    
//    func selectList(_ list: SelectedList) {
//        HapticFeedback.selectionChanged()
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//            viewModel.selectedList = list
//        }
//        
//        // Update task manager's selected list for filtering
//        if case .taskList(let taskList) = list {
//            taskManager.selectedListId = taskList.id
//        }
//    }
//    
//    func addNewTask(to list: TaskList? = nil) {
//        HapticFeedback.impact(.medium)
//        
//        let targetList: TaskList?
//        if let list = list {
//            targetList = list
//        } else if case .taskList(let selectedList) = viewModel.selectedList {
//            targetList = selectedList
//        } else {
//            targetList = taskLists.first
//        }
//        
//        guard let list = targetList else { return }
//        coordinator.presentSheet(.newTask(taskList: list))
//    }
//    
//    func addNewTask() {
//        addNewTask(to: nil)
//    }
//    
//    func showListSelector() {
//        HapticFeedback.impact(.light)
//        let sheetHeight = CGFloat((taskLists.count + 1) * Int(Constants.listSelectorHeight))
//        coordinator.presentSheet(.listSelector(sheetHeight: sheetHeight))
//    }
//    
//    func showMoreOptions() {
//        HapticFeedback.impact(.light)
//        coordinator.presentSheet(.listOptions)
//    }
//    
//    func showSearch() {
//        HapticFeedback.impact(.light)
//        coordinator.presentSheet(.search)
//    }
//    
//    func toggleTaskStar(_ task: Task) {
//        HapticFeedback.impact(.light)
//        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//            task.isStarred.toggle()
//            task.starredDate = task.isStarred ? Date() : nil
//            try? context.save()
//        }
//    }
//    
//    func toggleTaskCompletion(_ task: Task) {
//        HapticFeedback.success()
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//            taskManager.toggleTask(task)
//        }
//    }
//    
//    func deleteTask(_ task: Task) {
//        HapticFeedback.success()
//        withAnimation(.easeInOut(duration: 0.3)) {
//            taskManager.deleteTask(task)
//        }
//    }
//    
//    func editTask(_ task: Task) {
//        HapticFeedback.impact(.medium)
//        coordinator.presentSheet(.editTask(task))
//    }
//    
//    func confirmDelete(_ list: TaskList) {
//        listToDelete = list
//        showingDeleteAlert = true
//    }
//    
//    func deleteTaskList(_ list: TaskList) {
//        HapticFeedback.success()
//        withAnimation(.easeInOut(duration: 0.3)) {
//            taskManager.deleteTaskList(list)
//        }
//    }
//    
//    func shareTaskList(_ list: TaskList) {
//        HapticFeedback.impact(.medium)
//        coordinator.presentSheet(.shareTaskList(list))
//    }
//    
//    @MainActor
//    func performRefresh() async {
//        isRefreshing = true
//        HapticFeedback.impact(.light)
//        
//        // Simulate network refresh
//        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
//        
//        // Refresh data from TaskManager
//        taskManager.objectWillChange.send()
//        
//        isRefreshing = false
//    }
//}
//
//// MARK: - Supporting Views
//struct FilterButton: View {
//    let filter: TMTaskFilter
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 8) {
//                Image(systemName: filter.icon)
//                    .font(.title2)
//                    .foregroundColor(isSelected ? .white : .blue)
//                
//                Text(filter.title)
//                    .font(.caption)
//                    .foregroundColor(isSelected ? .white : .blue)
//            }
//            .frame(maxWidth: .infinity, minHeight: 60)
//            .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//        }
//        .buttonStyle(ScaleButtonStyle())
//    }
//}
//
//struct SortButton: View {
//    let option: TMSortOption
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: option.icon)
//                    .foregroundColor(isSelected ? .blue : .gray)
//                
//                Text(option.title)
//                    .foregroundColor(.primary)
//                
//                Spacer()
//                
//                if isSelected {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding(.vertical, 12)
//            .padding(.horizontal, 16)
//            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// MARK: - Extensions
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}
//
//// MARK: - Supporting Views and Utilities (from previous artifact)
//struct ScaleButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
//    }
//}
//
//struct ScrollOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//struct ScrollOffsetReader: View {
//    var body: some View {
//        GeometryReader { geometry in
//            Color.clear
//                .preference(
//                    key: ScrollOffsetPreferenceKey.self,
//                    value: geometry.frame(in: .named("scroll")).minY
//                )
//        }
//        .frame(height: 0)
//    }
//}
//
//enum HapticFeedback {
//    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
//        UIImpactFeedbackGenerator(style: style).impactOccurred()
//    }
//    
//    static func selectionChanged() {
//        UISelectionFeedbackGenerator().selectionChanged()
//    }
//    
//    static func success() {
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
//    }
//    
//    static func error() {
//        UINotificationFeedbackGenerator().notificationOccurred(.error)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    let context = TMDatabaseManager.preview.context
//    let viewModel = TMHomeScreenViewModel(context: context)
//    
//    NavigationStack {
//        TMHomeScreen(viewModel: viewModel)
//            .environment(\.managedObjectContext, context)
//            .environmentObject(TMNavigationCoordinator())
//            .environmentObject(TMNetworkMonitor.shared)
//            .environmentObject(TMAuthManager.shared)
//            .environmentObject(TMTaskManager())
//    }
//}
