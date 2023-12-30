//
//  HomeBuilder.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation

class HomeBuilder {
    static func build() -> HomeController {
        let homeRouter = HomeRouter()
        let homeViewModel = HomeViewModel(
            homeRouter: homeRouter
        )
        let homeController = HomeController(viewModel: homeViewModel)
        homeRouter.homeController = homeController
        return homeController
    }
}
