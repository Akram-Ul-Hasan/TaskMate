//
//  TMEmptyView.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 7/14/25.
//

import SwiftUI

struct TMEmptyView: View {
    
    let imageName: String
    let title: String
    let subtitle: String?
    
    var body: some View {
        
        VStack {
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            
            
            Text(title)
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
            
            
            
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .multilineTextAlignment(.center)
                    
                
            }
        }
    }
}

#Preview {
    TMEmptyView(imageName: "emptyTask", title: "No Tasks", subtitle: "Add your first task Add your first task Add your first task")
        
}
