//
//  DependencyContainer.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    private init() {}
    
    func networkManager() -> Networking {
        NetworkManager(session: .shared)
    }
    
    func tokenAPI() -> TokenFetchable {
        TokenAPI(networkManager: self.networkManager())
    }
    
    func taskAPI() -> TaskFetchable {
        TaskAPI(networkManager: self.networkManager())
    }
}
