//
//  TMHomeScreenSideBarMenu.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/11/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI

struct TMHomeScreenSideBarMenu: View {
    @Binding var selectedSortOption: TMSortOption
    @Binding var isShowingSideBar: Bool
    let onRename: () -> Void
    let onDeleteList: () -> Void
    let onDeleteCompletedTask: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sort by")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            
            ForEach(TMSortOption.allCases, id: \.self) { option in
                Button {
                    selectedSortOption = option
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    HStack {
                        Text(option.title)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedSortOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        selectedSortOption == option ?
                        Color.blue.opacity(0.1) : Color.clear
                    )
                }
            }
            
            Divider()
                .frame(height: 1.5)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            
            
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    onRename()
                    isShowingSideBar = false
                } label: {
                    Text("Rename List")
                        .font(.body)
                        .foregroundColor(.blackLevel1)
                }
                
                Button {
                    onDeleteList()
                    isShowingSideBar = false
                } label: {
                    Text("Delete List")
                        .font(.body)
                        .foregroundStyle(.blackLevel1)
                    
                }
                
                Button {
                    onDeleteCompletedTask()
                    isShowingSideBar = false
                } label: {
                    Text("Delete All completed tasks")
                        .font(.body)
                        .foregroundStyle(.blackLevel1)
                }
            }
            
            //            Spacer()
        }
        .padding(20)
        //        .frame(width: UIScreen.main.bounds.width * 0.6)
        .background(.whiteLevel1)
        //        .edgesIgnoringSafeArea(.bottom)
    }
}

