//
//  HomeRouter.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import UIKit

protocol HomeRouting {
    var homeController: HomeController? { get set }
}

class HomeRouter: HomeRouting {
    var homeController: HomeController?
}
