//
//  AddTaskScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 1/7/25.
//

import SwiftUI

struct TMAddTaskSheetView: View {
    
    @EnvironmentObject private var db : TMDatabaseManager
    let taskList: TaskList
    
    @State private var taskTitle = ""
    @State private var taskDetails = ""
    @State private var isStarred = false
    @State private var date: Date? = nil
    @State private var time: Date? = nil
    @State private var repeatType : RepeatType = .noRepeat
    @State private var showTaskDetails = false
    @State private var showDateTimeSheet = false
    
    
    private func saveTask() {
        db.createTask(name: taskTitle, details: taskDetails, date: date, time: time, isStarred: isStarred, starredDate: isStarred ? Date() : nil, taskList: taskList)
    }
    
    var body: some View {
        VStack {
            TextField("New Task", text: $taskTitle)
                .font(.title2.bold())
                .padding(.horizontal)
                .padding(.top)
            
            if showTaskDetails {
                TextField("Add details", text: $taskDetails)
                    .font(.body)
                    .padding(.horizontal)
            }
            
            HStack(spacing: 24) {
                Button {
                    withAnimation { showTaskDetails = true }
                } label: {
                    Image(systemName: "text.alignleft")
                        .foregroundColor(.blue)
                }
                
                Button {
                    showDateTimeSheet = true
                } label: {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                }
                
                
                Button {
                    isStarred.toggle()
                } label: {
                    Image(systemName: isStarred ? "star.fill" : "star")
                        .foregroundColor(isStarred ? .yellow : .gray)
                }
                
                Spacer()
                
                
                Button("Save") {
                    saveTask()
                }
                .disabled(taskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                .font(.headline)
                .padding(.horizontal)
                
            }
            
            .padding(.horizontal)
            
            .sheet(isPresented: $showDateTimeSheet) {
                TMTaskDateTimeSheetView(
                    selectedDate: Binding(
                        get: { date ?? Date() },
                        set: { date = $0 }
                    ),
                    selectedTime: Binding(
                        get: { time ?? Date() },
                        set: { time = $0 }
                    ),
                    repeatOption: $repeatType
                )            }
        }
    }
}

#Preview {
    let taskList = TaskList()
    TMAddTaskSheetView(taskList: taskList)
}
