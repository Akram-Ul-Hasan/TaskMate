//
//  TMOnboardingScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import SwiftUI

struct TMOnboardingScreen: View {
    
    @EnvironmentObject var settingsManager: TMSettingsManager
    @EnvironmentObject var coordinator: TMNavigationCoordinator
    
    @State private var currentPage = 0
    
    private let pages = [
        TMOnboardingPage(
            image: "checkmark.circle.fill",
            title: "Welcome to TaskMaster",
            description: "Organize your tasks efficiently with our powerful task management system."
        ),
        TMOnboardingPage(
            image: "calendar",
            title: "Calendar Integration",
            description: "View your tasks in a beautiful calendar layout and never miss a deadline."
        ),
        TMOnboardingPage(
            image: "cloud.fill",
            title: "Cloud Sync",
            description: "Your tasks are synced across all your devices with Firebase integration."
        ),
        TMOnboardingPage(
            image: "bell.fill",
            title: "Smart Notifications",
            description: "Get reminded about your important tasks at the right time."
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        TMOnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        settingsManager.completeOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    TMOnboardingScreen()
        .environmentObject(TMSettingsManager.shared)
        .environmentObject(TMNavigationCoordinator())
}


