//
//  HomeController.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import UIKit

// MARK: - HomeController
final class HomeController: UIViewController {
    private var viewModel: HomeViewModelInput
    
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
    }
    
    // MARK: deinit
    deinit {
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
}
