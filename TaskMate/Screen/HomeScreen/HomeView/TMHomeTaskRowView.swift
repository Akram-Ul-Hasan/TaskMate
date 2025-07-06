//
//  TMHomeTaskRowView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 6/7/25.
//

import SwiftUI

struct TMHomeTaskRowView: View {
    let task: Task
    let onToggleStar: () -> Void
    let onToggleComplete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // Checkbox circle
            Button(action: {
                onToggleComplete()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .blue : .gray)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(task.name ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)

                // Subtitle/details (if exists)
                if let details = task.details, !details.isEmpty {
                    Text(details)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                // Date and Time (if exists)
                if let date = task.date, let time = task.time {
                    let formatted = format(date: date, time: time)
                    Text(formatted)
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                }
            }

            Spacer()

            // Star icon
            Button(action: {
                onToggleStar()
            }) {
                Image(systemName: task.isStarred ? "star.fill" : "star")
                    .foregroundColor(task.isStarred ? .blue : .gray)
            }
        }
        .padding(.vertical, 8)
    }

    private func format(date: Date, time: Date) -> String {
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(date)

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let datePart = isToday ? "Today" : DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        let timePart = timeFormatter.string(from: time)

        return "\(datePart), \(timePart)"
    }
}

//#Preview {
//    let task = Task()
//    TMHomeTaskRowView(task: task)
//}
