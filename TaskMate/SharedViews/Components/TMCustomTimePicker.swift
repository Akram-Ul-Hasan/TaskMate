//
//  TMCustomTimePicker.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 24/6/25.
//

import SwiftUI

struct TMCustomTimePicker: View {
    @State private var selectedHour = 10
    @State private var selectedMinute = 30
    @State private var selectedPeriod = "AM"

    var body: some View {
        HStack(spacing: 0) {
            // Hour picker
            Picker(selection: $selectedHour, label: Text("Hour")) {
                ForEach(1..<13) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 80)
            .clipped()

            // Minute picker
            Picker(selection: $selectedMinute, label: Text("Minute")) {
                ForEach(0..<60) { minute in
                    Text(String(format: "%02d", minute)).tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 80)
            .clipped()

            // AM/PM picker
            Picker(selection: $selectedPeriod, label: Text("Period")) {
                Text("AM").tag("AM")
                Text("PM").tag("PM")
            }
            .pickerStyle(.wheel)
            .frame(width: 80)
            .clipped()
        }
        .frame(height: 180)
    }
}

#Preview {
    TMCustomTimePicker()
}
