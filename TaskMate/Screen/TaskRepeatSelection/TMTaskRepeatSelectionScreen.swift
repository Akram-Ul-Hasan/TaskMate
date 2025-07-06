//
//  TMTaskRepeatSelectionScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 2/7/25.
//

import SwiftUI

enum RepeatType: CaseIterable {
    case noRepeat
    case daily
    case weekly
    case monthly
    case yearly
    case custom

    var description: String {
        switch self {
        case .noRepeat:
            return "Does not repeat"
        case .daily:
            return "Repeats daily"
        case .weekly:
            return "Repeats weekly"
        case .monthly:
            return "Repeats monthly"
        case .yearly:
            return "Repeats yearly"
        case .custom:
            return "Custom repeat"
        }
    }
}

struct TMTaskRepeatSelectionScreen: View {
    @EnvironmentObject private var coordinator : AppCoordinator
    
    var body: some View {
        ScrollView {
            VStack {
//                List(RepeatType.allCases) { item in
//                    
//                }
                Text("This is repeat option selection view")
            }
            .navigationTitle("Repeat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        coordinator.dismissFullScreen()
                    } label: {
                        Image(systemName: "multiply")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TMTaskRepeatSelectionScreen()
    }
}
