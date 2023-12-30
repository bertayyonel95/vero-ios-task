//
//  HomeViewModel.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation

// MARK: - HomeViewModelInput
protocol HomeViewModelInput {
    // MARK: Properties
    var output: HomeViewModelOutput? { get set }
}

// MARK: - HomeViewModelOutput
protocol HomeViewModelOutput: AnyObject {
    
}

// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput  {
    //MARK: Properties
    private var homeRouter: HomeRouting
    weak var output: HomeViewModelOutput?
     
    
    init(homeRouter: HomeRouting) {
        self.homeRouter = homeRouter
    }
}
