//
//  NetworkState.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI
import Network

public class NetworkState: ObservableObject {
    
    @Published public var isMonitoring = false
    @Published public var isOnline = false
    @Published public var status = NWPath.Status.requiresConnection
        
    var monitor: NWPathMonitor?
    
    public var isStatusSatisfied: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    public var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    public var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    public var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    public init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if self.status != path.status {
                    self.status = path.status
                    self.isOnline = path.status == .satisfied ? true : false
                }
            }
        }
        
        isMonitoring = true
    }
    
    public func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
    
    @discardableResult
    public func isConnected() -> Bool? {
        guard isMonitoring else { return nil }
        isOnline = isStatusSatisfied
        return isOnline
    }
    
}
