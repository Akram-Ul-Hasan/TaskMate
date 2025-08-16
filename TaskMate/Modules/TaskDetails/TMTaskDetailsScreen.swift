//
//  TMTaskDetailsScreen.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/13/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI

struct TMTaskDetailsScreen: View {
    @StateObject private var viewModel: TMTaskDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(taskList: TaskList, task: Task) {
        _viewModel = StateObject(wrappedValue: TMTaskDetailsViewModel(taskList: taskList, task: task))

    }
    
    var body: some View {
        VStack{
            taskDetailsContentSection
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        viewModel.toggleStarred()
                    } label: {
                        Image(systemName: taskStarIcon)
                    }
                    
                    Menu {
                        Button("Delete Task", role: .destructive) {
                            viewModel.showDeleteConfirm = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                    }
                }
            }
        }
        .confirmationDialog("Delete this task?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteTask(); dismiss() }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var taskDetailsContentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                viewModel.showListPicker.toggle()
            } label: {
                HStack(spacing: 6) {
                    Text(" ")
                        .font(.callout)
                        .foregroundStyle(.blue)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.top, 4)
            
            
            
            
        }
        .padding()
    }
    
    private var taskStarIcon: String {
        (viewModel.selectedTask.isStarred ?? false) ? "star.fill" : "star"
    }
}

//#Preview {
//    TMTaskDetailsScreen()
//}
