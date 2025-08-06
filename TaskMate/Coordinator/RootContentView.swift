//
//  ContentView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 17/6/25.
//

import SwiftUI

struct TMRootContentView: View {
    @EnvironmentObject var appState: TMAppState

    var body: some View {
        Group {
            if appState.isCheckingUser {
                TMOnboardingScreen()
            } else if appState.currentUser != nil {
                TMHomeScreen()
            } else {
                TMWelcomeScreen()
            }
        }
        .animation(.easeInOut, value: appState.isCheckingUser)
        .transition(.opacity)
    }
}
#Preview {
    TMRootContentView()
        .environmentObject(TMAppState())
}
