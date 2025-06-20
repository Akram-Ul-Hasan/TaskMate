//
//  TMOnboardingScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import SwiftUI
import Lottie

struct TMOnboardingScreen: View {
    
    
    var body: some View {
        
        //loading lottie view
        LottieView(animation: .named("welcome_animation"))
            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
            .ignoresSafeArea()
            .frame(width: 120)
            .background(.whiteLevel1)
    }
    
}

#Preview {
    TMOnboardingScreen()
}
