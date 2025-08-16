//
//  TMTaskRepeatSelectionScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 2/7/25.
//

import SwiftUI

struct TMTaskRepeatSelectionScreen: View {
    @EnvironmentObject private var coordinator : TMNavigationCoordinator
    
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
