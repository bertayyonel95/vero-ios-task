//
//  ErrorHandler.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 2.01.2024.
//

import UIKit

class ErrorHandler {
    
    static let shared = ErrorHandler()
    
    private init() {} // Private initializer to ensure singleton
    
    func showError(message: String, duration: TimeInterval = 3.0) {
        guard let topViewController = UIApplication.topViewController() else {
            // If there's no top-level view controller, you can't present the error
            print("Unable to find top-level view controller to present error.")
            return
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        topViewController.present(alertController, animated: true, completion: nil)
        
        // Automatically dismiss the alert after the specified duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
