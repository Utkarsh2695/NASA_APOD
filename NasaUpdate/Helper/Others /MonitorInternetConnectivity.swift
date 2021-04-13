//
//  MonitorInternetConnectivity.swift
//  NasaUpdate
//
//  Created by Utkarsh Upadhyay (BLR GSS) on 13/04/21.
//

import Foundation
import Network

class MonitorInternetConnectivity {

    // MARK: - Private Properties

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    private var isConnectedToInternet = false

    // MARK: - public method

    func isConnected() -> Bool {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {
                return
            }
            if path.status == .satisfied {
                self.isConnectedToInternet = true
                print("We're connected!")
            } else {
                self.isConnectedToInternet = false
                print("No connection.")
            }
        }
        monitor.start(queue: queue)
        return isConnectedToInternet
    }
}
