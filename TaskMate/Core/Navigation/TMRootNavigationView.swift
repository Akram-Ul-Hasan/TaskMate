//
//  RootNavigationView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI

 struct TMRootNavigationView: View {
     @EnvironmentObject var coordinator: TMNavigationCoordinator
     @Environment(\.managedObjectContext) private var context
     
     var body: some View {
         Group {
             switch coordinator.appState {
             case .splash:
                 TMSplashView()
                     .onAppear {
                         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                             coordinator.navigateToMain()
                         }
                     }
                 
             case .onboarding:
                 TMOnboardingScreen()
                 
             case .authentication:
                 TMLoginView()
                 
             case .main:
                 TMMainNavigationView()
             }
         }
         .animation(.easeInOut(duration: 0.3), value: coordinator.appState)
     }
 }

