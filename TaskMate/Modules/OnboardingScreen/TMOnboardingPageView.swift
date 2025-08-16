//
//  TMOnboardingPageView.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/7/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI

struct TMOnboardingPageView: View {
    let page: TMOnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.8))
            
            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                Text(page.description)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
#Preview {
    TMOnboardingPageView(page:  TMOnboardingPage(
        image: "checkmark.circle.fill",
        title: "Welcome to TaskMaster",
        description: "Organize your tasks efficiently with our powerful task management system.")
    )
}
