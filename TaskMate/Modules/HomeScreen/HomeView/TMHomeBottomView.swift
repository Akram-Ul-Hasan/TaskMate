//
//  TMHomeBottomView.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 22/6/25.
//

import SwiftUI

struct TMHomeBottomView: View {
    var onMenuTap: () -> Void
    var onAddTaskTap: () -> Void
    var onMoreTap: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        onMenuTap()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onMoreTap()
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 30)
                .frame(height: 80)
                .background(Color.white.shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: -2))
            }
            
            VStack {
                Spacer()
                Button(action: {
                    onAddTaskTap()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .offset(y: -50)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    TMHomeBottomView(
            onMenuTap: {
                print("Menu tapped")
            },
            onAddTaskTap: {
                print("Add Task tapped")
            },
            onMoreTap: {
                print("More tapped")
            }
        )

}
