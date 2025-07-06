//
//  TMAppState.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 23/6/25.
//

import Foundation
import FirebaseAuth

final class TMAppState: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var isCheckingUser = true

    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.currentUser = user
                self.isCheckingUser = false
            }
        }
    }
}
