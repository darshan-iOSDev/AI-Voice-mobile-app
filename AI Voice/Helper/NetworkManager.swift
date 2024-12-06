//
//  NetworkManager.swift
//  Quizer
//
//  Created by Chiku on 14/10/24.
//

import UIKit
import Network

class NetworkManager {
    
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isNetworkReachable = true
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                // Network is not reachable
                if self.isNetworkReachable {
                    self.isNetworkReachable = false
                    DispatchQueue.main.async {
                        self.showNetworkAlert()
                    }
                }
            } else {
                // Network is reachable again
                self.isNetworkReachable = true
            }
        }
    }
    
    func showNetworkAlert() {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            let alertController = UIAlertController(title: "No Internet Connection",
                                                    message: "Please check your internet connection.",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            // Present the alert on the rootViewController
            rootVC.present(alertController, animated: true, completion: nil)
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
