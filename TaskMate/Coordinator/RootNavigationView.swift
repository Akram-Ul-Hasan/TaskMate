//
//  RootNavigationView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI

struct RootNavigationView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            TMHomeScreen()
                .navigationDestination(for: CoordinatorRoute.self) { route in
                    switch route {
                    case .taskDetails(let taskID):
                        EmptyView()
                    }
                }
                .sheet(item: $coordinator.sheetRoute) { route in
                    switch route {
                    case .newTask:
                        EmptyView()
                    case .taskOptions(let taskID):
                        EmptyView()

                    case .datePicker(let taskID):
                        EmptyView()

                    case .repeatOptions(let taskID):
                        EmptyView()

                    case .listSelector:
                        EmptyView()

                    }
                }
        }
    }
}
