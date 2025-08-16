//
//  TMRepeatType.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/14/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

enum TMRepeatType: CaseIterable {
    case noRepeat
    case daily
    case weekly
    case monthly
    case yearly
    case custom

    var description: String {
        switch self {
        case .noRepeat:
            return "Does not repeat"
        case .daily:
            return "Repeats daily"
        case .weekly:
            return "Repeats weekly"
        case .monthly:
            return "Repeats monthly"
        case .yearly:
            return "Repeats yearly"
        case .custom:
            return "Custom repeat"
        }
    }
}
