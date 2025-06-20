//
//  TMWelcomeScreen.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import SwiftUI
import Lottie

struct TMWelcomeScreen: View {
    
    var body: some View {
        
        VStack(spacing: 30) {
            Spacer()
            
            //Welcome image
            Image("welcome")
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
            
            //Welcome title
            Text("Welcome to Tasks")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            // Welcome subtitle
            Text("Keep track of important things that you need to get done in one place.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Get started btn
            Button(action: {
                
            }) {
                Text("Get started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TMWelcomeScreen()
}
