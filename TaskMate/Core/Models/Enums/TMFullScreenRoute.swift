//
//  TMFullScreenRoute.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import Foundation

enum TMFullScreenRoute: Identifiable, Hashable {
    case onboarding
    case auth(mode: TMAuthMode)
    case taskRepeatOptions(taskID: String)
    case dateTimePicker(task: Task?)
    
    var id: String {
        switch self {
        case .onboarding: return "onboarding"
        case .auth(let mode): return "auth-\(mode.rawValue)"
        case .taskRepeatOptions: return "taskRepeatOptions"
        case .dateTimePicker: return "dateTimePicker"
        }
    }
    
    static func == (lhs: TMFullScreenRoute, rhs: TMFullScreenRoute) -> Bool {
        switch (lhs, rhs) {
        case (.onboarding, .onboarding):
            return true
        case (.auth(let lhsMode), .auth(let rhsMode)):
            return lhsMode == rhsMode
        case (.taskRepeatOptions(let lhsTaskID), .taskRepeatOptions(let rhsTaskID)):
            return lhsTaskID == rhsTaskID
        case (.dateTimePicker(let lhsTask), .dateTimePicker(let rhsTask)):
            return lhsTask?.id == rhsTask?.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var allCases: [TMFullScreenRoute] {
        [
            .onboarding,
            .auth(mode: .signIn),
            .taskRepeatOptions(taskID: "sample-task-id"),
            .dateTimePicker(task: nil)
        ]
    }
}
