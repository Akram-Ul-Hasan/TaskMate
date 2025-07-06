//
//  TMHomeViewModel.swift
//  TaskMate
//
//  Created by Akram Ul Hasan on 20/6/25.
//

import Foundation

class TMHomeViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isFirstLunch: Bool = true
    @Published var isSignedIn: Bool = false
    
    func fetchData() {
        
    }
}
