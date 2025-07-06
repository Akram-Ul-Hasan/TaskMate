//
//  TMCustomCalenderView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 24/6/25.
//

import SwiftUI


struct TMCustomCalenderView: View {
    @State private var selectedDate = Date()
    @State private var currentMonthOffset = 0

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button(action: {
                    currentMonthOffset -= 1
                }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()
                
                Text(monthYearText)
                    .font(.headline)
                
                Spacer()

                Button(action: {
                    currentMonthOffset += 1
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            // Calendar grid
            let days = generateCalendarDays()
            let columns = Array(repeating: GridItem(.flexible()), count: 7)

            LazyVGrid(columns: columns, spacing: 10) {
                // Weekday headers
                ForEach(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"], id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Dates
                ForEach(days, id: \.self) { date in
                    Text(dateText(date))
                        .frame(width: 36, height: 36)
                        .background(
                            Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                ? Color.blue
                                : Color.clear
                        )
                        .foregroundColor(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }

    // MARK: - Helpers

    var monthYearText: String {
        let date = Calendar.current.date(byAdding: .month, value: currentMonthOffset, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }

    func generateCalendarDays() -> [Date] {
        let calendar = Calendar.current
        let baseDate = calendar.date(byAdding: .month, value: currentMonthOffset, to: Date())!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)

        var days: [Date] = []

        let offset = (firstWeekday + 5) % 7 // Adjust for Monday start

        // Fill in blanks before month starts
        for i in 0..<offset {
            days.append(calendar.date(byAdding: .day, value: -offset + i, to: startOfMonth)!)
        }

        // Add actual month days
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        for day in range {
            days.append(calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!)
        }

        return days
    }

    func dateText(_ date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        return "\(day)"
    }
}

#Preview {
    TMCustomCalenderView()
}
