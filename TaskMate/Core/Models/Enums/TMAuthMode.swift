//
//  TMAuthMode.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 8/6/25.
//

import Foundation

enum TMAuthMode: String, CaseIterable, Hashable {
    case signIn = "signIn"
    case signUp = "signUp"
    case resetPassword = "resetPassword"
    
    var displayName: String {
        switch self {
        case .signIn:
            return "Sign In"
        case .signUp:
            return "Sign Up"
        case .resetPassword:
            return "Reset Password"
        }
    }
}
