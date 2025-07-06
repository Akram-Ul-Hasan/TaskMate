//
//  TMHomeOptionView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 23/6/25.
//


import SwiftUI

enum SortOption: String, CaseIterable {
    case alphabetical = "A–Z"
    case date = "Date"
    case starred = "Starred recently"
}

struct TMHomeOptionView: View {
    @State private var selectedSort: SortOption = .date

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
                }
            }

            Divider()

            Button("Rename list") {
                // Handle rename action
            }

            Button("Delete list") {
                // Handle delete action
            }
            .disabled(true) // Example: default list can't be deleted
            .foregroundColor(.gray)

            Text("Default list can't be deleted")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading)

            Button("Delete all completed tasks") {
                // Handle deletion
            }

            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .presentationDetents([.medium])
    }
}

#Preview {
    TMHomeOptionView()
}
