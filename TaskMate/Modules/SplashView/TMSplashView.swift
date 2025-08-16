//
//  TMSplashView.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/7/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI
import Lottie

struct TMSplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            VStack {
                                
                LottieView(animation: .named("welcome_animation"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .frame(width: 300, height: 100)
                
//                Image(systemName: "checkmark.circle.fill")
//                    .font(.system(size: 60))
//                    .foregroundColor(.white)
                Text("TaskMate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}


#Preview {
    TMSplashView()
}
