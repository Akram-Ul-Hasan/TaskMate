//
//  TMHomeOptionView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 23/6/25.
//


import SwiftUI

struct TMHomeOptionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSort: SortOption
    
    var onSortSelected: (SortOption) -> Void
    var onRenameList: () -> Void
    var onDeleteList: () -> Void
    var onDeleteAllCompletedTasks: () -> Void
    
    var canDeleteList: Bool
    
    init(
        currentSort: SortOption,
        canDeleteList: Bool,
        onSortSelected: @escaping (SortOption) -> Void,
        onRenameList: @escaping () -> Void,
        onDeleteList: @escaping () -> Void,
        onDeleteAllCompletedTasks: @escaping () -> Void
    ) {
        _selectedSort = State(initialValue: currentSort)
        self.canDeleteList = canDeleteList
        self.onSortSelected = onSortSelected
        self.onRenameList = onRenameList
        self.onDeleteList = onDeleteList
        self.onDeleteAllCompletedTasks = onDeleteAllCompletedTasks
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sort by")
                .font(.headline)
                .padding(.top)
            
            ForEach(SortOption.allCases, id: \.self) { option in
                HStack {
                    Text(option.rawValue)
                    Spacer()
                    if option == selectedSort {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedSort = option
                    onSortSelected(option)
                    dismiss()
                }
            }
            
            Divider()
            
            Button("Rename list") {
                onRenameList()
                dismiss()
            }
            
            Button {
                onDeleteList()
                dismiss()
            } label: {
                Text("Delete List")
            }
            .disabled(!canDeleteList)
            .foregroundColor(canDeleteList ? .blackLevel1 : .gray)
            
            if !canDeleteList {
                Text("Default list can't be deleted")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
            
            
            Button("Delete all completed tasks") {
                onDeleteAllCompletedTasks()
                dismiss()
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .presentationDetents([.medium])
    }
}
