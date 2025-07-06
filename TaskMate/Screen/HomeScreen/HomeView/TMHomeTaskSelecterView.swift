//
//  TMHomeAddTaskMenuView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 23/6/25.
//

import SwiftUI

struct TMHomeTaskSelecterView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Starred Section
            HStack {
                Image(systemName: "star.fill")
                Text("Starred")
            }
            .padding(.horizontal)
            
            //Task Lists
//            ForEach(taskLists) { list in
//                HStack {
//                    Text(list.title)
//                        .foregroundColor(.blue)
//                    Spacer()
//                }
//                .padding()
//                .background(
//                    selectedListId == list.id ? Color.blue.opacity(0.1) : Color.clear
//                )
//                .cornerRadius(12)
//                .onTapGesture {
//                    selectedListId = list.id
//                }
//            }
            
            Divider()
            
            // Create New List
            HStack {
                Image(systemName: "plus")
                Text("Create new list")
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .onTapGesture {
                // Handle creation action
            }
        }
        .padding(.top, 20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
        .presentationDetents([.medium])
        
    }
}
        

#Preview {
    TMHomeTaskSelecterView()
}
