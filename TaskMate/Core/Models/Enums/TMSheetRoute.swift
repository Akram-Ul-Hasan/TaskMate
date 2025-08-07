//
//  TMSheetRoute.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/6/25.
//

import Foundation

enum TMSheetRoute: Identifiable, Hashable, CaseIterable {
    
    case newTask(listID: String?)
    case editTask(taskID: String)
    case taskOptions(taskID: String)
    case listOptions(listID: String)
    case listSelector
    case sortFilter(currentSort: TMSortOption, currentFilter: TMFilterOption)
    case settings
    case account
    case about
    
    // MARK: - Identifiable Conformance
    var id: String {
        switch self {
        case .newTask(let listID):
            return "newTask_\(listID ?? "none")"
        case .editTask(let taskID):
            return "editTask_\(taskID)"
        case .taskOptions(let taskID):
            return "taskOptions_\(taskID)"
        case .listOptions(let listID):
            return "listOptions_\(listID)"
        case .listSelector:
            return "listSelector"
        case .sortFilter(let currentSort, let currentFilter):
            return "sortFilter_\(currentSort.rawValue)_\(currentFilter.rawValue)"
        case .settings:
            return "settings"
        case .account:
            return "account"
        case .about:
            return "about"
        }
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .newTask(let listID):
            hasher.combine("newTask")
            hasher.combine(listID)
        case .editTask(let taskID):
            hasher.combine("editTask")
            hasher.combine(taskID)
        case .taskOptions(let taskID):
            hasher.combine("taskOptions")
            hasher.combine(taskID)
        case .listOptions(let listID):
            hasher.combine("listOptions")
            hasher.combine(listID)
        case .listSelector:
            hasher.combine("listSelector")
        case .sortFilter(let currentSort, let currentFilter):
            hasher.combine("sortFilter")
            hasher.combine(currentSort)
            hasher.combine(currentFilter)
        case .settings:
            hasher.combine("settings")
        case .account:
            hasher.combine("account")
        case .about:
            hasher.combine("about")
        }
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: TMSheetRoute, rhs: TMSheetRoute) -> Bool {
        switch (lhs, rhs) {
        case (.newTask(let lhsListID), .newTask(let rhsListID)):
            return lhsListID == rhsListID
        case (.editTask(let lhsTaskID), .editTask(let rhsTaskID)):
            return lhsTaskID == rhsTaskID
        case (.taskOptions(let lhsTaskID), .taskOptions(let rhsTaskID)):
            return lhsTaskID == rhsTaskID
        case (.listOptions(let lhsListID), .listOptions(let rhsListID)):
            return lhsListID == rhsListID
        case (.listSelector, .listSelector),
             (.settings, .settings),
             (.account, .account),
             (.about, .about):
            return true
        case (.sortFilter(let lhsSort, let lhsFilter), .sortFilter(let rhsSort, let rhsFilter)):
            return lhsSort == rhsSort && lhsFilter == rhsFilter
        default:
            return false
        }
    }
    
    static var allCases: [TMSheetRoute] {
        [
            .newTask(listID: nil),
            .newTask(listID: "sample-list-id"),
            .editTask(taskID: "sample-task-id"),
            .taskOptions(taskID: "sample-task-id"),
            .listOptions(listID: "sample-list-id"),
            .listSelector,
            .sortFilter(currentSort: .dueDate, currentFilter: .all),
            .settings,
            .account,
            .about
        ]
    }
}
