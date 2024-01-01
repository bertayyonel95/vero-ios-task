//
//  LoadingManager.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Loading
protocol Loading {
    func show()
    func hide()
}

// MARK: - LoadingManager
final class LoadingManager: Loading {
    
    // MARK: Properties
    static let shared: LoadingManager = .init()
    
    // MARK: Init
    private init() { }
    
    // MARK: Views
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .black
        return activityIndicator
    }()
}

extension LoadingManager {
    enum Constants {
        static let cornerRadius = 8.0
        static let loadingViewWidth = 74.0
        static let loadingViewHeight = 74.0
        static let activtyIndicatorWidth = 66.0
        static let activtyIndicatorHeight = 66.0
    }
}

// MARK: - Helpers
extension LoadingManager {
    /// Show loading view
    func show() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    self.setupLoadingView(on: window)
                }
            }
        }
    }
    
    /// Hide loading view
    func hide() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                DispatchQueue.main.async {[weak self] in
                    guard let self else { return }
                    self.loadingView.removeFromSuperview()
                    window.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private func setupLoadingView(on window: UIWindow) {
        window.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        window.bringSubviewToFront(loadingView)
        window.isUserInteractionEnabled = false
        
        loadingView.snp.makeConstraints() { make in
            make.centerX.equalTo(window.snp.centerX)
            make.centerY.equalTo(window.snp.centerY)
            make.width.equalTo(Constants.loadingViewWidth)
            make.height.equalTo(Constants.loadingViewHeight)
        }
        
        activityIndicator.snp.makeConstraints() { make in
            make.centerX.equalTo(loadingView.snp.centerX)
            make.centerY.equalTo(loadingView.snp.centerY)
            make.width.equalTo(Constants.activtyIndicatorWidth)
            make.height.equalTo(Constants.activtyIndicatorHeight)
        }
    }
}
