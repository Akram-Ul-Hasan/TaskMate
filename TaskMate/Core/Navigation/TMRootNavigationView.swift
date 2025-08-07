//
//  RootNavigationView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI

 struct TMRootNavigationView: View {
     @EnvironmentObject var coordinator: NavigationCoordinator
     @Environment(\.managedObjectContext) private var context
     
     var body: some View {
         Group {
             switch coordinator.appState {
             case .splash:
                 TMWelcomeScreen()
                     .onAppear {
                         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                             coordinator.navigateToMain()
                         }
                     }
                 
             case .onboarding:
                 TMOnboardingScreen()
                 
//             case .authentication:
//                 AuthContainerView()
//                 
             case .main:
                 TMMainNavigationView()
                 
             default:
                 EmptyView()
             }
         }
         .animation(.easeInOut(duration: 0.3), value: coordinator.appState)
     }
 }

