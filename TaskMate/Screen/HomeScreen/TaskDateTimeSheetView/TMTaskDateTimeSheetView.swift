//
//  TMTaskDateTimeSheetView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 2/7/25.
//

import SwiftUI

enum FocusedSection {
    case date, time
}
  
struct TMTaskDateTimeSheetView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator

    @Binding var selectedDate: Date
    @Binding var selectedTime: Date?
    @Binding var repeatOption: RepeatType

    @State private var focused: FocusedSection = .date

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            header
                .padding(.bottom, 20)

            // MARK: - Date Section
            Group {
                if focused == .date {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .padding(.bottom, 16)
                } else {
                    SectionHeader(
                        title: selectedDateFormatted,
                        isSelected: false,
                        onTap: {
                            withAnimation {
                                focused = .date
                            }
                        }
                    )
                }
            }

            
            // MARK: - Time Section
            SectionHeader(
                title: selectedTimeFormatted,
                isSelected: focused == .time,
                showClear: selectedTime != nil,
                onClear: {
                    withAnimation {
                        selectedTime = nil
                    }
                },
                onTap: {
                    withAnimation {
                        focused = .time
                        if selectedTime == nil {
                            selectedTime = Date() // Default to now
                        }
                    }
                }
            )

            if focused == .time, let timeBinding = Binding($selectedTime) {
                DatePicker(
                    "",
                    selection: timeBinding,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 180)
                .clipped()
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            SectionHeader(
                title: repeatOption.description,
                    isSelected: false,
                    onTap: {
                        // Show repeat options
                        print("Repeat tapped")
                        // Present sheet or navigate
                    }
                )
        }
        .padding()
    }
    
    
    private var header: some View {
        HStack {
            Text("Date and time")
                .font(.headline)
            Spacer()
            Button("Done") {
                coordinator.dismissSheet()
            }
        }
        .padding()
    }

    private var selectedTimeFormatted: String {
        if let time = selectedTime {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: time)
        } else {
            return "Select Time"
        }
    }
    
    private var selectedDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM" // e.g., "Thu, 3 Jul"
        return formatter.string(from: selectedDate)
    }

}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date?
    @State private var repeatOption: RepeatType = .noRepeat

    var body: some View {
        TMTaskDateTimeSheetView(
            selectedDate: $selectedDate, selectedTime: $selectedTime,
            repeatOption: $repeatOption
        )
        .environmentObject(AppCoordinator())
    }
}


struct SectionHeader: View {
    let title: String
    let isSelected: Bool
    var showClear: Bool = false
    var onClear: (() -> Void)? = nil
    var onTap: () -> Void

    var body: some View {
        HStack {
            Button(action: onTap) {
                HStack {
                    Text(title)
                        .foregroundColor(title == "Select Time" ? .gray : .primary)
                        .fontWeight(isSelected ? .bold : .regular)
                    Spacer()
                }
            }
            
            if showClear, let onClear = onClear {
                Button(action: onClear) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.medium)
                }
            }
        }
        .padding()
        .contentShape(Rectangle())
    }
}
