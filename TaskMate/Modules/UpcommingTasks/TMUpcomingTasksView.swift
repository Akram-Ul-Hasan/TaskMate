//
//  TMUpcomingTasksView.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/9/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//
import SwiftUI

struct TMUpcomingTasksView: View {
    @EnvironmentObject var taskManager: TMTaskManager
    @State private var showCompleted = false
        
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    headerView
                        .padding(.bottom, 20)
                
                    timelineView
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Upcoming Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCompleted.toggle() }) {
                        Image(systemName: showCompleted ? "eye.slash" : "eye")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        
        // MARK: - Header View
        private var headerView: some View {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Schedule")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(summaryText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Progress ring or stats
                    progressView
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
        }
        
        private var progressView: some View {
            let totalTasks = todayTasks.count
            let completedTasks = todayTasks.filter { $0.isCompleted }.count
            let progress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
            
            return ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 6)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)
                
                Text("\(completedTasks)/\(totalTasks)")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
        }
        
        // MARK: - Timeline View
        private var timelineView: some View {
            VStack(spacing: 0) {
                // Overdue (if any)
                if !overdueTasks.isEmpty {
                    TimelineSection(
                        period: "Overdue",
                        date: "",
                        tasks: overdueTasks,
                        color: .red,
                        icon: "exclamationmark.triangle.fill",
                        showCompleted: showCompleted,
                        taskManager: taskManager,
                        isFirst: true
                    )
                }
                
                // Today
                TimelineSection(
                    period: "Today",
                    date: formatDate(Date(), style: .today),
                    tasks: todayTasks,
                    color: .blue,
                    icon: "sun.max.fill",
                    showCompleted: showCompleted,
                    taskManager: taskManager,
                    isFirst: overdueTasks.isEmpty
                )
                
                // Tomorrow
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                    TimelineSection(
                        period: "Tomorrow",
                        date: formatDate(tomorrow, style: .tomorrow),
                        tasks: tomorrowTasks,
                        color: .green,
                        icon: "sunrise.fill",
                        showCompleted: showCompleted,
                        taskManager: taskManager
                    )
                }
                
                // Rest of this week
                ForEach(restOfWeekDays, id: \.self) { date in
                    let dayTasks = tasksForDate(date)
                    if !dayTasks.isEmpty || showCompleted {
                        TimelineSection(
                            period: formatDate(date, style: .weekday),
                            date: formatDate(date, style: .date),
                            tasks: dayTasks,
                            color: .orange,
                            icon: "calendar",
                            showCompleted: showCompleted,
                            taskManager: taskManager
                        )
                    }
                }
                
                // Next week
                if !nextWeekTasks.isEmpty || showCompleted {
                    TimelineSection(
                        period: "Next Week",
                        date: formatWeekRange(),
                        tasks: nextWeekTasks,
                        color: .purple,
                        icon: "calendar.badge.plus",
                        showCompleted: showCompleted,
                        taskManager: taskManager
                    )
                }
                
                // Later
                if !laterTasks.isEmpty || showCompleted {
                    TimelineSection(
                        period: "Later",
                        date: "After next week",
                        tasks: laterTasks,
                        color: .gray,
                        icon: "calendar.badge.clock",
                        showCompleted: showCompleted,
                        taskManager: taskManager
                    )
                }
                
                Spacer(minLength: 100)
            }
        }
        
        // MARK: - Computed Properties
        private var allUpcomingTasks: [Task] {
            taskManager.tasks.filter { task in
                !task.isDeleted && task.parentId == nil && task.dueDate != nil
            }
        }
        
        private var overdueTasks: [Task] {
            let now = Date()
            return allUpcomingTasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate < Calendar.current.startOfDay(for: now) && !task.isCompleted
            }.sorted { $0.dueDate! < $1.dueDate! }
        }
        
        private var todayTasks: [Task] {
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            
            return allUpcomingTasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate >= today && dueDate < tomorrow
            }.sorted(by: taskSort)
        }
        
        private var tomorrowTasks: [Task] {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            let dayAfter = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow)!
            
            return allUpcomingTasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate >= Calendar.current.startOfDay(for: tomorrow) && dueDate < dayAfter
            }.sorted(by: taskSort)
        }
        
        private var restOfWeekDays: [Date] {
            let calendar = Calendar.current
            let today = Date()
            var days: [Date] = []
            
            // Get the remaining days of this week (day after tomorrow onwards)
            for i in 2..<7 {
                if let date = calendar.date(byAdding: .day, value: i, to: today),
                   calendar.isDate(date, equalTo: today, toGranularity: .weekOfYear) {
                    days.append(date)
                }
            }
            
            return days
        }
        
        private var nextWeekTasks: [Task] {
            let calendar = Calendar.current
            let today = Date()
            
            // Start of next week
            guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: today),
                  let startOfNextWeek = calendar.dateInterval(of: .weekOfYear, for: nextWeek)?.start,
                  let endOfNextWeek = calendar.dateInterval(of: .weekOfYear, for: nextWeek)?.end else {
                return []
            }
            
            return allUpcomingTasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate >= startOfNextWeek && dueDate < endOfNextWeek
            }.sorted(by: taskSort)
        }
        
        private var laterTasks: [Task] {
            let calendar = Calendar.current
            let today = Date()
            
            // Two weeks from now
            guard let twoWeeksLater = calendar.date(byAdding: .weekOfYear, value: 2, to: today) else {
                return []
            }
            
            return allUpcomingTasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate >= twoWeeksLater
            }.sorted(by: taskSort)
        }
        
        private func tasksForDate(_ date: Date) -> [Task] {
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            return allUpcomingTasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate >= startOfDay && dueDate < endOfDay
            }.sorted(by: taskSort)
        }
        
        private func taskSort(_ task1: Task, _ task2: Task) -> Bool {
            // Incomplete tasks first
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted
            }
            
            // Then by priority
            if task1.priority != task2.priority {
                return task1.priority > task2.priority
            }
            
            // Finally by due time
            if let date1 = task1.dueDate, let date2 = task2.dueDate {
                return date1 < date2
            }
            
            return false
        }
        
        private var summaryText: String {
            let totalUpcoming = allUpcomingTasks.filter { !$0.isCompleted }.count
            let todayCount = todayTasks.filter { !$0.isCompleted }.count
            let overdueCount = overdueTasks.count
            
            if overdueCount > 0 {
                return "\(overdueCount) overdue, \(todayCount) due today"
            } else if todayCount > 0 {
                return "\(todayCount) tasks due today, \(totalUpcoming) total upcoming"
            } else {
                return "\(totalUpcoming) upcoming tasks"
            }
        }
        
        // MARK: - Date Formatting
        enum DateStyle {
            case today, tomorrow, weekday, date
        }
        
        private func formatDate(_ date: Date, style: DateStyle) -> String {
            let formatter = DateFormatter()
            
            switch style {
            case .today:
                return "Today, \(formatter.string(from: date))"
            case .tomorrow:
                formatter.dateFormat = "EEEE, MMM d"
                return formatter.string(from: date)
            case .weekday:
                formatter.dateFormat = "EEEE"
                return formatter.string(from: date)
            case .date:
                formatter.dateFormat = "MMM d"
                return formatter.string(from: date)
            }
        }
        
        private func formatWeekRange() -> String {
            let calendar = Calendar.current
            let today = Date()
            
            guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: today),
                  let startOfNextWeek = calendar.dateInterval(of: .weekOfYear, for: nextWeek)?.start,
                  let endOfNextWeek = calendar.date(byAdding: .day, value: -1, to: calendar.dateInterval(of: .weekOfYear, for: nextWeek)?.end ?? Date()) else {
                return ""
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            
            return "\(formatter.string(from: startOfNextWeek)) - \(formatter.string(from: endOfNextWeek))"
        }
    }

    // MARK: - Timeline Section Component
    struct TimelineSection: View {
        let period: String
        let date: String
        let tasks: [Task]
        let color: Color
        let icon: String
        let showCompleted: Bool
        let taskManager: TMTaskManager
        var isFirst: Bool = false
        
        private var visibleTasks: [Task] {
            showCompleted ? tasks : tasks.filter { !$0.isCompleted }
        }
        
        var body: some View {
            VStack(spacing: 0) {
                // Timeline connector (except for first section)
                if !isFirst {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 2, height: 20)
                        .padding(.leading, 35)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Section content
                HStack(alignment: .top, spacing: 0) {
                    // Timeline dot and line
                    VStack(spacing: 0) {
                        // Timeline dot
                        ZStack {
                            Circle()
                                .fill(color.opacity(0.2))
                                .frame(width: 24, height: 24)
                            
                            Image(systemName: icon)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(color)
                        }
                        
                        // Timeline line (if not last section)
                        if !visibleTasks.isEmpty {
                            Rectangle()
                                .fill(Color(.systemGray4))
                                .frame(width: 2)
                                .frame(minHeight: CGFloat(visibleTasks.count * 60))
                        }
                    }
                    .padding(.leading, 24)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 0) {
                        // Section header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(period)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                if !date.isEmpty {
                                    Text(date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            if !tasks.isEmpty {
                                let incompleteTasks = tasks.filter { !$0.isCompleted }.count
                                let totalTasks = tasks.count
                                
                                Text("\(incompleteTasks)/\(totalTasks)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(color.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        
                        // Tasks
                        if visibleTasks.isEmpty && !showCompleted && tasks.filter({ $0.isCompleted }).count > 0 {
                            Text("All tasks completed! 🎉")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                        } else if visibleTasks.isEmpty {
                            Text("No tasks scheduled")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(visibleTasks, id: \.objectID) { task in
                                    TimelineTaskRow(task: task, taskManager: taskManager)
                                    
                                    if task != visibleTasks.last {
                                        Divider()
                                            .padding(.leading, 52)
                                    }
                                }
                            }
                            .padding(.bottom, 16)
                        }
                    }
                    .padding(.leading, 16)
                }
            }
        }
    }

    // MARK: - Timeline Task Row
    struct TimelineTaskRow: View {
        @ObservedObject var task: Task
        let taskManager: TMTaskManager
        
        var body: some View {
            HStack(spacing: 12) {
                // Completion toggle
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        taskManager.toggleTaskASComplete(task)
                    }
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(task.isCompleted ? .green : Color(.systemGray2))
                }
                .buttonStyle(PlainButtonStyle())
                
                // Task details
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title ?? "Untitled Task")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted)
                    
                    HStack(spacing: 12) {
                        // Due time
                        if let dueDate = task.dueDate {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                Text(formatTime(dueDate))
                                    .font(.caption2)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        // Priority
                        if task.priority > 1 {
                            HStack(spacing: 2) {
                                Image(systemName: "flag.fill")
                                    .font(.system(size: 10))
                                Text(priorityText(Int(task.priority)))
                                    .font(.caption2)
                            }
                            .foregroundColor(priorityColor(Int(task.priority)))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .opacity(task.isCompleted ? 0.6 : 1.0)
        }
        
        private func formatTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        private func priorityText(_ priority: Int) -> String {
            switch priority {
            case 3: return "High"
            case 2: return "Medium"
            default: return "Low"
            }
        }
        
        private func priorityColor(_ priority: Int) -> Color {
            switch priority {
            case 3: return .red
            case 2: return .orange
            default: return .blue
            }
        }
    }

    #Preview {
        TMUpcomingTasksView()
            .environmentObject(TMTaskManager())
    }
