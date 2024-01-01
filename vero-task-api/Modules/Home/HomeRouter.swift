//
//  HomeRouter.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import UIKit

protocol HomeRouting {
    var homeController: HomeController? { get set }
    func navigateToQRScanner()
}

class HomeRouter: HomeRouting {
    var homeController: HomeController?
    
    func navigateToQRScanner() {
        let qrVC = QRScannerController()
        qrVC.delegate = homeController
        qrVC.modalTransitionStyle = .coverVertical
        homeController?.present(qrVC, animated: true)
    }
}
