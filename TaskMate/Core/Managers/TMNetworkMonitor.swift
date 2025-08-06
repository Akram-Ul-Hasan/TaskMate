//
//  TMNetworkMonitor.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 7/30/25.
//

import Foundation
import Network

final class TMNetworkMonitor: ObservableObject {
    static let shared = TMNetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = true
    @Published var connectionType: NWInterface.InterfaceType = .other
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first(where: { path.usesInterfaceType($0.type) })?.type ?? .other
            }
        }
        monitor.start(queue: queue)
    }
}
