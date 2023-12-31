//
//  HomeBuilder.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation
import UIKit

class HomeBuilder {
    static func build() -> HomeController {
        let dependencyContainer = DependencyContainer.shared
        let homeRouter = HomeRouter()
        let homeViewModel = HomeViewModel(
            homeRouter: homeRouter,
            tokenAPI: dependencyContainer.tokenAPI(),
            taskAPI: dependencyContainer.taskAPI()
        )
        let homeController = HomeController(viewModel: homeViewModel)
        homeRouter.homeController = homeController
        return homeController
    }
}
