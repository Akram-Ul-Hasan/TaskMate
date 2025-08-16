//
//  TMTaskDetailsViewModel.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/13/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import Foundation

class TMTaskDetailsViewModel: ObservableObject {
    @Published var selectedTaskList: TaskList
    @Published var taskLists : [TaskList] = []
    @Published var selectedTask: Task
    @Published var showDeleteConfirm = false
    @Published var showListPicker = true
    

    init(taskList: TaskList, task: Task) {
        self.selectedTaskList = taskList
        self.selectedTask = task
    }
    
    func updateTask() {
        
    }
    
    func markAsComplete() {
        
    }
    
    func deleteTask() {
        
    }
    
    func addSubTask() {
        
    }
    
    func toggleStarred() {
        
    }
}
