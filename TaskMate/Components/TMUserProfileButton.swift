//
//  TMUserProfileButton.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/5/25.
//

import SwiftUI

struct TMUserProfileButton: View {
    let photoURL: URL?
    
    var body: some View {
        AsyncImage(url: photoURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
            default:
                Image(systemName: TMImages.profilePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
        }
    }
}
