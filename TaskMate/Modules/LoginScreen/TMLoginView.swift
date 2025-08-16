//
//  TMLoginView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 8/7/25.
//

import SwiftUI

struct TMLoginView: View {
    
    @EnvironmentObject var authManager: TMAuthManager
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                    
                    Text("TaskMate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Organize your life, one task at a time")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button(action: authManager.signInWithGoogle) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.title2)
                            
                            Text("Sign in with Google")
                                .font(.headline)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    .disabled(authManager.isLoading)
                    
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .overlay {
            if authManager.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
    }
}

#Preview {
    TMLoginView()
        .environmentObject(TMAuthManager.shared)
}
