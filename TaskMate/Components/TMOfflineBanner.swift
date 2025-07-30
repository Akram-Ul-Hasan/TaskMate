//
//  TMOfflineBanner.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 7/30/25.
//

import SwiftUI

struct TMOfflineBanner: View {
    var body: some View {
        Text("No Internet Connection")
            .font(.footnote)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: 0.3), value: UUID())
    }
}

#Preview {
    TMOfflineBanner()
}
