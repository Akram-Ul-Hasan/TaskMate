//
//  View + Extensions.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 21/6/25.
//

import SwiftUI

extension View {
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
